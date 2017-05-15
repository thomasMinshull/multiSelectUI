//
//  MultiSelectTableView.swift
//  MultiSelectComponent
//
//  Created by ThomasMinshull on 2017-05-12.
//  Copyright © 2017 DrBill. All rights reserved.
//

import UIKit

protocol MultiSelectDataSource: UITableViewDataSource {
    
}

class MultiSelectTableView: UIView, UICollectionViewDataSource {

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var collectionView: UICollectionView!
    
    // Note we should be implementing the collectionView's dataSource and have our own MultiSelectDataSource to exposose a subset of CollectionViewDataSource Methods 
    // MARK CollectionView DataSource Methods // consider moving this functions into a seporate object so I can hide thier method signatures
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { // would prefer it this was private but I get a compiler error
        guard let selectedRows = tableView.indexPathsForSelectedRows, section == 0 else {
            return 0
        }
        return selectedRows.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    }
    
    // Selection
    
    // returns nil or index path representing section and row of selection.
    var indexPathForSelectedRow: IndexPath? {
        get {
            return tableView.indexPathForSelectedRow
        }
    }
    
    var indexPathsForSelectedRows: [IndexPath]? {
        get {
            return tableView.indexPathsForSelectedRows
        }
    }
    
    // Selects and deselects rows. These methods will not call the delegate methods (-tableView:willSelectRowAtIndexPath: or tableView:didSelectRowAtIndexPath:), nor will it send out a notification.
    open func selectRow(at indexPath: IndexPath?, animated: Bool, scrollPosition: UITableViewScrollPosition) {
        tableView.selectRow(at: indexPath, animated: animated, scrollPosition: scrollPosition)
        // TODO need to insert row / add row to collectionView
    }
    
    open func deselectRow(at indexPath: IndexPath, animated: Bool) {
        tableView.deselectRow(at: indexPath, animated: animated)
        // TODO need to remove item from CollectionView
    }
    
    // MARK: implements tableView API, most cases simple passes message call to tableView
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
    
    var style: UITableViewStyle {
        get {
            return tableView.style
        }
    }
    
    weak var dataSource: UITableViewDataSource? {
        get {
            return tableView.dataSource
        }
        
        set {
            tableView.dataSource = newValue
        }
    }
    
    weak var delegate: UITableViewDelegate? {
        get {
            return tableView.delegate
        }
        
        set {
            tableView.delegate = newValue
        }
    }
    
    weak var prefetchDataSource: UITableViewDataSourcePrefetching? {
        get {
            return tableView.prefetchDataSource
        }
        
        set {
            tableView.prefetchDataSource = newValue
        }
    }
    
    // will return the default value if unset
    open var rowHeight: CGFloat {
        get {
            return tableView.rowHeight
        }
        
        set {
            tableView.rowHeight = newValue
        }
    }
    
    
}

