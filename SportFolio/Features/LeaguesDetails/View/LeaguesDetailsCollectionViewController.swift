//
//  LeaguesDetailsCollectionViewController.swift
//  SportFolio
//
//  Created by shahudaa 
//


import UIKit
import SDWebImage
private let teamCellId = "TeamCollectionViewCell"
private let upComingCellId = "UpcomingEventCollectionViewCell"
private let latestCellId = "LatestEventCollectionViewCell"

protocol LeaguesDetailsView: AnyObject {
    func showLoading()
    func hideLoading()
    func showData()
    func showEmptyState()
    func showError(message: String)
}

class LeaguesDetailsCollectionViewController: UICollectionViewController {

    var leaguesDetailsPresenter: LeaguesDetailsPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()

        leaguesDetailsPresenter.view = self

        setupCollectionView()
        collectionView.setCollectionViewLayout(createLayout(), animated: false)

        leaguesDetailsPresenter.getTeams()
        leaguesDetailsPresenter.getEvents ()
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
        collectionView.register(
            UINib(nibName: "SectionHeaderView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header"
        )
    }

   

    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in

            guard let self = self else { return nil }

            switch sectionIndex {

            case 0:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1),
                                      heightDimension: .fractionalHeight(1))
                )

                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .fractionalWidth(1),
                                      heightDimension: .fractionalHeight(0.33)),
                    subitems: [item]
                )

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.boundarySupplementaryItems = [self.createHeader()]

                return section

            case 1:
                
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1),
                                     heightDimension: .fractionalHeight(1))
                )
                
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: .init(widthDimension: .fractionalWidth(1),
                                     heightDimension: .absolute(189)),
                    subitems: [item]
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .none
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
                section.interGroupSpacing = 12
                section.boundarySupplementaryItems = [self.createHeader()]
                
                return section

            case 2:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .absolute(120),
                                      heightDimension: .absolute(120))
                )

                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .absolute(120),
                                      heightDimension: .absolute(120)),
                    subitems: [item]
                )

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.boundarySupplementaryItems = [self.createHeader()]

                return section

            default:
                return nil
            }
        }
    }
    
    private func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {

        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(40)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {

        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "header",
            for: indexPath
        ) as! SectionHeaderView

        switch indexPath.section {
        case 0:
            header.headerTitle.text = "Upcoming Matches"
        case 1:
            header.headerTitle.text = "Latest Matches"
        case 2:
            header.headerTitle.text = "Teams"
        default:
            header.headerTitle.text = ""
        }

        return header
    }


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        switch section {
        case 0:
            return leaguesDetailsPresenter.getNumberOfUpcomingEvents()

        case 1:
            return leaguesDetailsPresenter.getNumberOfLatestEvents()

        case 2:
            return leaguesDetailsPresenter.getNumberOfTeams()

        default:
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView,
                                cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch indexPath.section {

        case 0:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: upComingCellId,
                for: indexPath
            ) as! UpcomingEventCollectionViewCell

            let event = leaguesDetailsPresenter.getUpcomingEvent(at: indexPath.row)
          
            cell.homeTeamImageView.sd_setImage(
                with: URL(string: event.homeTeamLogo ?? ""),
                placeholderImage: UIImage(named: "placeholder"))

            cell.awayTeamImageView.sd_setImage(
                with: URL(string: event.awayTeamLogo ?? ""),
                placeholderImage: UIImage(named: "placeholder"))

            cell.homeTeamNameLabel.text = event.eventHomeTeam
            cell.awayTeamNameLabel.text = event.eventAwayTeam
            cell.dateLabel.text = event.eventDate ?? "N/A"
            cell.timeLabel.text = event.eventTime ?? "N/A"
            cell.vsLabel.text = "VS"

          

            return cell

        case 1:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: latestCellId,
                for: indexPath
            ) as! LatestEventCollectionViewCell
            
            let event = leaguesDetailsPresenter.getLatestEvent(at: indexPath.row)
            
            cell.homeTeamNameLabel.text = event.eventHomeTeam
            cell.homeTeamImageView.sd_setImage(
                with: URL(string: event.homeTeamLogo ?? ""),
                placeholderImage: UIImage(named: "placeholder"))
        
            cell.awayTeamNameLabel.text = event.eventAwayTeam
            cell.awayTeamImageView.sd_setImage(
                with: URL(string: event.awayTeamLogo ?? ""),
                placeholderImage: UIImage(named: "placeholder"))
           
            cell.scoreLabel.text =  event.eventFinalResult
        
            cell.dateLabel.text = event.eventDate
          
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: teamCellId,
                for: indexPath
            ) as! TeamCollectionViewCell

            let team = leaguesDetailsPresenter.getTeam(at: indexPath.row)
            cell.teamLabel.text = team.teamName
            cell.teamImageView.sd_setImage(
                with: URL(string: team.teamLogo ?? ""),
                placeholderImage: UIImage(named: "placeholder"))
           
            return cell

        default:
            return UICollectionViewCell()
        }
    }
}
extension LeaguesDetailsCollectionViewController : LeaguesDetailsView{
    func showLoading() {
        print("Loading...")
        
    }

    func hideLoading() {
        print("Stop loading")
    }

    func showData() {
        collectionView.reloadData()
    }

    func showEmptyState() {
        print("No Data Found")
      
    }

    func showError(message: String) {
        print("Error:", message)
    }
    
    
}
