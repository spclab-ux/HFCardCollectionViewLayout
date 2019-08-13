//
//  HFCardCollectionViewLayoutModel.swift
//  HFCardCollectionViewLayout
//
//  Created by Max Hiroyuki Ueda on 09/08/19.
//  Copyright © 2019 hendrik-frahmann. All rights reserved.
//

import UIKit

open class HFCardCollectionViewLayoutModel: NSObject {
    private var cvIsInitialized = false
    private var cvItemCount: Int = 0
    private var cvTapGestureRecognizer: UITapGestureRecognizer?
    private var cvIgnoreBottomContentOffsetChanges: Bool = false
    private var cvLastBottomContentOffset: CGFloat = 0
    private var cvForceUnreveal: Bool = false
    private var cvDeletedIndexPaths = [IndexPath]()
    private var cvTemporaryTop: CGFloat = 0
    private var cdCollBoundsSize: CGSize = .zero
    private var cdCollViewLayoutAttributes: [HFCardCollectionViewLayoutAttributes]!
    private var cdCollBottomCardsSet: [Int] = []
    private var cdCollBottomCardsRevealedIndex: CGFloat = 0
    private var cdCollCellSize: CGSize = .zero
    private var rvldCdCell: UICollectionViewCell?
    private var rvldCdPanGestureRecognizer: UIPanGestureRecognizer?
    private var rvldCdPanGestureTouchLocationY: CGFloat = 0
    private var rvldCdFlipView: UIView?
    private var rvldCdIsFlipped: Bool = false
    private var mvCdSelectedIndex: Int = -1
    private var mvCdGestureRecognizer: UILongPressGestureRecognizer?
    private var mvCdActive: Bool = false
    private var mvCdGestureStartLocation: CGPoint = .zero
    private var mvCdGestureCurrentLocation: CGPoint = .zero
    private var mvCdCenterStart: CGPoint = .zero
    private var mvCdSnapshotCell: UIView?
    private var mvCdLastTouchedLocation: CGPoint = .zero
    private var mvCdLastTouchedIndexPath: IndexPath?
    private var mvCdStartIndexPath: IndexPath?
    var autoscrollDisplayLink: CADisplayLink?
}
