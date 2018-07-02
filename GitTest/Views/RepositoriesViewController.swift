//
//  RepositoriesViewController.swift
//  GitTest
//
//  Created by Andrei Busuioc on 7/1/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol RepositoriesView: class {
    func displayRepositoryFetchError(title: String, description:String)
    func addRepositories(count: Int, at: Int)
    func reloadRepozitories()
    func pushNext(next: UIViewController)
}

class RepositoriesViewController: UIViewController{
    @IBOutlet weak var repoCollection: UICollectionView!
    
    private var repoDataSource: RepositoriesCollectionDataSource!
    private var repoDelegate: RepositoriesCollectionDelegate!
    var presenter: RepositoriesPresenter!
    override func viewDidLoad() {
        super.viewDidLoad()
        repoDataSource = RepositoriesCollectionDataSource(presenter: presenter)
        repoDelegate = RepositoriesCollectionDelegate(presenter: presenter)
        
        repoCollection.dataSource = repoDataSource
        repoCollection.delegate = repoDelegate
        repoCollection.collectionViewLayout = RepositoriesFlowLayout(cellHeight: 80)
        repoCollection.register(UINib(nibName: "RepositoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: RepositoryCollectionViewCell.repositoryCellIdentifier)
        if presenter.showPeriodSelect(){
            configureNavBar()
        }
        presenter.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if presenter.showPeriodSelect(){
            self.tabBarController?.navigationItem.titleView?.isHidden = false
        }else{
           self.tabBarController?.navigationItem.titleView?.isHidden = true
        }
    }
    
    private func configureNavBar(){
        let segment: UISegmentedControl = UISegmentedControl(items: ["Day", "Month", "Year"])
        segment.selectedSegmentIndex = 0;
        segment.bounds.size.width = min( UIScreen.main.bounds.size.width,  UIScreen.main.bounds.size.height)
        segment.addTarget(self, action: #selector(periodValueChanged), for:.valueChanged)
        self.tabBarController?.navigationItem.titleView = segment
    }
    
    @objc private func periodValueChanged(segment: UISegmentedControl){
        presenter.periodChanged(to: segment.selectedSegmentIndex)
    }
}

extension RepositoriesViewController: RepositoriesView{
    func pushNext(next: UIViewController) {
        if let nav = navigationController{
            nav.pushViewController(next, animated: true)
        }
    }
    
    func displayRepositoryFetchError(title: String, description: String) {
        presentAlert(withTitle: title, message: description)
    }
    
    func addRepositories(count: Int, at: Int) {
        let indexPaths = Array(at...at+count-1).map { IndexPath(item: $0, section: 0) }
        repoCollection.insertItems(at: indexPaths)
    }
    
    func reloadRepozitories() {
        repoCollection?.reloadData()
    }
}
