//
//  LeaguesViewTable.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 30/04/2026.
//

import UIKit
import SDWebImage
import SkeletonView
protocol LeaguesView: AnyObject {
    func reloadData()
    func startAnimating()
    func stopAnimating()
    func showError(message: String)
    func showNoInternet()
    func showEmptyState()
    func hideEmptyState()  
   
}

class LeaguesViewTable:  UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private let searchController = UISearchController(searchResultsController: nil)
    var sportType :SportType?
    var presenter = LeaguesPresenter()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          applyNavBarAppearance()
        setupSearchBar()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            applyNavBarAppearance()
            setupSearchBar()
        }
    }

    private func applyNavBarAppearance() {
     let appearance = UINavigationBarAppearance()
     appearance.configureWithOpaqueBackground()
     appearance.backgroundColor   = .tabBarGradientStart
     appearance.shadowColor       = .clear

     let titleAttrs: [NSAttributedString.Key: Any] = [
         .foregroundColor: UIColor.white,
         .font: UIFont.systemFont(ofSize: 18, weight: .bold)
     ]
     appearance.titleTextAttributes = titleAttrs

     navigationController?.navigationBar.standardAppearance    = appearance
     navigationController?.navigationBar.scrollEdgeAppearance  = appearance
     navigationController?.navigationBar.compactAppearance     = appearance
     navigationController?.navigationBar.tintColor             = .white
 }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = L10n.navLeagues
        setupTableView()
        tableView.isSkeletonable = true
        tableView.dataSource = self
        tableView.delegate = self

        searchBar.delegate = self
        setupSearchBar()
        tableView.register(UINib(nibName: "cellDetials", bundle: nil), forCellReuseIdentifier: "LeagueCell")
        self.tableView.isSkeletonable = true

        tableView.separatorStyle = .none
        setupActivityIndicator()
        presenter.attachView(self)
        presenter.fetchLeagues()
    }

    private func setupSearchBar() {
        searchBar.backgroundColor     = .appBackground
        searchBar.backgroundImage     = UIImage()   
        searchBar.barTintColor        = .appBackground
        searchBar.tintColor           = .primaryBlue

        let tf = searchBar.searchTextField
        tf.backgroundColor = .cardBackground
        tf.textColor       = .mainText
        tf.tintColor       = .primaryBlue
        tf.placeholder     = L10n.searchPlaceholder
        tf.font            = UIFont.systemFont(ofSize: 15, weight: .regular)
        if let icon = tf.leftView as? UIImageView {
            icon.tintColor = .secondaryLabel
        }
    }
    
    
    private func setupActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchLeagues(text: searchText)
    }
    
    
}


extension LeaguesViewTable :  UITableViewDataSource, UITableViewDelegate {
    private func setupTableView() {
        tableView.register(UINib(nibName: "cellDetials", bundle: nil), forCellReuseIdentifier: "LeagueCell")
        tableView.rowHeight       = 90
        tableView.separatorStyle  = .none
        tableView.backgroundColor = .appBackground
          }
   
  
    

   func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getLeaguesCount()
    }
      func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        UIView.animate(withDuration: 0.12, delay: 0, options: .curveEaseInOut) {
            cell.contentView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        UIView.animate(withDuration: 0.2, delay: 0,
                       usingSpringWithDamping: 0.6, initialSpringVelocity: 0.4) {
            cell.contentView.transform = .identity
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          if !presenter.isOnline() {
            showNoInternet()
            return
        }

        let league = presenter.getLeague(at: indexPath.row)
        let detailsVC = storyboard?.instantiateViewController(withIdentifier: "LeaguesDetailsCollectionViewController") as! LeaguesDetailsCollectionViewController

        let detailsPresenter = LeaguesDetailsPresenter(
            sportType: presenter.sportType!,
            league: league,
            network: NetworkServiceImpl.shared,
            coreData: CoreDataManager.shared
        )
        
        detailsPresenter.view = detailsVC
        detailsVC.leaguesDetailsPresenter = detailsPresenter
        navigationController?.pushViewController(detailsVC, animated: true)
    }
   
     
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueCell", for: indexPath) as? cellDetialsTableViewCell else {
            return UITableViewCell()
        }

        let league = presenter.getLeague(at: indexPath.row)

        cell.leagueNameLabel.text  = league.leagueName
        cell.countryNameLabel.text = league.countryName

        let placeholderName: String
        switch presenter.sportType {
        case .football:   placeholderName = "footballPlaceholder"
        case .basketball: placeholderName = "basketPlaceholder"
        case .cricket:    placeholderName = "ckrichetPlaceholder"
        case .tennis:     placeholderName = "tennisPlaceholder"
        case .none:       placeholderName = "footballPlaceholder"
        }
        let placeholder = UIImage(named: placeholderName)
        cell.leagueImageView.sd_setImage(
            with: URL(string: league.leagueLogo ?? ""),
            placeholderImage: placeholder
        )

        cell.selectionStyle = .none
        cell.contentView.isSkeletonable = true
        cell.isSkeletonable = true
        return cell
    }
}

extension LeaguesViewTable : LeaguesView {
    
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func startAnimating() {
        tableView.showAnimatedGradientSkeleton()
    }

    func stopAnimating() {
        tableView.hideSkeleton()
    }
    
    func showError(message: String) {
        let alert = UIAlertController(
            title: L10n.alertErrorTitle,
            message: "\n" + message,
            preferredStyle: .actionSheet
        )
        let titleAttr = NSAttributedString(
            string: L10n.alertErrorTitle,
            attributes: [
                .font: UIFont.systemFont(ofSize: 17, weight: .bold),
                .foregroundColor: UIColor.systemOrange
            ]
        )
        let msgAttr = NSAttributedString(
            string: "\n" + message,
            attributes: [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.secondaryLabel
            ]
        )
        alert.setValue(titleAttr, forKey: "attributedTitle")
        alert.setValue(msgAttr,   forKey: "attributedMessage")
        alert.addAction(UIAlertAction(title: L10n.alertOK, style: .cancel))
        present(alert, animated: true)
    }
    
    
    func showNoInternet() {
            stopAnimating()  
            NetworkMonitor.shared.showNoInternet(on: self)
        }
    
    func showEmptyState() {
        tableView.backgroundView = showWhenEmpty(
            iconText: "🔎",
            titleText: L10n.emptyLeaguesTitle,
            subtitleText: L10n.emptyLeaguesSubtitle
        )
    }
    
    func hideEmptyState() {
        tableView.backgroundView = nil
    }
    
}


extension LeaguesViewTable: SkeletonTableViewDataSource {

    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }

    func collectionSkeletonView(_ skeletonView: UITableView,
                                numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func collectionSkeletonView(_ skeletonView: UITableView,
                                cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "LeagueCell"
    }
}
