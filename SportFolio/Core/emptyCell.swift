//
//  emptyCell.swift
//  SportFolio
//
//  Created by Shahd Ashraf on 16/05/2026.
//

import UIKit
let emptyCellId    = "EmptyStateCell"

   func makeEmptyCell(
        _ collectionView: UICollectionView,
        indexPath: IndexPath,
        icon: String,
        message: String
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emptyCellId, for: indexPath)
        cell.contentView.subviews.filter { $0.tag == 999 }.forEach { $0.removeFromSuperview() }

        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .light)
        let iconView = UIImageView(image: UIImage(systemName: icon, withConfiguration: config))
        iconView.tintColor = .primaryBlueLight
        iconView.contentMode = .scaleAspectFit

        let label = UILabel()
        label.text = message
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .tertiaryLabel
        label.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [iconView, label])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10
        stack.tag = 999
        stack.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 44),
            iconView.heightAnchor.constraint(equalToConstant: 44),
        ])
        return cell
    }
