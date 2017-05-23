//
//  MultiSelectTableView.swift
//  MultiSelectComponent
//
//  Created by ThomasMinshull on 2017-05-12.
//  Copyright © 2017 DrBill. All rights reserved.
//

import UIKit


protocol MultiSelectDataSource: UITableViewDataSource {
    // The cell that is returned must be retrieved from a call
    // to -dequeueReusableMultiSelectSelectedViewCellWithReuseIdentifier:forIndexPath:
    func multiSelectSelectedViewCellForMutliSelectTableView(_ multiSelectTableView: MultiSelectContoller, indexPath: IndexPath) -> MultiSelectSelectedViewCell
}

class MultiSelectContoller: UIView, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    // Displays MultiSelectItems
    @IBOutlet fileprivate var tableView: UITableView! {
        didSet {
            tableView.delegate = self
        }
    }
    
    // MultiSelectSelectedView
    @IBOutlet fileprivate var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    var multiSelectDataSource: MultiSelectDataSource? {
        didSet {
            guard let multiSelectDataSource = multiSelectDataSource else {
                tableView.dataSource = nil
                return
            }
            tableView.dataSource = multiSelectDataSource as UITableViewDataSource
        }
    }
    
    var selectedIndexPaths:[IndexPath]? {
        get {
            return sortedSelectedIndexPaths()
        }
    
        set {
            //TODO implement
           // tableView.selectedIndexPaths = newValue // is there a select method that takes an array of IP? 
           // collectionView.reloadData()
        }
    }
    
    // TODO setup process do we need to implement reloadData { tableView.reload, collectionView.reload }
    
    // multiSelectDataSource init
    init(frame: CGRect, style: UITableViewStyle) {
        let collectionViewX: CGFloat = 0
        let collectionViewY: CGFloat = 0
        let collectionViewHieght = frame.size.height/5
        let collectionViewWidth = frame.size.width
        
        let tableViewX: CGFloat = 0
        let tableViewY = collectionViewHieght
        let tableViewHieght = frame.size.height - collectionViewHieght
        let tableViewWidth = frame.size.width
        
        let collectionViewFrame = CGRect(x:collectionViewX,
                                         y: collectionViewY,
                                         width: collectionViewWidth,
                                         height: collectionViewHieght)
        
        let tableViewFrame = CGRect(x: tableViewX,
                                    y: tableViewY,
                                    width: tableViewWidth,
                                    height: tableViewHieght)
        
        super.init(frame: frame)
        
        tableView = UITableView(frame: tableViewFrame, style: style)
        collectionView = UICollectionView(frame: collectionViewFrame,
                                          collectionViewLayout: UICollectionViewFlowLayout())
        self.addSubview(tableView)
        self.addSubview(collectionView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        let ip = toCollectionViewIndexPath(tableViewIndexPath: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdenfifier, for: ip!)
        return cell as! MultiSelectSelectedViewCell
    }
    
    
    // MARK: Register MultiSelectItemCell
    func registerMultiSelectItemCellNib(nib: UINib?, forCellReuseIdentifier identifier: String) {
        tableView.register(nib, forCellReuseIdentifier: identifier)
    }
    
    func registerMultiSelectItemCell(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
        tableView.register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    func dequeueReusableMultiSelectItemCell(withIdentifier identifier: String,
                             for indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }
    
    func dequeueReusableMultiSelectItemCell(withIdentifier identifier: String) -> UITableViewCell? {
        return tableView.dequeueReusableCell(withIdentifier: identifier)
    }


    //MARK: UICollectionViewDataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let selected = sortedSelectedIndexPaths(), section == 0 else {
            return 0
        }
        return selected.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableWithReuseIdentifier:forIndexPath:
    // must be passed in a indexPath for the collectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let selectedIP = sortedSelectedIndexPaths(), indexPath.section == 0 else {
            fatalError() // consider trying to see if this is a tableViewIndexPath and if so returning the correct cell
        }
        let tableViewip = selectedIP[indexPath.row]
        let multiSelectDataSource = self.multiSelectDataSource!
        let cell = multiSelectDataSource.multiSelectSelectedViewCellForMutliSelectTableView(self, indexPath: tableViewip)
        
        return cell as UICollectionViewCell!
    }
    
    
    // MARK: UITableViewDelegate Methods
    
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // TODO consider implementing self.delegate.MultiSelectComponent(self, willSelectRowAt: indexPath)
        // but will need to deal with the case when a different indexPath is returned (This item may not be selected)
        guard let collectionViewIP = toCollectionViewIndexPath(tableViewIndexPath: indexPath) else {
            return nil
        }
        
        collectionView.insertItems(at: [collectionViewIP])
        return indexPath
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // TODO consider implementing self.delegate.MultiSelectComponent(self, didDeselectRowAt indexPath)
        guard let collectionViewIP = toCollectionViewIndexPath(tableViewIndexPath: indexPath) else {
            return
        }
        collectionView.deleteItems(at: [collectionViewIP])
    }
    

    // MARK: Helper method
    
    private func sortedSelectedIndexPaths() -> [IndexPath]? {
        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else {
            return nil
        }
        return selectedIndexPaths.sorted(by: { (first, second) -> Bool in
            if first.section < second.section {
                return true
            } else {
                return first.section == second.section && first.row < second.row
            }
        })
    }
    
    private func toCollectionViewIndexPath(tableViewIndexPath: IndexPath) -> IndexPath? {
        guard let selectedIP = sortedSelectedIndexPaths() else {
            return nil
        }
        let preceedingSelectedIndexPaths = selectedIP.filter { (ip) -> Bool in
            return ip.row < tableViewIndexPath.row && ip.section <= tableViewIndexPath.section
        }
        let collectionViewRow = preceedingSelectedIndexPaths.count
        let collectionViewSection = 0
        return IndexPath(row: collectionViewRow, section: collectionViewSection)
    }
}