/*
 open class UITableView : UIScrollView, NSCoding {
 
 
 open var sectionHeaderHeight: CGFloat // will return the default value if unset
 
 open var sectionFooterHeight: CGFloat // will return the default value if unset
 
 @available(iOS 7.0, *)
 open var estimatedRowHeight: CGFloat // default is 0, which means there is no estimate
 
 @available(iOS 7.0, *)
 open var estimatedSectionHeaderHeight: CGFloat // default is 0, which means there is no estimate
 
 @available(iOS 7.0, *)
 open var estimatedSectionFooterHeight: CGFloat // default is 0, which means there is no estimate
 
 @available(iOS 7.0, *)
 open var separatorInset: UIEdgeInsets // allows customization of the frame of cell separators
 
 
 @available(iOS 3.2, *)
 open var backgroundView: UIView? // the background view will be automatically resized to track the size of the table view.  this will be placed as a subview of the table view behind all cells and headers/footers.  default may be non-nil for some devices.
 
 
 // Data
 
 open func reloadData() // reloads everything from scratch. redisplays visible rows. because we only keep info about visible rows, this is cheap. will adjust offset if table shrinks
 
 @available(iOS 3.0, *)
 open func reloadSectionIndexTitles() // reloads the index bar.
 
 
 // Info
 
 open var numberOfSections: Int { get }
 
 open func numberOfRows(inSection section: Int) -> Int
 
 
 open func rect(forSection section: Int) -> CGRect // includes header, footer and all rows
 
 open func rectForHeader(inSection section: Int) -> CGRect
 
 open func rectForFooter(inSection section: Int) -> CGRect
 
 open func rectForRow(at indexPath: IndexPath) -> CGRect
 
 
 open func indexPathForRow(at point: CGPoint) -> IndexPath? // returns nil if point is outside of any row in the table
 
 open func indexPath(for cell: UITableViewCell) -> IndexPath? // returns nil if cell is not visible
 
 open func indexPathsForRows(in rect: CGRect) -> [IndexPath]? // returns nil if rect not valid
 
 
 open func cellForRow(at indexPath: IndexPath) -> UITableViewCell? // returns nil if cell is not visible or index path is out of range
 
 open var visibleCells: [UITableViewCell] { get }
 
 open var indexPathsForVisibleRows: [IndexPath]? { get }
 
 
 @available(iOS 6.0, *)
 open func headerView(forSection section: Int) -> UITableViewHeaderFooterView?
 
 @available(iOS 6.0, *)
 open func footerView(forSection section: Int) -> UITableViewHeaderFooterView?
 
 
 open func scrollToRow(at indexPath: IndexPath, at scrollPosition: UITableViewScrollPosition, animated: Bool)
 
 open func scrollToNearestSelectedRow(at scrollPosition: UITableViewScrollPosition, animated: Bool)
 
 
 // Row insertion/deletion/reloading.
 
 open func beginUpdates() // allow multiple insert/delete of rows and sections to be animated simultaneously. Nestable
 
 open func endUpdates() // only call insert/delete/reload calls or change the editing state inside an update block.  otherwise things like row count, etc. may be invalid.
 
 
 open func insertSections(_ sections: IndexSet, with animation: UITableViewRowAnimation)
 
 open func deleteSections(_ sections: IndexSet, with animation: UITableViewRowAnimation)
 
 @available(iOS 3.0, *)
 open func reloadSections(_ sections: IndexSet, with animation: UITableViewRowAnimation)
 
 @available(iOS 5.0, *)
 open func moveSection(_ section: Int, toSection newSection: Int)
 
 
 open func insertRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation)
 
 open func deleteRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation)
 
 @available(iOS 3.0, *)
 open func reloadRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation)
 
 @available(iOS 5.0, *)
 open func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath)
 
 
 // Editing. When set, rows show insert/delete/reorder controls based on data source queries
 
 open var isEditing: Bool // default is NO. setting is not animated.
 
 open func setEditing(_ editing: Bool, animated: Bool)
 
 
 @available(iOS 3.0, *)
 open var allowsSelection: Bool // default is YES. Controls whether rows can be selected when not in editing mode
 
 open var allowsSelectionDuringEditing: Bool // default is NO. Controls whether rows can be selected when in editing mode
 
 @available(iOS 5.0, *)
 open var allowsMultipleSelection: Bool // default is NO. Controls whether multiple rows can be selected simultaneously
 
 @available(iOS 5.0, *)
 open var allowsMultipleSelectionDuringEditing: Bool // default is NO. Controls whether multiple rows can be selected simultaneously in editing mode
 
 
 // Selection
 
 open var indexPathForSelectedRow: IndexPath? { get } // returns nil or index path representing section and row of selection.
 
 @available(iOS 5.0, *)
 open var indexPathsForSelectedRows: [IndexPath]? { get } // returns nil or a set of index paths representing the sections and rows of the selection.
 
 
 // Selects and deselects rows. These methods will not call the delegate methods (-tableView:willSelectRowAtIndexPath: or tableView:didSelectRowAtIndexPath:), nor will it send out a notification.
 open func selectRow(at indexPath: IndexPath?, animated: Bool, scrollPosition: UITableViewScrollPosition)
 
 open func deselectRow(at indexPath: IndexPath, animated: Bool)
 
 
 // Appearance
 
 open var sectionIndexMinimumDisplayRowCount: Int // show special section index list on right when row count reaches this value. default is 0
 
 @available(iOS 6.0, *)
 open var sectionIndexColor: UIColor? // color used for text of the section index
 
 @available(iOS 7.0, *)
 open var sectionIndexBackgroundColor: UIColor? // the background color of the section index while not being touched
 
 @available(iOS 6.0, *)
 open var sectionIndexTrackingBackgroundColor: UIColor? // the background color of the section index while it is being touched
 
 
 open var separatorStyle: UITableViewCellSeparatorStyle // default is UITableViewCellSeparatorStyleSingleLine
 
 open var separatorColor: UIColor? // default is the standard separator gray
 
 @available(iOS 8.0, *)
 @NSCopying open var separatorEffect: UIVisualEffect? // effect to apply to table separators
 
 
 @available(iOS 9.0, *)
 open var cellLayoutMarginsFollowReadableWidth: Bool // if cell margins are derived from the width of the readableContentGuide.
 
 
 open var tableHeaderView: UIView? // accessory view for above row content. default is nil. not to be confused with section header
 
 open var tableFooterView: UIView? // accessory view below content. default is nil. not to be confused with section footer
 
 
 open func dequeueReusableCell(withIdentifier identifier: String) -> UITableViewCell? // Used by the delegate to acquire an already allocated cell, in lieu of allocating a new one.
 
 @available(iOS 6.0, *)
 open func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell // newer dequeue method guarantees a cell is returned and resized properly, assuming identifier is registered
 
 @available(iOS 6.0, *)
 open func dequeueReusableHeaderFooterView(withIdentifier identifier: String) -> UITableViewHeaderFooterView? // like dequeueReusableCellWithIdentifier:, but for headers/footers
 
 
 // Beginning in iOS 6, clients can register a nib or class for each cell.
 // If all reuse identifiers are registered, use the newer -dequeueReusableCellWithIdentifier:forIndexPath: to guarantee that a cell instance is returned.
 // Instances returned from the new dequeue method will also be properly sized when they are returned.
 @available(iOS 5.0, *)
 open func register(_ nib: UINib?, forCellReuseIdentifier identifier: String)
 
 @available(iOS 6.0, *)
 open func register(_ cellClass: Swift.AnyClass?, forCellReuseIdentifier identifier: String)
 
 
 @available(iOS 6.0, *)
 open func register(_ nib: UINib?, forHeaderFooterViewReuseIdentifier identifier: String)
 
 @available(iOS 6.0, *)
 open func register(_ aClass: Swift.AnyClass?, forHeaderFooterViewReuseIdentifier identifier: String)
 
 
 // Focus
 
 @available(iOS 9.0, *)
 open var remembersLastFocusedIndexPath: Bool // defaults to NO. If YES, when focusing on a table view the last focused index path is focused automatically. If the table view has never been focused, then the preferred focused index path is used.
 }

 
*/

