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
    func updateFavoriteButton(isFavorite: Bool)
}

class LeaguesDetailsCollectionViewController: UICollectionViewController {

    var leaguesDetailsPresenter: LeaguesDetailsPresenterProtocol!
    private var favoriteButton: UIBarButtonItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        collectionView.setCollectionViewLayout(createLayout(), animated: false)

        leaguesDetailsPresenter.getItems()
        leaguesDetailsPresenter.getEvents ()
    }
    private func setupNavigationBar() {
         
        let button = UIButton(type: .system)
          button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
          button.tintColor = .systemRed
          button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
          
       
          let isFavorite = leaguesDetailsPresenter.isFavorite()
          updateFavoriteButtonIcon(button, isFavorite: isFavorite)
          
          favoriteButton = UIBarButtonItem(customView: button)
          navigationItem.rightBarButtonItem = favoriteButton
      }
      
      @objc private func favoriteButtonTapped() {
          guard let button = favoriteButton?.customView as? UIButton else { return }
          
          
          UIView.animate(withDuration: 0.2, animations: {
              button.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
          }) { _ in
              UIView.animate(withDuration: 0.2) {
                  button.transform = .identity
              }
          }
          
          
          let isFavorite = leaguesDetailsPresenter.toggleFavorite()
          updateFavoriteButtonIcon(button, isFavorite: isFavorite)
          
        
          let generator = UIImpactFeedbackGenerator(style: .light)
          generator.impactOccurred()
          
          
          
      }
      
    private func updateFavoriteButtonIcon(_ button: UIButton, isFavorite: Bool) {
        let configuration = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        let imageName = isFavorite ? "heart.fill" : "heart"
        let image = UIImage(systemName: imageName, withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.tintColor = isFavorite ? .systemRed : .systemGray
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
        collectionView.register(
            UINib(nibName: "LatestEventsContainerCell", bundle: nil),
            forCellWithReuseIdentifier: "LatestEventsContainerCell"
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
               
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .fractionalWidth(0.9),
                                      heightDimension: .absolute(210)),
                    subitems: [item]
                )

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 16, trailing: 8)
                section.boundarySupplementaryItems = [self.createHeader()]

                return section

            case 1:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1),
                                      heightDimension: .fractionalHeight(1))
                )
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .fractionalWidth(1),
                                      heightDimension: .absolute(360)),
                    subitems: [item]
                )

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0)
                section.boundarySupplementaryItems = [self.createHeader()]

                return section
            case 2:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .absolute(130),
                                      heightDimension: .absolute(130))
                )
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .absolute(130),
                                      heightDimension: .absolute(130)),
                    subitems: [item]
                )

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 16, trailing: 8)
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
            return 1

        case 2:
            return leaguesDetailsPresenter.getNumberOfItems()

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
                placeholderImage: UIImage(named: "clubPlaceholder"))

            cell.awayTeamImageView.sd_setImage(
                with: URL(string: event.awayTeamLogo ?? ""),
                placeholderImage: UIImage(named: "clubPlaceholder"))

            cell.homeTeamNameLabel.text = event.eventHomeTeam
            cell.awayTeamNameLabel.text = event.eventAwayTeam
            cell.dateLabel.text = event.eventDate ?? "N/A"
            cell.timeLabel.text = event.eventTime ?? "N/A"
            cell.vsLabel.text = "VS"

          

            return cell

        case 1:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "LatestEventsContainerCell",
                for: indexPath
            ) as! LatestEventsContainerCell

            cell.events = leaguesDetailsPresenter.getLatestEvents()
            cell.collectionView.reloadData()

            return cell
        case 2:
    
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: teamCellId,
                for: indexPath
            ) as! TeamCollectionViewCell

            let item = leaguesDetailsPresenter.getItem(at: indexPath.row)

            switch item {

            case .team(let team):
                cell.teamLabel.text = team.teamName
                cell.teamImageView.sd_setImage(
                    with: URL(string: team.teamLogo ?? ""),
                    placeholderImage: UIImage(named: "clubPlaceholder")
                )

            case .player(let player):
                cell.teamLabel.text = player.playerName
                cell.teamImageView.sd_setImage(
                    with: URL(string: player.playerLogo ?? ""),
                    placeholderImage: UIImage(named: "playerPlaceholder")
                )
            }

            return cell

        default:
            return UICollectionViewCell()
        }
    }
    
    
        override func collectionView(_ collectionView: UICollectionView,
                                      didSelectItemAt indexPath: IndexPath) {
            switch indexPath.section {
            case 2:
                let item = leaguesDetailsPresenter.getItem(at: indexPath.row)

                switch item {

                case .team(let team):
                    guard let teamId = team.teamKey else { return }

                    let vc = storyboard?
                        .instantiateViewController(withIdentifier: "TeamTableViewController")
                        as! TeamTableViewController

                    let presenter = TeamPresenter(
                        baseURL: leaguesDetailsPresenter.getBaseURL(),
                        teamId: teamId
                    )

                    vc.presenter = presenter
                    navigationController?.pushViewController(vc, animated: true)

                case .player:
                   
                    break
                }
            default:
                break
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
    func updateFavoriteButton(isFavorite: Bool) {
           guard let button = favoriteButton?.customView as? UIButton else { return }
           updateFavoriteButtonIcon(button, isFavorite: isFavorite)
       }
    
}
