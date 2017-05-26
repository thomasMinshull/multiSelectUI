//
//  ViewController.swift
//  MultiSelectComponent
//
//  Created by ThomasMinshull on 2017-05-12.
//  Copyright © 2017 DrBill. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let testTableViewController = TestTableViewController()

    @IBAction func buttonTapped(_ sender: Any) {
        let vc = MultiSelectContoller(nibName: "MultiSelectContoller", bundle: Bundle.main)
        testTableViewController.multiSelectController = vc
        vc.multiSelectDelegate = testTableViewController
        vc.nestedViewController = testTableViewController
        self.present(vc, animated: true)
    }
    
    
}

class TestTableViewController: UITableViewController, MultiSelectDelegate {
    
    let cellID = "CellID"
    
    var multiSelectController: MultiSelectContoller!
    let dataArray = ["boo", "yeah", "Seattle Rocks"]
    let indexPaths = [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0), IndexPath(row: 2, section: 0)]
    
    override func viewDidLoad() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        self.tableView.allowsMultipleSelection = true
        
    }
    
    /// MultiSelectDelegate Methods
    func selectedIndexPaths() -> [IndexPath] {
        guard let rows = tableView.indexPathsForSelectedRows else {
            return []
        }
        return rows
    }
    
    func multiSelectSelectedViewRemovedItem(at indexPath:IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func multiSelectSelectedViewCell(For indexPath: IndexPath) -> MultiSelectSelectedViewCell {
        let cell = multiSelectController.dequeueReusableMultiSelectSelectedViewCell(with: MultiSelectCollectionViewCellIdentifier, for: indexPath) as! MultiSelectSelectedViewCellWithButton
        cell.textLabel.text = dataArray[indexPath.row]
        
        return cell
    }

    
    // MARK: - TableViewDataSource Methods 
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        cell.textLabel?.text = dataArray[indexPath.row]
        
        return cell
    }
    
    // MARK: - TableViewDelegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        multiSelectController.addItemToBeSelected(For: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        multiSelectController.removeItemToBeDeselected(For: indexPath)
    }
}
