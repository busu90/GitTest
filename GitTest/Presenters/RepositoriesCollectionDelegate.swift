//
//  RepositoriesCollectionDelegate.swift
//  GitTest
//
//  Created by Andrei Busuioc on 7/1/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import UIKit

class RepositoriesCollectionDelegate:NSObject, UICollectionViewDelegate{
    private var presenter: RepositoriesPresenter
    
    init(presenter: RepositoriesPresenter) {
        self.presenter = presenter
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.showDetailForRepo(at: indexPath.row)
    }
}
