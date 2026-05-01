//
//  LeaguesDetailsCollectionViewController.swift
//  SportFolio
//
//  Created by shahudaa 
//


import UIKit

private let teamCellId = "TeamCollectionViewCell"

class LeaguesDetailsCollectionViewController: UICollectionViewController {

    var leaguesDetailsPresenter: LeaguesDetailsPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        fetchData()
    }

    

    private func setupCollectionView() {
        collectionView.register(
            UINib(nibName: "TeamCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: teamCellId
        )
    }

   

    private func fetchData() {

       
        leaguesDetailsPresenter.getTeams { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }

       
        leaguesDetailsPresenter.getEvents { _ in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("teams->\(leaguesDetailsPresenter.getNumberOfTeams())")
        print("up->\(leaguesDetailsPresenter.getNumberOfUpcomingEvents())")
        print("teams->\(leaguesDetailsPresenter.getNumberOfLatestEvents())")
       
        if section == 0 {
            return leaguesDetailsPresenter.getNumberOfTeams()
        } else {
            return leaguesDetailsPresenter.getNumberOfUpcomingEvents()
        }
    }

    

    override func collectionView(_ collectionView: UICollectionView,
                                  cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: teamCellId,
            for: indexPath
        ) as! TeamCollectionViewCell

        if indexPath.section == 0 {

            let team = leaguesDetailsPresenter.getTeam(at: indexPath.row)
            cell.teamLabel.text = team.teamName

        } else {

            let event = leaguesDetailsPresenter.getUpcomingEvent(at: indexPath.row)
            cell.teamLabel.text = event.eventAwayTeam
        }

        return cell
    }
}
