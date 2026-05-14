//
//  LeaguesDetailsCollectionViewController+DataSource.swift
//  SportFolio
// created by shahudaaaa

import UIKit
import SDWebImage

extension LeaguesDetailsCollectionViewController {

    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {

        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderView.reuseID,
            for: indexPath
        ) as! SectionHeaderView

        header.delegate = self

        switch indexPath.section {
        case 0:
            header.configure(title: L10n.sectionUpcomingMatches, systemIcon: "calendar.badge.clock")
        case 1:
            header.configure(title: L10n.sectionLatestMatches, systemIcon: "flag.checkered")
        case 2:
            if leaguesDetailsPresenter.getSportType() != .tennis
            {
                let title = currentItemSegment == 0 ? L10n.sectionTeams : L10n.sectionPlayers
                header.configure(
                    title: title,
                    systemIcon: currentItemSegment == 0 ? "person.3.fill" : "figure.run",
                    showSegmentControl: true,
                    selectedSegment: currentItemSegment
                )
            }else{
                currentItemSegment = 1
                let title =  L10n.sectionPlayers
                header.configure(
                    title: title,
                    systemIcon:  "figure.run",
                    showSegmentControl: true,
                    selectedSegment: currentItemSegment,
                    isTennis: true
                    
                )
            }
        default:
            header.configure(title: "", systemIcon: "")
        }
        return header
    }

   
    override func numberOfSections(in collectionView: UICollectionView) -> Int { return 3 }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            let count = leaguesDetailsPresenter.getNumberOfUpcomingEvents()
            return count == 0 ? 1 : count

        case 1:
            return 1

        case 2:
            let count = currentItemSegment == 0
                ? leaguesDetailsPresenter.getNumberOfTeams()
                : leaguesDetailsPresenter.getNumberOfPlayers()
            return count == 0 ? 1 : count

        default:
            return 0
        }
    }

    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {

        case 0:
            
            if leaguesDetailsPresenter.getNumberOfUpcomingEvents() == 0 {
                return makeEmptyCell(
                    collectionView, indexPath: indexPath,
                    icon: "calendar.badge.exclamationmark",
                    message: L10n.emptyUpcomingMatches
                )
            }
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: upComingCellId, for: indexPath
            ) as! UpcomingEventCollectionViewCell
            let event = leaguesDetailsPresenter.getUpcomingEvent(at: indexPath.row)
            let placeholder = UIImage(named: "clubPlaceholder")
            
            cell.homeTeamImageView.sd_setImage(
                with: URL(string: event.homeTeamLogo ?? ""),
                placeholderImage: placeholder
            )

            cell.awayTeamImageView.sd_setImage(
                with: URL(string: event.awayTeamLogo ?? ""),
                placeholderImage: placeholder
            )
            cell.configure(
                homeName: event.eventHomeTeam,
                awayName: event.eventAwayTeam,
                date: event.eventDate,
                time: event.eventTime
            )
            return cell

        case 1:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "LatestEventsContainerCell", for: indexPath
            ) as! LatestEventsContainerCell
            cell.events = leaguesDetailsPresenter.getLatestEvents()
            cell.collectionView.reloadData()
            return cell

        case 2:
            let count = currentItemSegment == 0
                ? leaguesDetailsPresenter.getNumberOfTeams()
                : leaguesDetailsPresenter.getNumberOfPlayers()

            if count == 0 {
                let iconName = currentItemSegment == 0 ? "person.3" : "figure.run"
                let message  = currentItemSegment == 0 ? L10n.emptyTeams : L10n.emptyPlayers
                return makeEmptyCell(collectionView, indexPath: indexPath, icon: iconName, message: message)
            }

            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: teamCellId, for: indexPath
            ) as! TeamCollectionViewCell

            let item = currentItemSegment == 0
                ? leaguesDetailsPresenter.getTeamItem(at: indexPath.row)
                : leaguesDetailsPresenter.getPlayerItem(at: indexPath.row)

            let teamPlaceholder   = UIImage(named: "clubPlaceholder")
            let playerPlaceholder = UIImage(named: "playerPlaceholder")
            switch item {
            case .team(let team):
                cell.teamLabel.text = team.teamName ?? "–"
                cell.teamImageView.sd_setImage(
                    with: URL(string: team.teamLogo ?? ""),
                    placeholderImage: teamPlaceholder)
            case .player(let player):
                cell.teamLabel.text = player.playerName ?? "–"
                if leaguesDetailsPresenter.getSportType() == .tennis
                {
                   
                    cell.teamImageView.sd_setImage(
                        with: URL(string: player.playerLogo ?? ""),
                        placeholderImage: playerPlaceholder)
                }else
                {
                
                    cell.teamImageView.sd_setImage(
                        with: URL(string: player.playerImage ?? ""),
                        placeholderImage: playerPlaceholder)
                }
            }
            return cell

        default:
            return UICollectionViewCell()
        }
    }

   
    override func collectionView(_ collectionView: UICollectionView,
                                 willDisplay cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
        guard indexPath.section == 0,
              !animatedCells.contains(indexPath),
              leaguesDetailsPresenter.getNumberOfUpcomingEvents() > 0 else { return }

        animatedCells.insert(indexPath)
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: 60, y: 0).scaledBy(x: 0.92, y: 0.92)

        UIView.animate(
            withDuration: 0.45,
            delay: Double(indexPath.row) * 0.06,
            usingSpringWithDamping: 0.78,
            initialSpringVelocity: 0.4,
            options: .curveEaseOut
        ) {
            cell.alpha = 1
            cell.transform = .identity
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 2 else { return }

         if !NetworkMonitor.shared.isConnected {
            showNoInternet()
            return
        }

        let count = currentItemSegment == 0
            ? leaguesDetailsPresenter.getNumberOfTeams()
            : leaguesDetailsPresenter.getNumberOfPlayers()
        guard count > 0 else { return }

        let item = currentItemSegment == 0
            ? leaguesDetailsPresenter.getTeamItem(at: indexPath.row)
            : leaguesDetailsPresenter.getPlayerItem(at: indexPath.row)

        if case .team(let team) = item, let teamId = team.teamKey {
            let vc = storyboard?.instantiateViewController(withIdentifier: "TeamTableViewController") as! TeamTableViewController
            let presenter = TeamPresenter(
                baseURL: leaguesDetailsPresenter.getBaseURL(),
                teamId: teamId
            )
            vc.presenter = presenter
          
            vc.title = team.teamName ?? L10n.teamNameUnknown
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
