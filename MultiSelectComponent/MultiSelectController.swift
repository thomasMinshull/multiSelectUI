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
    
    /// Is called when the multiSelectSelectedViewCell is removed from the multiSelectSelectedView is passed in a childVCIndexPath
    func multiSelectSelectedViewRemovedItem(at indexPath:IndexPath)
    
    /// The cell that is returned must be retrieved from a call to -dequeueReusableMultiSelectSelectedViewCellWithReuseIdentifier:forIndexPath:
    func multiSelectSelectedViewCell(For indexPath: IndexPath) -> MultiSelectSelectedViewCell
}

class MultiSelectContoller: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MultiSelectSelectedView
    @IBOutlet private var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    @IBOutlet private var containerView: UIView!
    
    var multiSelectDelegate: MultiSelectDelegate?
    var nestedViewController: UIViewController! //TODO this is just here for testing look to see if three is a better way to do this
    
    override func viewDidLoad() {
        register(MultiSelectSelectedViewCellWithButton.self, forCellWithReuseIdentifier: MultiSelectCollectionViewCellIdentifier) //
        nestInMultiSelectViewController(childViewController: nestedViewController)
    }
    
    /// Call this item to add an item to the MultiSelectSelectedView after selecting the item in the childVC
    func addItemToBeSelected(For indexPath: IndexPath) {
        guard let selectedIPs = sortedSelectedIndexPaths(),
            selectedIPs.contains(indexPath) else {
            return
        }
        
        if let collectionViewIP = toCollectionViewIndexPath(childVCIndexPath: indexPath) {
            collectionView.insertItems(at: [collectionViewIP])
        }
    }
    
    /// Call this item to remove an item from the MultiSelectSelectedView after deselecting the item from the childVC
    func removeItemToBeDeselected(For indexPath: IndexPath) {
        guard let selectedIPs = sortedSelectedIndexPaths(),
            !selectedIPs.contains(indexPath) else {
                return
        }
        
        // note toCollectionViewIndexPath should return the index path that this childVCIndexPath priviously ocupied, 
        // as long as no other rows from an earlier row/section have been removed since the CollectionView was last updated
        if let collectionViewIP = toCollectionViewIndexPath(childVCIndexPath: indexPath) {
            collectionView.deleteItems(at: [collectionViewIP])
        }
    }
    
    func dequeueReusableMultiSelectSelectedViewCell(with reuseIdenfifier: String, for indexPath: IndexPath) -> MultiSelectSelectedViewCell {
        let ip = toCollectionViewIndexPath(childVCIndexPath: indexPath)
        let collectionViewUnwrapped = collectionView!
        let cell = collectionViewUnwrapped.dequeueReusableCell(withReuseIdentifier: reuseIdenfifier, for: ip!)
        return cell as! MultiSelectSelectedViewCell
    }
    
    // MARK: Methods for nesting ChildViewController
    func nestInMultiSelectViewController(childViewController:UIViewController) {
        guard let childView = childViewController.view else {
            return
        }

        addChildViewController(childViewController)
        
        containerView.addSubview(childView)
        childView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        childView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        childView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        childView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        childViewController.didMove(toParentViewController: self)
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
        
        // TODO, fix this so nib is also being passed in
        let nib = UINib(nibName: "MultiSelectSelectedViewCellWithButton", bundle: Bundle.main)
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)

    }
    
    
    // MARK: UICollectionViewDataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (multiSelectDelegate?.selectedIndexPaths().count)!
    }
    
    /// The cell that is returned must be retrieved from a call to -dequeueReusableWithReuseIdentifier:forIndexPath:
    /// only the collectionView should call this method. IndexPath must be a MultiSelectSelectedView indexPath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let childVCIndexPath = toChildVCIndexPath(collectionViewIndexPath: indexPath) else {
            fatalError("IndexPath for MultiSelectController could not be converted into a childViewController IndexPath")
        }
        
        return multiSelectDelegate?.multiSelectSelectedViewCell(For: childVCIndexPath) as UICollectionViewCell!
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
