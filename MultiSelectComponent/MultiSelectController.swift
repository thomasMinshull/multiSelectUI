//
//  MultiSelectTableView.swift
//  MultiSelectComponent
//
//  Created by ThomasMinshull on 2017-05-12.
//  Copyright © 2017 DrBill. All rights reserved.
//

import UIKit


protocol MultiSelectDelegate { // nested VC must implement these methods
    
    func selectedIndexPaths() -> [IndexPath]
    func multiSelectSelectedViewRemovedItem(at indexPath:IndexPath) // IndexPath here is in terms of the childs index path
    
    // The cell that is returned must be retrieved from a call
    // to -dequeueReusableMultiSelectSelectedViewCellWithReuseIdentifier:forIndexPath:
    func multiSelectSelectedViewCell(For indexPath: IndexPath) -> MultiSelectSelectedViewCell
}

class MultiSelectContoller: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MultiSelectSelectedView
    @IBOutlet fileprivate var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    var multiSelectDelegate: MultiSelectDelegate?
    private var count = 0
    
    func addItemToBeSelected(For indexPath: IndexPath) {
        // 1- get sortedSelectedList
        // 2- check that index path isn't in list
        guard let selectedIPs = sortedSelectedIndexPaths(),
            !selectedIPs.contains(indexPath) else {
            return
        }
        
        // 3- insert cell at correct collectionViewIndexPath
        if let collectionViewIP = toCollectionViewIndexPath(childVCIndexPath: indexPath) {
            collectionView.insertItems(at: [collectionViewIP])
            
            // 4 increment count
            count = count + 1
        }
    }
    
    func removeItemToBeDeselected(For indexPath: IndexPath) {
        // 1- get sortedSelectedList
        // 2- check that index path is in list
        guard let selectedIPs = sortedSelectedIndexPaths(),
            selectedIPs.contains(indexPath) else {
                return
        }
        
        // 3- remove cell at correct collectionViewIndexPath
        if let collectionViewIP = toCollectionViewIndexPath(childVCIndexPath: indexPath) {
            collectionView.deleteItems(at: [collectionViewIP])
            
            // 4 decrement count
            count = count - 1
        }

    }
    
    // MARK: Register MultiSelectSelectedViewCells
    func registerMultiSelectSelectedViewCell(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func register(_ multiSelectSelectedViewCellSubclass: AnyClass?,
                  forCellWithReuseIdentifier identifier: String) {
        guard let selectedViewCellSubclass = multiSelectSelectedViewCellSubclass, (selectedViewCellSubclass.isSubclass(of: MultiSelectSelectedViewCell.self)) else {
            fatalError("Attempt to register MultiSelectSelectedViewCell that is not a sublecall of MultiSelectSelectedViewCell")
        }
        
        collectionView.register(selectedViewCellSubclass, forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueReusableMultiSelectSelectedViewCell(with reuseIdenfifier: String, for indexPath: IndexPath) -> MultiSelectSelectedViewCell {
        let ip = toCollectionViewIndexPath(childVCIndexPath: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdenfifier, for: ip!)
        return cell as! MultiSelectSelectedViewCell
    }
    
    // MARK: UICollectionViewDataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableWithReuseIdentifier:forIndexPath:
    // must be passed in a indexPath for the collectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let childVCIndexPath = toChildVCIndexPath(collectionViewIndexPath: indexPath),
        let multiSelectDelegate = self.multiSelectDelegate else {
                fatalError() // consider trying to see if this is a tableViewIndexPath and if so returning the correct cell
        }

        let cell = multiSelectDelegate.multiSelectSelectedViewCell(For: childVCIndexPath)
        return cell as UICollectionViewCell!
    }

    // MARK: Helper method
    
    private func sortedSelectedIndexPaths() -> [IndexPath]? {
        guard let multiSelectDelegate = self.multiSelectDelegate else {
            return nil
        }
        
        let selectedIndexPaths = multiSelectDelegate.selectedIndexPaths()
        
        return selectedIndexPaths.sorted(by: { (first, second) -> Bool in
            if first.section < second.section {
                return true
            } else {
                return first.section == second.section && first.row < second.row
            }
        })
    }
    
    private func toCollectionViewIndexPath(childVCIndexPath: IndexPath) -> IndexPath? {
        guard let selectedIP = sortedSelectedIndexPaths() else {
            return nil
        }
        let preceedingSelectedIndexPaths = selectedIP.filter { (ip) -> Bool in
            return ip.row < childVCIndexPath.row && ip.section <= childVCIndexPath.section
        }
        let collectionViewRow = preceedingSelectedIndexPaths.count
        let collectionViewSection = 0
        return IndexPath(row: collectionViewRow, section: collectionViewSection)
    }
    
    private func toChildVCIndexPath(collectionViewIndexPath: IndexPath) -> IndexPath? {
        guard let selectedIPs = sortedSelectedIndexPaths(),
            collectionViewIndexPath.section == 0,
            collectionViewIndexPath.row < selectedIPs.count
            else {
                return nil
        }
        
        return selectedIPs[collectionViewIndexPath.row]
    }
    
    
}