/*
 
 public protocol UITableViewDataSource : NSObjectProtocol {
 
 
 @available(iOS 2.0, *)
 public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
 
 
 // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
 // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
 
 @available(iOS 2.0, *)
 public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
 
 
 @available(iOS 2.0, *)
 optional public func numberOfSections(in tableView: UITableView) -> Int // Default is 1 if not implemented
 
 
 @available(iOS 2.0, *)
 optional public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? // fixed font style. use custom view (UILabel) if you want something different
 
 @available(iOS 2.0, *)
 optional public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
 
 
 // Editing
 
 // Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
 @available(iOS 2.0, *)
 optional public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
 
 
 // Moving/reordering
 
 // Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
 @available(iOS 2.0, *)
 optional public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
 
 
 // Index
 
 @available(iOS 2.0, *)
 optional public func sectionIndexTitles(for tableView: UITableView) -> [String]? // return list of section titles to display in section index view (e.g. "ABCD...Z#")
 
 @available(iOS 2.0, *)
 optional public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int // tell table which section corresponds to section title/index (e.g. "B",1))
 
 
 // Data manipulation - insert and delete support
 
 // After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
 // Not called for edit actions using UITableViewRowAction - the action's handler will be invoked instead
 @available(iOS 2.0, *)
 optional public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
 
 
 // Data manipulation - reorder / moving support
 
 @available(iOS 2.0, *)
 optional public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
 }


*/

