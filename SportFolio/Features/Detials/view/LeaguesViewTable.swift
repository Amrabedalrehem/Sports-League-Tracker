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
   
}

class LeaguesViewTable: UITableViewController, LeaguesView {
   
    
    var sportType :SportType?
    var presenter = LeaguesPresenter()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Leagues"
        setupTableView()
        setupActivityIndicator()
        
        presenter.attachView(self)
               
        presenter.fetchLeagues()
    }
    private func setupTableView() {
        tableView.register(UINib(nibName: "cellDetials", bundle: nil), forCellReuseIdentifier: "LeagueCell")
        tableView.rowHeight = 90
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
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

        let league = presenter.getLeague(at: indexPath.row)

        let detailsVC = storyboard?
            .instantiateViewController(withIdentifier: "LeaguesDetailsCollectionViewController")
            as! LeaguesDetailsCollectionViewController

   
        let detailsPresenter = LeaguesDetailsPresenter(
            sportType: presenter.sportType!,
            leagueId: league.leagueKey
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
        
        cell.leagueNameLabel.text = league.leagueName
        cell.countryNameLabel.text = league.countryName
        cell.leagueImageView.sd_setImage(
            with: URL(string: league.leagueLogo ?? ""),
            placeholderImage: UIImage(named: "placeholder")
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
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    
    
}


