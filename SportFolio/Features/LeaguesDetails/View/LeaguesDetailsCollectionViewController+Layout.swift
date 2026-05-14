//
//  LeaguesDetailsCollectionViewController+Layout.swift
//  SportFolio
// created by shahudaaaa

import UIKit

extension LeaguesDetailsCollectionViewController {

    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }

            switch sectionIndex {
                
            case 0:
                let upcomingCount = self.leaguesDetailsPresenter?.getNumberOfUpcomingEvents() ?? 0
                
                if upcomingCount == 0 {
                    
                    let item = NSCollectionLayoutItem(
                        layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                    let group = NSCollectionLayoutGroup.horizontal(
                        layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120)),
                        subitems: [item])
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0)
                    section.boundarySupplementaryItems = [self.createHeader(height: 52)]
                    return section
                }
                
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8)
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .fractionalWidth(0.89), heightDimension: .absolute(220)),
                    subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 16, trailing: 8)
                section.boundarySupplementaryItems = [self.createHeader(height: 52)]
                return section
                
            case 1:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(255)),
                    subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0)
                section.boundarySupplementaryItems = [self.createHeader(height: 52)]
                return section
                
            case 2:
                
                let headerHeight: CGFloat = leaguesDetailsPresenter.getSportType() == .tennis ? 52 : 88
                
                let segCount = self.currentItemSegment == 0
                ? (self.leaguesDetailsPresenter?.getNumberOfTeams() ?? 0)
                : (self.leaguesDetailsPresenter?.getNumberOfPlayers() ?? 0)
                
                if segCount == 0 {
                    
                    let item = NSCollectionLayoutItem( layoutSize: .init(widthDimension: .fractionalWidth(1),heightDimension: .fractionalHeight(1)))
                    
                    let group = NSCollectionLayoutGroup.horizontal(
                        layoutSize: .init(widthDimension: .fractionalWidth(1),
                                          heightDimension: .absolute(120)),
                        subitems: [item])
                    
                    let section = NSCollectionLayoutSection(group: group)
                    
                    section.contentInsets = NSDirectionalEdgeInsets(
                        top: 8,
                        leading: 0,
                        bottom: 24,
                        trailing: 0
                    )
                    
                    section.boundarySupplementaryItems = [
                        self.createHeader(height: headerHeight)
                    ]
                    
                    return section
                }
                
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .absolute(120),
                                      heightDimension: .absolute(130)))
                
                item.contentInsets = NSDirectionalEdgeInsets(
                    top: 6,
                    leading: 8,
                    bottom: 6,
                    trailing: 8
                )
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .absolute(120),
                                      heightDimension: .absolute(130)),
                    subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                section.orthogonalScrollingBehavior = .continuous
                
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 8,
                    leading: 8,
                    bottom: 24,
                    trailing: 8
                )
                
                section.boundarySupplementaryItems = [
                    self.createHeader(height: headerHeight)
                ]
                
                return section
            
            default:
                return nil
            }
        }
    }
    
    func createHeader(height: CGFloat) -> NSCollectionLayoutBoundarySupplementaryItem {
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(height)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
}
