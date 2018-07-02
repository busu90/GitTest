//
//  SearchDelegate.swift
//  GitTest
//
//  Created by Andrei Busuioc on 7/2/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import UIKit

class SearchDelegate: NSObject, UISearchBarDelegate{
    let presenter: RepositoriesPresenter
    
    init(presenter: RepositoriesPresenter) {
        self.presenter = presenter
        super.init()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.findRepos(query: searchBar.text ?? "")
    }
}
