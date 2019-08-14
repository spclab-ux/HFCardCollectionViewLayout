//
//  HFCardCollectionViewLayoutModel.swift
//  HFCardCollectionViewLayout
//
//  Created by Max Hiroyuki Ueda on 09/08/19.
//  Copyright © 2019 hendrik-frahmann. All rights reserved.
//

import UIKit

open class HFCardCollectionViewModel: NSObject {
     var cvIsInitialized = false
     var cvItemCount: Int = 0
     var cvTapGestureRecognizer: UITapGestureRecognizer?
     var cvIgnoreBottomContentOffsetChanges: Bool = false
     var cvLastBottomContentOffset: CGFloat = 0
     var cvForceUnreveal: Bool = false
     var cvDeletedIndexPaths = [IndexPath]()
     var cvTemporaryTop: CGFloat = 0
     var cdCollBoundsSize: CGSize = .zero
     var cdCollViewLayoutAttributes: [HFCardCollectionViewLayoutAttributes]!
     var cdCollBottomCardsSet: [Int] = []
     var cdCollBottomCardsRevealedIndex: CGFloat = 0
     var cdCollCellSize: CGSize = .zero
     var rvldCdCell: UICollectionViewCell?
     var rvldCdPanGestureRecognizer: UIPanGestureRecognizer?
     var rvldCdPanGestureTouchLocationY: CGFloat = 0
     var rvldCdFlipView: UIView?
     var rvldCdIsFlipped: Bool = false
     var mvCdSelectedIndex: Int = -1
     var mvCdGestureRecognizer: UILongPressGestureRecognizer?
     var mvCdActive: Bool = false
     var mvCdGestureStartLocation: CGPoint = .zero
     var mvCdGestureCurrentLocation: CGPoint = .zero
     var mvCdCenterStart: CGPoint = .zero
     var mvCdSnapshotCell: UIView?
     var mvCdLastTouchedLocation: CGPoint = .zero
     var mvCdLastTouchedIndexPath: IndexPath?
     var mvCdStartIndexPath: IndexPath?
     var autoscrollDisplayLink: CADisplayLink?
     var autoscrollDirection: HFCardCollectionScrollDirection = .unknown
}
