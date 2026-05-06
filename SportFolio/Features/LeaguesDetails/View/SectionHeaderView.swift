//
//  SectionHeaderView.swift
//  SportFolio
//

import UIKit

protocol SectionHeaderDelegate: AnyObject {
    func sectionHeader(_ header: SectionHeaderView, didSelectSegmentAt index: Int)
}

class SectionHeaderView: UICollectionReusableView {

    static let reuseID = "SectionHeaderView"
    private let accentBar     = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel    = UILabel()
    let segmentedControl      = UISegmentedControl(items: ["Teams", "Players"])

    weak var delegate: SectionHeaderDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    
    private func setupUI() {
        backgroundColor = .clear

      
        accentBar.backgroundColor = .primaryBlue
        accentBar.layer.cornerRadius = 2
        accentBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(accentBar)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .primaryBlue
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconImageView)
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .mainText
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = .primaryBlue
        segmentedControl.setTitleTextAttributes(
            [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 13, weight: .semibold)],
            for: .selected
        )
        segmentedControl.setTitleTextAttributes(
            [.foregroundColor: UIColor.primaryBlue,
             .font: UIFont.systemFont(ofSize: 13, weight: .medium)],
            for: .normal
        )
        segmentedControl.layer.cornerRadius = 10
        segmentedControl.isHidden = true
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        addSubview(segmentedControl)

        NSLayoutConstraint.activate([
            accentBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            accentBar.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            accentBar.widthAnchor.constraint(equalToConstant: 4),
            accentBar.heightAnchor.constraint(equalToConstant: 22),

            iconImageView.leadingAnchor.constraint(equalTo: accentBar.trailingAnchor, constant: 10),
            iconImageView.centerYAnchor.constraint(equalTo: accentBar.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 18),
            iconImageView.heightAnchor.constraint(equalToConstant: 18),

            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: accentBar.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            segmentedControl.topAnchor.constraint(equalTo: accentBar.bottomAnchor, constant: 8),
            segmentedControl.heightAnchor.constraint(equalToConstant: 32),
        ])
    }

    
    func configure(title: String, systemIcon: String, showSegmentControl: Bool = false, selectedSegment: Int = 0) {
        titleLabel.text = title
        let config = UIImage.SymbolConfiguration(pointSize: 13, weight: .semibold)
        iconImageView.image = UIImage(systemName: systemIcon, withConfiguration: config)
        segmentedControl.isHidden = !showSegmentControl
        if showSegmentControl {
            segmentedControl.selectedSegmentIndex = selectedSegment
        }
    }

    @objc private func segmentChanged() {
        delegate?.sectionHeader(self, didSelectSegmentAt: segmentedControl.selectedSegmentIndex)
    }
}
