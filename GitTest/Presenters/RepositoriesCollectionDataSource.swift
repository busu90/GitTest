//
//  RepositoriesCollectionDataSource.swift
//  GitTest
//
//  Created by Andrei Busuioc on 7/1/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import UIKit

protocol RepositoryCellView {
    func display(title: String)
    func display(description: String?)
    func display(profileImg: String?)
    func display(starCount: String)
    func display(isFavorite: Bool)
}


class RepositoriesCollectionDataSource:NSObject, UICollectionViewDataSource{
    private var presenter: RepositoriesPresenter
    
    init(presenter: RepositoriesPresenter) {
        self.presenter = presenter
        super.init()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getRepoCount()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if Double(indexPath.row) > Double(presenter.getRepoCount()) * 0.7{
            presenter.getNextRepoPage()
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RepositoryCollectionViewCell.repositoryCellIdentifier, for: indexPath) as! RepositoryCollectionViewCell
        let repo = (presenter.getRepository(at: indexPath.row))!
        cell.display(description: repo.info)
        cell.display(title: repo.title)
        cell.display(starCount: Util.getStarString(forStars: repo.stargazersCount))
        cell.display(isFavorite: repo.isFavorite)
        cell.display(profileImg: repo.owner.avatarUrl)
        cell.starImg.tag = indexPath.row
        cell.starTap.addTarget(self, action: #selector(handleFavorite))
        return cell
    }
    
    @objc func handleFavorite(gesture : UITapGestureRecognizer){
        let v = gesture.view!
        let tag = v.tag
        presenter.handleFavorite(repoAt: tag)
    }
}
