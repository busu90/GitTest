//
//  RepositoriesViewController.swift
//  GitTest
//
//  Created by Andrei Busuioc on 7/1/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import UIKit

protocol RepositoriesView: class {
    func displayRepositoryFetchError(title: String, description:String)
    func setRepositoriesDataSource(source: UICollectionViewDataSource)
    func addRepositories(count: Int, at: Int)
    func reloadRepozitories()
}

class RepositoriesViewController: UIViewController{
    @IBOutlet weak var repoCollection: UICollectionView!
    
    private var presenter: RepositoriesPresenter!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = RepositoriesPresenterImplementation(view: self)
        
        repoCollection.collectionViewLayout = RepositoriesFlowLayout(cellHeight: 80)
        repoCollection.register(UINib(nibName: "RepositoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: RepositoryCollectionViewCell.repositoryCellIdentifier)
        configureNavBar()
        presenter.viewDidLoad()
    }
    
    private func configureNavBar(){
        let segment: UISegmentedControl = UISegmentedControl(items: ["Day", "Month", "Year"])
        segment.selectedSegmentIndex = 0;
        segment.bounds.size.width = UIScreen.main.bounds.size.width
        segment.addTarget(self, action: #selector(periodValueChanged), for:.valueChanged)
        self.tabBarController?.navigationItem.titleView = segment
    }
    
    @objc private func periodValueChanged(segment: UISegmentedControl){
        presenter.periodChanged(to: segment.selectedSegmentIndex)
    }
}

extension RepositoriesViewController: RepositoriesView{
    func displayRepositoryFetchError(title: String, description: String) {
        presentAlert(withTitle: title, message: description)
    }
    
    func setRepositoriesDataSource(source: UICollectionViewDataSource) {
        repoCollection.dataSource = source
    }
    
    func addRepositories(count: Int, at: Int) {
        let indexPaths = Array(at...at+count-1).map { IndexPath(item: $0, section: 0) }
        repoCollection.insertItems(at: indexPaths)
    }
    
    func reloadRepozitories() {
        repoCollection.reloadData()
    }
}

extension RepositoriesViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
