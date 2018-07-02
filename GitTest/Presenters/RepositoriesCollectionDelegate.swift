//
//  RepositoriesCollectionDelegate.swift
//  GitTest
//
//  Created by Andrei Busuioc on 7/1/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import UIKit

class RepositoriesCollectionDelegate:NSObject, UICollectionViewDelegateFlowLayout{
    private var presenter: RepositoriesPresenter
    
    init(presenter: RepositoriesPresenter) {
        self.presenter = presenter
        super.init()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0{
            return CGSize(width: collectionView.bounds.width, height: 45)
        }else{
            return CGSize.zero
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.showDetailForRepo(at: indexPath.row)
    }
}