/*
 
 public protocol UITableViewDelegate : NSObjectProtocol, UIScrollViewDelegate {
 
 
 // Display customization
 
 @available(iOS 2.0, *)
 optional public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
 
 @available(iOS 6.0, *)
 optional public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
 
 @available(iOS 6.0, *)
 optional public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int)
 
 @available(iOS 6.0, *)
 optional public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
 
 @available(iOS 6.0, *)
 optional public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int)
 
 @available(iOS 6.0, *)
 optional public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int)
 
 
 // Variable height support
 
 @available(iOS 2.0, *)
 optional public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
 
 @available(iOS 2.0, *)
 optional public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
 
 @available(iOS 2.0, *)
 optional public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
 
 
 // Use the estimatedHeight methods to quickly calcuate guessed values which will allow for fast load times of the table.
 // If these methods are implemented, the above -tableView:heightForXXX calls will be deferred until views are ready to be displayed, so more expensive logic can be placed there.
 @available(iOS 7.0, *)
 optional public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
 
 @available(iOS 7.0, *)
 optional public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat
 
 @available(iOS 7.0, *)
 optional public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat
 
 
 // Section header & footer information. Views are preferred over title should you decide to provide both
 
 @available(iOS 2.0, *)
 optional public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? // custom view for header. will be adjusted to default or specified header height
 
 @available(iOS 2.0, *)
 optional public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? // custom view for footer. will be adjusted to default or specified footer height
 
 
 @available(iOS 2.0, *)
 optional public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath)
 
 
 // Selection
 
 // -tableView:shouldHighlightRowAtIndexPath: is called when a touch comes down on a row.
 // Returning NO to that message halts the selection process and does not cause the currently selected row to lose its selected look while the touch is down.
 @available(iOS 6.0, *)
 optional public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool
 
 @available(iOS 6.0, *)
 optional public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath)
 
 @available(iOS 6.0, *)
 optional public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath)
 
 
 // Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
 @available(iOS 2.0, *)
 optional public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
 
 @available(iOS 3.0, *)
 optional public func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath?
 
 // Called after the user changes the selection.
 @available(iOS 2.0, *)
 optional public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
 
 @available(iOS 3.0, *)
 optional public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
 
 
 // Editing
 
 // Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
 @available(iOS 2.0, *)
 optional public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle
 
 @available(iOS 3.0, *)
 optional public func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
 
 @available(iOS 8.0, *)
 optional public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? // supercedes -tableView:titleForDeleteConfirmationButtonForRowAtIndexPath: if return value is non-nil
 
 
 // Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
 @available(iOS 2.0, *)
 optional public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool
 
 
 // The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
 @available(iOS 2.0, *)
 optional public func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath)
 
 @available(iOS 2.0, *)
 optional public func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?)
 
 
 // Moving/reordering
 
 // Allows customization of the target row for a particular row as it is being moved/reordered
 @available(iOS 2.0, *)
 optional public func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath
 
 
 // Indentation
 
 @available(iOS 2.0, *)
 optional public func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int // return 'depth' of row for hierarchies
 
 
 // Copy/Paste.  All three methods must be implemented by the delegate.
 
 @available(iOS 5.0, *)
 optional public func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool
 
 @available(iOS 5.0, *)
 optional public func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool
 
 @available(iOS 5.0, *)
 optional public func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?)
 
 
 // Focus
 
 @available(iOS 9.0, *)
 optional public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool
 
 @available(iOS 9.0, *)
 optional public func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool
 
 @available(iOS 9.0, *)
 optional public func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator)
 
 @available(iOS 9.0, *)
 optional public func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath?
 }

 */

/*
 // this protocol can provide information about cells before they are displayed on screen.
 
 public protocol UITableViewDataSourcePrefetching : NSObjectProtocol {
 
 
 // indexPaths are ordered ascending by geometric distance from the table view
 @available(iOS 2.0, *)
 public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath])
 
 
 // indexPaths that previously were considered as candidates for pre-fetching, but were not actually used; may be a subset of the previous call to -tableView:prefetchRowsAtIndexPaths:
 @available(iOS 2.0, *)
 optional public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath])
 }

 
 */
