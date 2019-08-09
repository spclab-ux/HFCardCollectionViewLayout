//
//  HFCardCollectionViewLayoutAttributes.swift
//  HFCardCollectionViewLayout
//
//  Created by Max Hiroyuki Ueda on 09/08/19.
//  Copyright © 2019 hendrik-frahmann. All rights reserved.
//

import UIKit
/// Layout attributes for the HFCardCollectionViewLayout
/// Moved
open class HFCardCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {

    /// Specifies if the CardCell is revealed.
    public var isRevealed = false

    /// Overwritten to copy also the 'isRevealed' flag.
    override open func copy(with zone: NSZone? = nil) -> Any {
        let attribute = (super.copy(with: zone) as? HFCardCollectionViewLayoutAttributes)!
        attribute.isRevealed = isRevealed
        return attribute
    }
}
