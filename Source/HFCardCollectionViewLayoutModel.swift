//
//  HFCardCollectionViewLayoutModel.swift
//  HFCardCollectionViewLayout
//
//  Created by Max Hiroyuki Ueda on 09/08/19.
//  Copyright © 2019 hendrik-frahmann. All rights reserved.
//

import UIKit

open class HFCardCollectionViewLayoutModel: NSObject {
     var collectionViewIsInitialized = false
     var collectionViewItemCount: Int = 0
     var collectionViewTapGestureRecognizer: UITapGestureRecognizer?
     var collectionViewIgnoreBtCtOffsetChanges: Bool = false
     var collectionViewLastBottomContentOffset: CGFloat = 0
     var collectionViewForceUnreveal: Bool = false
     var collectionViewDeletedIndexPaths = [IndexPath]()
     var collectionViewTemporaryTop: CGFloat = 0

     var cardCollectionBoundsSize: CGSize = .zero
     var cardCollectionViewLayoutAttributes: [HFCardCollectionViewLayoutAttributes]!
     var cardCollectionBottomCardsSet: [Int] = []
     var cardCollectionBottomCardsRevealedIndex: CGFloat = 0
     var cardCollectionCellSize: CGSize = .zero

     var revealedCardCell: UICollectionViewCell?
     var rvldCardPanGestRecognizer: UIPanGestureRecognizer?
     var rvldCardPanGestureTouchLocationY: CGFloat = 0
     var rvldCardFlipView: UIView?
     var rvldCardIsFlipped: Bool = false

     var mvngCardSelectedIndex: Int = -1
     var mvngCardGestureRecognizer: UILongPressGestureRecognizer?
     var mvngCardActive: Bool = false
     var mvngCardGestureStartLocation: CGPoint = .zero
     var mvngCardGestureCurrentLocation: CGPoint = .zero
     var mvngCardCenterStart: CGPoint = .zero
     var mvngCardSnapshotCell: UIView?
     var mvngCardLastTouchedLocation: CGPoint = .zero
     var mvngCardLastTouchedIndexPath: IndexPath?
     var mvngCardStartIndexPath: IndexPath?

     var autoscrollDisplayLink: CADisplayLink?
}
