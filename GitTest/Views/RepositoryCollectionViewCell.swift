//
//  RepositoryCollectionViewCell.swift
//  GitTest
//
//  Created by Andrei Busuioc on 7/1/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import UIKit

class RepositoryCollectionViewCell:UICollectionViewCell{
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nextImg: UIImageView!
    @IBOutlet weak var starImg: UIImageView!
    @IBOutlet weak var starCountLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    static let repositoryCellIdentifier = "repoCellKey"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        starImg.tintColor = UIColor.blue
        nextImg.tintColor = UIColor.lightGray
    }
}

extension RepositoryCollectionViewCell: RepositoryCellView{
    func display(title: String) {
        titleLbl.text = title
    }
    func display(description: String?) {
        descriptionLbl.text = description
    }
    func display(starCount: String) {
        starCountLbl.text = starCount
    }
    func display(profileImg: String?) {
        self.profileImg.setImageAt(urlString: profileImg, placeholderImg: #imageLiteral(resourceName: "Profile"))
    }
    func display(isFavorite: Bool) {
        if isFavorite{
            starImg.image = #imageLiteral(resourceName: "StarFull")
        }else{
            starImg.image = #imageLiteral(resourceName: "StarEmpty")
        }
    }
}
