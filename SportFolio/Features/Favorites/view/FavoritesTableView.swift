//
//  FavoritesTableView.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 01/05/2026.
//

import UIKit

 
import SDWebImage
import UIKit
import SDWebImage
protocol FavoritesView: AnyObject {
    func reloadData()
    func showNoInternet()
}
class FavoritesTableView: UITableViewController {
 
    private let presenter = FavoritesPresenter()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        presenter.attachView(self)
        title = "Favorites"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.loadFavorites()
    }
     
    private func setupTableView() {
        tableView.register(
            UINib(nibName: "cellDetials", bundle: nil),
            forCellReuseIdentifier: "LeagueCell"
        )
        tableView.rowHeight       = 90
        tableView.separatorStyle  = .none
        tableView.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.98, alpha: 1)
    }
    
   
    private func showEmptyStateIfNeeded() {
        guard presenter.getSectionsCount() == 0 else {
            tableView.backgroundView = nil
            return
        }
        
        let stack = UIStackView()
        stack.axis  = .vertical
        stack.spacing   = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        let icon       = UILabel()
        icon.text       = "⭐"
        icon.font       = .systemFont(ofSize: 60)
        let title       = UILabel()
        title.text       = "No Favorites Yet"
        title.font       = .boldSystemFont(ofSize: 18)
        title.textColor  = .label
      let subtitle       = UILabel()
        subtitle.text       = "Add leagues from the Leagues screen"
        subtitle.font       = .systemFont(ofSize: 13)
        subtitle.textColor  = .secondaryLabel
        subtitle.textAlignment = .center
        subtitle.numberOfLines = 2
              stack.addArrangedSubview(icon)
        stack.addArrangedSubview(title)
        stack.addArrangedSubview(subtitle)
        
        let container = UIView()
        container.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -32)
        ])
        
        tableView.backgroundView = container
    }
}


extension FavoritesTableView: FavoritesView {
    
    func reloadData() {
        showEmptyStateIfNeeded()
        tableView.reloadData()
    }
    
    func showNoInternet() {
        NetworkMonitor.shared.showNoInternet(on: self)
    }
}


extension FavoritesTableView {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.getSectionsCount()
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return presenter.getRowsCount(in: section)
    }
  
    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.98, alpha: 1)
        
        let label = UILabel()
        label.text      = presenter.getSectionTitle(at: section).uppercased()
        label.font      = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor(red: 0.18, green: 0.42, blue: 0.92, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        header.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: header.centerYAnchor)
        ])
        return header
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
  
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "LeagueCell",
            for: indexPath
        ) as? cellDetialsTableViewCell else {
            return UITableViewCell()
        }

        guard let favorite = presenter.getFavorite(
            section: indexPath.section,
            row: indexPath.row
        ) else { return UITableViewCell() }

        cell.leagueNameLabel.text  = favorite.leagueName ?? ""
        cell.countryNameLabel.text = favorite.leagueCountry ?? ""

        let sport = SportType(rawValue: favorite.sportType ?? "") ?? .football

    


        cell.leagueImageView.sd_setImage(
            with: URL(string: favorite.leagueLogo ?? ""),
            placeholderImage: UIImage(named: sport.placeholderImageName)
        )

        cell.selectionStyle = .none
        return cell
    }
}


extension FavoritesTableView {
   
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
          guard presenter.isOnline() else {
            showNoInternet()
            return
        }
        
        guard let favorite = presenter.getSelectedFavorite(
            section: indexPath.section,
            row: indexPath.row
        ) else { return }
        
              guard let sportType = SportType(rawValue: favorite.sportType ?? "") else {
                return
        }
        
          let leagueModel = LeagueModel(
            leagueKey:   Int(favorite.leagueKey),
            leagueName:  favorite.leagueName,
            leagueLogo:  favorite.leagueLogo,
            countryKey:  nil,
            countryName: favorite.leagueCountry,
            countryLogo: nil
        )
        
           guard let detailsVC = storyboard?.instantiateViewController(
            withIdentifier: "LeaguesDetailsCollectionViewController"
        ) as? LeaguesDetailsCollectionViewController else { return }
        
        let detailsPresenter = LeaguesDetailsPresenter(
            sportType: sportType,
            league: leagueModel
        )
        detailsPresenter.view = detailsVC
        detailsVC.leaguesDetailsPresenter = detailsPresenter
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }
   

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete,
              let favorite = presenter.getFavorite(
                section: indexPath.section,
                row: indexPath.row
              ) else { return }
        
        CoreDataManager.shared.removeFavorite(leagueKey: (favorite.leagueKey))
        presenter.loadFavorites()
    }
}
