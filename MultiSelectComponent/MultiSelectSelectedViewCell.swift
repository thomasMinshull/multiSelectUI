//
//  MultiSelectSelectedViewCell.swift
//  MultiSelectComponent
//
//  Created by ThomasMinshull on 2017-05-16.
//  Copyright © 2017 DrBill. All rights reserved.
//

import UIKit

class MultiSelectSelectedViewCell: UICollectionViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    
    var textLabel: UILabel! {
        get {
            return self.textLabel
        }
        
        set {
            self.textLabel = newValue
        }
    }
    
    var detailTextLabel: UILabel! {
        get {
            return self.detailTextLabel
        }
        
        set {
            self.detailTextLabel = newValue
        }
    }
    
}
