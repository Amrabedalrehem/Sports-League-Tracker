//
//  TeamCollectionViewCell.swift
//  SportFolio
//
//  Created by ITI_JETS on 30/04/2026.
//

import UIKit
import SDWebImage

class TeamCollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var teamLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    
    private func setupCell() {
        
        teamImageView.layer.cornerRadius = 35
        teamImageView.layer.masksToBounds = true
        teamImageView.contentMode = .scaleAspectFit
        teamImageView.backgroundColor = .systemGray6
    
        teamImageView.layer.borderWidth = 1
        teamImageView.layer.borderColor = UIColor.systemGray5.cgColor
        
      
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.1
        layer.masksToBounds = false
    }
    
   
    
  
}

