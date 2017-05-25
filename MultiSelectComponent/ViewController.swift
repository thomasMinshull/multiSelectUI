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

    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MultiSelectContoller
        testTableViewController.multiSelectController = vc // TODO there is got to be better atcatecture than this but lets just get er done
//        vc.register(MultiSelectSelectedViewCellWithButton.self, forCellWithReuseIdentifier: "MultiSelectCollectionViewCellWithButton")
        vc.multiSelectDelegate = testTableViewController as MultiSelectDelegate
//        vc.nestInMultiSelectViewController(childViewController: testTableViewController)
        vc.nestedViewController = testTableViewController
     }
    
    
}

class TestTableViewController: UITableViewController, MultiSelectDelegate {
    
    var multiSelectController: MultiSelectContoller!
    let dataArray = ["boo", "yeah", "Seattle Rocks"]
    let indexPaths = [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0), IndexPath(row: 2, section: 0)]
    let reuseID = "MultiSelectCollectionViewCellWithButton"
    
    override func viewDidLoad() {
//        multiSelectController.register(MultiSelectSelectedViewCellWithButton.self, forCellWithReuseIdentifier: reuseID)
        
        for ip in indexPaths {
            multiSelectController.addItemToBeSelected(For: ip)
        }
        
        
    }
    
    /// MultiSelectDelegate Methods
    func selectedIndexPaths() -> [IndexPath] {
        return indexPaths
    }
    
    func multiSelectSelectedViewRemovedItem(at indexPath:IndexPath) {
        // ToDo implement
    }
    
    func multiSelectSelectedViewCell(For indexPath: IndexPath) -> MultiSelectSelectedViewCell {
        let cell = multiSelectController.dequeueReusableMultiSelectSelectedViewCell(with: reuseID, for: indexPath) as! MultiSelectSelectedViewCellWithButton
        cell.textLabel.text = dataArray[indexPath.row]
        
        return cell
    }

    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        cell.textLabel?.text = dataArray[indexPath.row]
        
        return cell
        
    }
}
