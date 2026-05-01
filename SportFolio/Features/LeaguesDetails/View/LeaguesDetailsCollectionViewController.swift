//
//  LeaguesDetailsCollectionViewController.swift
//  SportFolio
//
//  Created by shahudaa 
//


import UIKit

private let teamCellId = "TeamCollectionViewCell"
private let upComingCellId = "UpcomingEventCollectionViewCell"
private let latestCellId = "TeamCollectionViewCell"
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
        
        collectionView.register(
            UINib(nibName: "UpcomingEventCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: upComingCellId
        )
        
        collectionView.register(
            UINib(nibName: "LatestEventCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: latestCellId
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
        return 3
    }

    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if section == 0 {
            return leaguesDetailsPresenter.getNumberOfUpcomingEvents()
        }
        else if section == 1
            {
            return leaguesDetailsPresenter.getNumberOfLatestEvents()
        
        } else {
            return leaguesDetailsPresenter.getNumberOfTeams()
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
