//
//  DetailsTableDataSource.swift
//  GitTest
//
//  Created by Andrei Busuioc on 6/30/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import UIKit

protocol DetailsCellView {
    func display(title: String)
    func display(image: UIImage)
}

class DetailsTableDataSource:NSObject, UITableViewDataSource{
    private var repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return repository.info
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.detailCellIdentifier, for: indexPath) as! DetailTableViewCell
        cell.separator.isHidden = false
        switch indexPath.row {
        case 0:
            cell.display(image: #imageLiteral(resourceName: "Computer"))
            cell.display(title: repository.language != nil ? repository.language! : "Not set")
        case 1:
            cell.display(image: #imageLiteral(resourceName: "Forks"))
            cell.display(title: String(repository.forks) + " forks")
        case 2:
            cell.display(image: #imageLiteral(resourceName: "StarEmpty"))
            cell.display(title: String(repository.stargazersCount) + " stars")
        case 3:
            cell.display(image: #imageLiteral(resourceName: "Calendar"))
            let date = ISO8601DateFormatter().date(from: repository.createdAt)!
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let formatedDate = formatter.string(from: date)
            cell.display(title: "Created on \(formatedDate)")
            cell.separator.isHidden = true
        default:
            fatalError("Invalid row")
        }
        return cell
    }
}
