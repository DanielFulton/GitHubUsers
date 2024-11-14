//
//  CollectionViewLayout.swift
//  Github Users
//
//  Created by Daniel Fulton on 2024/11/14.
//

import UIKit

func createBasicListLayout(cellHeight: CGFloat = 44.0) -> UICollectionViewLayout {
  let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                        heightDimension: .fractionalHeight(1.0))
  let item = NSCollectionLayoutItem(layoutSize: itemSize)
  
  let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                         heightDimension: .absolute(cellHeight))
  let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                 subitems: [item])
  
  let section = NSCollectionLayoutSection(group: group)
  
  
  let layout = UICollectionViewCompositionalLayout(section: section)
  return layout
}
