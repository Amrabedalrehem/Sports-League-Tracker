//
//  TeamTableViewController.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 01/05/2026.
//

import UIKit
import SDWebImage

protocol TeamView: AnyObject {
    func reloadData()
    func startAnimating()
    func stopAnimating()
    func showError(message: String)
}

final class TeamTableViewController: UITableViewController, TeamView {
     private lazy var teamHeaderView     = TeamTableHeaderView.loadFromNib()
    private lazy var loadingOverlayView = TeamLoadingOverlayView.loadFromNib()

   
    private lazy var emptyStateView = TeamEmptyStateView.loadFromNib()

    var presenter : TeamPresenter!
    private let sections = TeamSection.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(self)
        configureTableView()
        setupTableHeader()
        setupLoadingOverlay()
        presenter.fetchTeamDetails()
        startAnimating()
        tableView.register(
            UINib(nibName: "TeamSectionHeaderView", bundle: nil),
            forHeaderFooterViewReuseIdentifier: TeamSectionHeaderView.reuseIdentifier
        )
    }
    
    private func setupTableHeader() {
        teamHeaderView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 250)
        tableView.tableHeaderView = teamHeaderView
    }

    private func configureTableView() {
         tableView.register(
            UINib(nibName: "TeamViewCell", bundle: nil),
            forCellReuseIdentifier: TeamViewCell.reuseIdentifier
        )
        tableView.register(
            UINib(nibName: "TeamSectionHeaderView", bundle: nil),
            forHeaderFooterViewReuseIdentifier: TeamSectionHeaderView.reuseIdentifier
        )
    }

 
    private func setupLoadingOverlay() {
           loadingOverlayView.frame = view.bounds
        loadingOverlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        loadingOverlayView.alpha = 0
        view.addSubview(loadingOverlayView)
    }


   
    private func updateEmptyState() {
        let isEmpty = visibleSections().isEmpty

        if isEmpty {
            if emptyStateView.superview == nil {
                   emptyStateView.frame = CGRect(
                    x: 0,
                    y: tableView.contentOffset.y + 60,
                    width: tableView.bounds.width,
                    height: tableView.bounds.height
                )
                emptyStateView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                tableView.addSubview(emptyStateView)
            }
            emptyStateView.isHidden = false
            UIView.animate(withDuration: 0.35,
                           delay: 0,
                           usingSpringWithDamping: 0.75,
                           initialSpringVelocity: 0.4,
                           options: .curveEaseOut) {
                self.emptyStateView.alpha = 1
                self.emptyStateView.transform = .identity
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.emptyStateView.alpha = 0
            } completion: { _ in
                self.emptyStateView.isHidden = true
            }
        }
    }

     

    private func players(for section: TeamSection) -> [PlayerModel] {
        switch section {
        case .goalkeepers: return presenter.getGoalkeepers()
        case .defenders: return presenter.getDefenders()
        case .midfielders: return presenter.getMidfielders()
        case .forwards: return presenter.getForwards()
        }
    }

    private func visibleSections() -> [TeamSection] {
        sections.filter { !players(for: $0).isEmpty }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        visibleSections().count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = visibleSections()[section]
        return players(for: sectionType).count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionType = visibleSections()[section]
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: TeamSectionHeaderView.reuseIdentifier
        ) as? TeamSectionHeaderView else { return nil }
        header.sectionLabel.text = "\(sectionType.icon)  \(sectionType.title)"
        return header
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TeamViewCell.reuseIdentifier,
                for: indexPath
            ) as? TeamViewCell
        else {
            return UITableViewCell()
        }

        let sectionType = visibleSections()[indexPath.section]
        let player = players(for: sectionType)[indexPath.row]

        let placeholder = UIImage(named: "playerPlaceholder")

        let playerName = player.playerName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        cell.nameLabel.text = playerName.isEmpty ? "Unknown Player" : playerName

        let playerNumber = player.playerNumber?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        cell.numberLabel.text = playerNumber.isEmpty ? "-" : playerNumber

        let playerAge = player.playerAge?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        cell.subtitleLabel.text = playerAge.isEmpty ? "Age: --" : "Age: \(playerAge)"

        cell.roleBadgeLabel.text = sectionType.badgeText
        cell.roleBadgeLabel.backgroundColor = sectionType.badgeColor

        if let image = player.playerImage, !image.isEmpty, let url = URL(string: image) {
            cell.avatarImageView.sd_setImage(with: url, placeholderImage: placeholder)
        } else {
            cell.avatarImageView.image = placeholder
        }

        return cell
    }
    

    func reloadData() {
        let teamName = presenter.getTeamName().trimmingCharacters(in: .whitespacesAndNewlines)
        teamHeaderView.teamNameLabel.text = teamName.isEmpty ? "Unknown Team" : teamName

        let placeholderName: String
        if presenter.baseURL.contains("basketball") { placeholderName = "basketPlaceholder" }
        else if presenter.baseURL.contains("cricket") { placeholderName = "ckrichetPlaceholder" }
        else if presenter.baseURL.contains("tennis") { placeholderName = "tennisPlaceholder" }
        else { placeholderName = "footballPlaceholder" }
        let placeholder = UIImage(named: placeholderName)

        let logo = presenter.getTeamLogo()
        if let url = URL(string: logo), !logo.isEmpty {
            teamHeaderView.teamLogoImageView.sd_setImage(with: url, placeholderImage: placeholder)
        } else {
            teamHeaderView.teamLogoImageView.image = placeholder
        }

        tableView.reloadData()
        updateEmptyState()
    }

    func startAnimating() {
        UIView.animate(withDuration: 0.3) { self.loadingOverlayView.alpha = 1 }
        loadingOverlayView.spinner.startAnimating()
        tableView.tableHeaderView?.isHidden = true
    }

    func stopAnimating() {
        UIView.animate(withDuration: 0.3) { self.loadingOverlayView.alpha = 0 }
        loadingOverlayView.spinner.stopAnimating()
        tableView.tableHeaderView?.isHidden = false
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
    
    
}
