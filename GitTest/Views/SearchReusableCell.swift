//
//  SearchReusableCell.swift
//  GitTest
//
//  Created by Andrei Busuioc on 7/2/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import UIKit

class SearchReusableCell: UICollectionReusableView{
    @IBOutlet weak var searchBar: UISearchBar!
    
    static let cellKey = "searchCell"
    
    func setDelegate(delegate: UISearchBarDelegate){
        searchBar.delegate = delegate
    }
    func setQuery(_ query: String?){
        searchBar.text = query
    }
}
