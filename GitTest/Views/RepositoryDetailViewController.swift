//
//  RepositoryDetailViewController.swift
//  GitTest
//
//  Created by Andrei Busuioc on 6/30/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import UIKit

protocol DetailView: class {
    func openUrl(url:URL)
    func setDetailDataSource(source: UITableViewDataSource)
}

class RepositoryDetailViewController: UIViewController{
    @IBOutlet weak var detailsTable: UITableView!
    
    var presenter: DetailPresenter!
    private var detailDataSource: DetailsTableDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailDataSource = DetailsTableDataSource(repository: presenter.getRepo())
        
        detailsTable.dataSource = detailDataSource
        detailsTable.rowHeight = UITableViewAutomaticDimension
        detailsTable.estimatedRowHeight = 50
        
        title = presenter.getTitle()
    }
    
    @IBAction func openInWebUpInside(_ sender: Any) {
        presenter.githubOpen()
    }
}

extension RepositoryDetailViewController: DetailView{
    func openUrl(url: URL) {
        UIApplication.shared.open(url,options: [:]) { (suceeded) in}
    }
    
    func setDetailDataSource(source: UITableViewDataSource) {
        detailsTable.dataSource = source
    }
    
    
}
