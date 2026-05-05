//
//  LeaguesViewTable.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 30/04/2026.
//

import UIKit
import SDWebImage
protocol LeaguesView: AnyObject {
    func reloadData()
    func startAnimating()
    func stopAnimating()
    func showError(message: String)
    func showNoInternet()
   
}

class LeaguesViewTable: UITableViewController, LeaguesView {
   
    private let searchController = UISearchController(searchResultsController: nil)
    var sportType :SportType?
    var presenter = LeaguesPresenter()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Leagues"
        setupTableView()
        setupSearchBar()
        setupActivityIndicator()
        presenter.attachView(self)
        presenter.fetchLeagues()
    }
    private func setupTableView() {
        tableView.register(UINib(nibName: "cellDetials", bundle: nil), forCellReuseIdentifier: "LeagueCell")
        tableView.rowHeight       = 90
        tableView.separatorStyle  = .none
        tableView.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.98, alpha: 1)

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = UIColor.black.withAlphaComponent(0.06)
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(red: 0.07, green: 0.09, blue: 0.20, alpha: 1),
            .font: UIFont.systemFont(ofSize: 17, weight: .bold)
        ]
        navigationController?.navigationBar.standardAppearance   = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance    = appearance
        navigationController?.navigationBar.tintColor = UIColor(red: 0.18, green: 0.42, blue: 0.92, alpha: 1)
    }
   
    
    private func setupActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getLeaguesCount()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
   
     
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            print(league.leagueLogo ?? "")
        cell.leagueImageView.sd_setImage(
            with: URL(string: league.leagueLogo ?? ""),
            placeholderImage: placeholder
        )

        cell.selectionStyle = .none
        return cell
    }
}

extension LeaguesViewTable {
    func reloadData() {
        tableView.reloadData()
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
    
    func showError(message: String) {
        let alert = UIAlertController(
            title: "⚠️  Something Went Wrong",
            message: "\n" + message,
            preferredStyle: .actionSheet
        )
        let titleAttr = NSAttributedString(
            string: "⚠️  Something Went Wrong",
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
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
    
    
    func showNoInternet() {
            stopAnimating()  
            NetworkMonitor.shared.showNoInternet(on: self)
        }
    
}


