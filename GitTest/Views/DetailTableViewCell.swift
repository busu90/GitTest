//
//  DetailTableViewCell.swift
//  GitTest
//
//  Created by Andrei Busuioc on 6/30/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import UIKit

class DetailTableViewCell: UITableViewCell{
    @IBOutlet weak var detailImg: UIImageView!
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var separator: UIView!
    
    static let detailCellIdentifier = "detailCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        detailImg.tintColor = UIColor.black
    }
}

extension DetailTableViewCell: DetailsCellView{
    func display(title: String) {
        self.detailLbl.text = title
    }
    
    func display(image: UIImage) {
        self.detailImg.image = image
    }
    
    
}
