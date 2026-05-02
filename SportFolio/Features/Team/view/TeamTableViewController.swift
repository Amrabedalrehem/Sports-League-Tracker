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

    private let teamLogoImageView = UIImageView()
    private let teamNameLabel = UILabel()

    var presenter : TeamPresenter!
    private let sections = TeamSection.allCases

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.attachView(self)
        configureTableView()
        setupTableHeader()
        presenter.fetchTeamDetails()
    }
    
    private func setupTableHeader() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 220))
        headerView.backgroundColor = UIColor(red: 0.20, green: 0.22, blue: 0.25, alpha: 1.0)

        teamLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        teamNameLabel.translatesAutoresizingMaskIntoConstraints = false

        teamLogoImageView.contentMode = .scaleAspectFill
        teamLogoImageView.clipsToBounds = true
        teamLogoImageView.layer.cornerRadius = 48
        teamLogoImageView.layer.borderWidth = 1
        teamLogoImageView.layer.borderColor = UIColor(white: 1, alpha: 0.12).cgColor

        teamNameLabel.textAlignment = .center
        teamNameLabel.textColor = .white
        teamNameLabel.font = .systemFont(ofSize: 28, weight: .bold)
        teamNameLabel.numberOfLines = 2

        headerView.addSubview(teamLogoImageView)
        headerView.addSubview(teamNameLabel)

        NSLayoutConstraint.activate([
            teamLogoImageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            teamLogoImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 32),
            teamLogoImageView.widthAnchor.constraint(equalToConstant: 96),
            teamLogoImageView.heightAnchor.constraint(equalToConstant: 96),

            teamNameLabel.topAnchor.constraint(equalTo: teamLogoImageView.bottomAnchor, constant: 16),
            teamNameLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            teamNameLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16)
        ])

        tableView.tableHeaderView = headerView
    }

    private func configureTableView() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.16, alpha: 1.0)
        tableView.showsVerticalScrollIndicator = false

        tableView.register(
            UINib(nibName: "TeamViewCell", bundle: nil),
            forCellReuseIdentifier: TeamViewCell.reuseIdentifier
        )

        tableView.rowHeight = 104
        tableView.sectionHeaderHeight = 30
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

        let container = UIView()
        container.backgroundColor = UIColor.clear

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(sectionType.icon)  \(sectionType.title)"
        label.textColor = UIColor(white: 1, alpha: 0.72)
        label.font = .systemFont(ofSize: 18, weight: .heavy)

        container.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 2),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -2)
        ])

        return container
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

        cell.numberLabel.text = player.playerNumber?.isEmpty == false ? player.playerNumber : "-"
        cell.nameLabel.text = player.playerName
        cell.subtitleLabel.text = player.playerAge?.isEmpty == false ? "Age: \(player.playerAge!)" : "Age: --"
        cell.roleBadgeLabel.text = sectionType.badgeText
        cell.roleBadgeLabel.backgroundColor = sectionType.badgeColor

        if let image = player.playerImage, !image.isEmpty, let url = URL(string: image) {
            cell.avatarImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar"))
        } else {
            cell.avatarImageView.image = UIImage(named: "avatar")
        }

        return cell
    }
    

    func reloadData() {
        teamNameLabel.text = presenter.getTeamName()

        let logo = presenter.getTeamLogo()
        if let url = URL(string: logo), !logo.isEmpty {
            teamLogoImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "football"))
        } else {
            teamLogoImageView.image = UIImage(named: "football")
        }

        tableView.reloadData()
    }

    func startAnimating() {
       }

    func stopAnimating() {
          }

    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
