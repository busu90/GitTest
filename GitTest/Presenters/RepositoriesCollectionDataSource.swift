//
//  RepositoriesCollectionDataSource.swift
//  GitTest
//
//  Created by Andrei Busuioc on 7/1/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import UIKit

class RepositoriesCollectionDataSource:NSObject, UICollectionViewDataSource{
    private var repositories: [Repository] = []
    
    func setRepositories(repositories: [Repository]){
        self.repositories = repositories
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return repositories.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RepositoryCollectionViewCell.repositoryCellIdentifier, for: indexPath) as! RepositoryCollectionViewCell
        cell.display(description: repositories[indexPath.row].info)
        cell.display(title: repositories[indexPath.row].title)
        cell.display(starCount: Util.getStarString(forStars: repositories[indexPath.row].stargazersCount))
        cell.display(isFavorite: false)
        cell.display(profileImg: repositories[indexPath.row].owner.avatarUrl)
        return cell
    }
}
