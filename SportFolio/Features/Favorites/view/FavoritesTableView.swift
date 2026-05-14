//
//  FavoritesTableView.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 01/05/2026.
//

import UIKit
 import UIKit
import SDWebImage

protocol FavoritesView: AnyObject {
    func reloadData()
    func showDeleteConfirmation( indexPath :IndexPath)
    func showNoInternet()
}

class FavoritesTableView: UITableViewController {
    
    private let presenter = FavoritesPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        presenter.attachView(self)
        title = L10n.navFavorites
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
        tableView.backgroundColor = .appBackground
    }
    
    private func showEmptyStateIfNeeded() {
        guard presenter.getSectionsCount() == 0 else {
            tableView.backgroundView = nil
            return
        }
        
        tableView.backgroundView = showWhenEmpty(
            iconText: "♥️",
            titleText: L10n.emptyFavoritesTitle,
            subtitleText: L10n.emptyFavoritesSubtitle
        )
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
    
    func showDeleteConfirmation( indexPath :IndexPath)
    {
        AlertManager.showDeleteConfirmation(on: self) { [weak self] in
            
            guard let self = self,
                  let favorite = self.presenter.getFavorite(
                    section: indexPath.section,
                    row: indexPath.row
                  ) else { return }
            
            CoreDataManager.shared.removeFavorite(
                leagueKey: favorite.leagueKey
            )
            
            self.presenter.loadFavorites()
        }
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
        header.backgroundColor = .appBackground
        
        let label = UILabel()
        label.text      = presenter.getSectionTitle(at: section)
        label.font      = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .primaryBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        
        header.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -16),
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
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            showDeleteConfirmation(indexPath:  indexPath)
        }
    }
    
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
            league: leagueModel,
            network: NetworkServiceImpl.shared,
            coreData: CoreDataManager.shared
        )
        
        detailsPresenter.view = detailsVC
        detailsVC.leaguesDetailsPresenter = detailsPresenter
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
