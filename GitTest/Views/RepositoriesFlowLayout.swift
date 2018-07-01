//
//  RepositoriesFlowLayout.swift
//  GitTest
//
//  Created by Andrei Busuioc on 7/1/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import UIKit

class RepositoriesFlowLayout: UICollectionViewFlowLayout {
    private let cellHeight: Int
    init(cellHeight: Int) {
        self.cellHeight = cellHeight
        super.init()
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
        self.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override init() {
        self.cellHeight = 80
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        var columnCount = 1
        if UI_USER_INTERFACE_IDIOM() == .phone && (UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight){
            columnCount = 2
        }else if UI_USER_INTERFACE_IDIOM() == .pad{
            if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight{
                columnCount = 3
            }else{
                columnCount = 2
            }
        }
        let itemWidth = (collectionView.bounds.size.width / CGFloat(columnCount)).rounded(.down)
        itemSize = CGSize(width: itemWidth, height: CGFloat(cellHeight))
    }
    
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }
    
}
