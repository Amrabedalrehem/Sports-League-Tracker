//
//  EmptyMessage.swift
//  SportFolio
//
//  Created by shahudaa on 05/05/2026.
//

import UIKit

func showWhenEmpty(iconText :String , titleText :String , subtitleText :String)->UIView{
    let stack = UIStackView()
    stack.axis  = .vertical
    stack.spacing   = 12
    stack.alignment = .center
    stack.translatesAutoresizingMaskIntoConstraints = false
    let icon       = UILabel()
    icon.text       = iconText
    icon.font       = .systemFont(ofSize: 60)
    let title       = UILabel()
    title.text       = titleText
    title.font       = .boldSystemFont(ofSize: 18)
    title.textColor  = .label
    let subtitle       = UILabel()
    subtitle.text       = subtitleText
    subtitle.font       = .systemFont(ofSize: 13)
    subtitle.textColor  = .secondaryLabel
    subtitle.textAlignment = .center
    subtitle.numberOfLines = 2
    stack.addArrangedSubview(icon)
    stack.addArrangedSubview(title)
    stack.addArrangedSubview(subtitle)
    
    let container = UIView()
    container.addSubview(stack)
    NSLayoutConstraint.activate([
        stack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
        stack.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 32),
        stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -32)
    ])
    return container
}
