//
//  TeamTableViewController.swift
//  SportFolio
//

import UIKit
import SDWebImage
import SkeletonView

protocol TeamView: AnyObject {
    func reloadData()
    func startAnimating()
    func stopAnimating()
    func showError(message: String)
}

final class TeamTableViewController: UITableViewController, TeamView {

    private lazy var teamHeaderView = TeamTableHeaderView.loadFromNib()

    private lazy var emptyStateView = TeamEmptyStateView.loadFromNib()

    var presenter: TeamPresenter!
    private let sections = TeamSection.allCases

    private var cachedSections: [TeamSection] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.isSkeletonable = true
        tableView.dataSource = self
        tableView.delegate = self

        presenter.attachView(self)

        configureTableView()
        setupTableHeader()

        presenter.fetchTeamDetails()
        startAnimating()

    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          applyNavBarAppearance()
    }

    private func applyNavBarAppearance() {
     let appearance = UINavigationBarAppearance()
     appearance.configureWithOpaqueBackground()
     appearance.backgroundColor   = .tabBarGradientStart
     appearance.shadowColor       = .clear

     let titleAttrs: [NSAttributedString.Key: Any] = [
         .foregroundColor: UIColor.white,
         .font: UIFont.systemFont(ofSize: 18, weight: .bold)
     ]
     appearance.titleTextAttributes = titleAttrs

     navigationController?.navigationBar.standardAppearance    = appearance
     navigationController?.navigationBar.scrollEdgeAppearance  = appearance
     navigationController?.navigationBar.compactAppearance     = appearance
     navigationController?.navigationBar.tintColor             = .white
 }

    private func setupTableHeader() {
        teamHeaderView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 250)
        tableView.tableHeaderView = teamHeaderView

        teamHeaderView.isSkeletonable = true
        teamHeaderView.teamNameLabel.isSkeletonable = true
        teamHeaderView.teamLogoImageView.isSkeletonable = true
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

        tableView.isSkeletonable = true
    }

    private func updateEmptyState() {
        let isEmpty = cachedSections.isEmpty

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
        return cachedSections
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        cachedSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < cachedSections.count else { return 0 }
        let sectionType = cachedSections[section]
        return players(for: sectionType).count
    }

    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {

        guard section < cachedSections.count else { return nil }

        let sectionType = cachedSections[section]

        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: TeamSectionHeaderView.reuseIdentifier
        ) as? TeamSectionHeaderView else { return nil }

        header.isSkeletonable = true
        header.contentView.isSkeletonable = true
        header.sectionLabel.isSkeletonable = true

        header.sectionLabel.text = "\(sectionType.icon)  \(sectionType.title)"

        return header
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TeamViewCell.reuseIdentifier,
            for: indexPath
        ) as? TeamViewCell else {
            return UITableViewCell()
        }

        guard indexPath.section < cachedSections.count else { return cell }

        let sectionType = cachedSections[indexPath.section]
        let playersList = players(for: sectionType)

        guard indexPath.row < playersList.count else { return cell }

        let player = playersList[indexPath.row]

        let placeholder = UIImage(named: "playerPlaceholder")

        let name = player.playerName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        cell.nameLabel.text = name.isEmpty ? "Unknown Player" : name

        let number = player.playerNumber?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        cell.numberLabel.text = number.isEmpty ? "-" : number

        let age = player.playerAge?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        cell.subtitleLabel.text = age.isEmpty ? "Age: --" : "Age: \(age)"

        cell.roleBadgeLabel.text = sectionType.badgeText
        cell.roleBadgeLabel.backgroundColor = sectionType.badgeColor

        if let image = player.playerImage,
           !image.isEmpty,
           let url = URL(string: image) {
            cell.avatarImageView.sd_setImage(with: url, placeholderImage: placeholder)
        } else {
            cell.avatarImageView.image = placeholder
        }

        return cell
    }

    func reloadData() {

        cachedSections = sections.filter { !players(for: $0).isEmpty }

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

        stopAnimating()
        tableView.reloadData()
        updateEmptyState()
    }

    func startAnimating() {
        tableView.isSkeletonable = true
        tableView.showAnimatedSkeleton(usingColor: .clouds, transition: .crossDissolve(0.25))

        teamHeaderView.isSkeletonable = true
        teamHeaderView.showAnimatedSkeleton(usingColor: .clouds, transition: .crossDissolve(0.25))
    }

    func stopAnimating() {
        tableView.hideSkeleton(reloadDataAfter: false)
        teamHeaderView.hideSkeleton()
    }

    func showError(message: String) {
        let alert = UIAlertController(
            title: "⚠️ Something Went Wrong",
            message: message,
            preferredStyle: .actionSheet
        )

        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
}

extension TeamTableViewController: SkeletonTableViewDataSource, SkeletonTableViewDelegate {

    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 4
    }

    func collectionSkeletonView(_ skeletonView: UITableView,
                                numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func collectionSkeletonView(_ skeletonView: UITableView,
                                cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "TeamViewCell"
    }

    func collectionSkeletonView(_ skeletonView: UITableView,
                                identifierForHeaderInSection section: Int) -> ReusableHeaderFooterIdentifier? {
        return TeamSectionHeaderView.reuseIdentifier
    }
}
