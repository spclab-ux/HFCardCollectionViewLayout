//
//  HFCardCollectionViewLayout.swift
//  HFCardCollectionViewLayout
//
//  Created by Hendrik Frahmann on 02.11.16.
//  Copyright © 2016 Hendrik Frahmann. All rights reserved.
//

// swiftlint:disable type_body_length file_length

import UIKit

/// The HFCardCollectionViewLayout provides a card stack layout not quite similar like the apps Reminder and Wallet.
open class HFCardCollectionViewLayout: UICollectionViewLayout, UIGestureRecognizerDelegate {
    // MARK: Public Variables
    /// Only cards with index equal or greater than firstMovableIndex can be moved through the collectionView.
    ///
    /// Default: 0
    @IBInspectable open var firstMovableIndex: Int = 0
    /// Specifies the height that is showing the cardhead when the collectionView is showing all cards.
    ///
    /// The minimum value is 20.
    ///
    /// Default: 80
    @IBInspectable open var cardHeadHeight: CGFloat = 80 {
        didSet {
            if cardHeadHeight < 20 {
                cardHeadHeight = 20
                return
            }
            self.collectionView?.performBatchUpdates({ self.invalidateLayout() }, completion: nil)
        }
    }
    /// When th collectionView is showing all cards but there are not enough cards to fill the full height,
    /// the cardHeadHeight will be expanded to equally fill the height.
    ///
    /// Default: true
    @IBInspectable open var cardShouldExpandHeadHeight: Bool = true {
        didSet {
            self.collectionView?.performBatchUpdates({ self.invalidateLayout() }, completion: nil)
        }
    }
    /// Stretch the cards when scrolling up
    ///
    /// Default: true
    @IBInspectable open var cardShouldStretchAtScrollTop: Bool = true {
        didSet {
            self.collectionView?.performBatchUpdates({ self.invalidateLayout() }, completion: nil)
        }
    }
    /// Specifies the maximum height of the cards.
    ///
    /// But the height can be less if the frame size of collectionView is smaller.
    ///
    /// Default: 0 (no height specified)
    @IBInspectable open var cardMaximumHeight: CGFloat = 0 {
        didSet {
            if cardMaximumHeight < 0 {
                cardMaximumHeight = 0
                return
            }
            self.collectionView?.performBatchUpdates({ self.invalidateLayout() }, completion: nil)
        }
    }
    /// Count of bottom stacked cards when a card is revealed.
    ///
    /// Value must be between 0 and 10
    ///
    /// Default: 5
    @IBInspectable open var bottomNumberOfStackedCards: Int = 5 {
        didSet {
            if bottomNumberOfStackedCards < 0 {
                bottomNumberOfStackedCards = 0
                return
            }
            if bottomNumberOfStackedCards > 10 {
                bottomNumberOfStackedCards = 10
                return
            }
            self.collectionView?.performBatchUpdates({ self.collectionView?.reloadData() }, completion: nil)
        }
    }
    /// All bottom stacked cards are scaled to produce the 3D effect.
    ///
    /// Default: true
    @IBInspectable open var bottomStackedCardsShouldScale: Bool = true {
        didSet {
            self.collectionView?.performBatchUpdates({ self.invalidateLayout() }, completion: nil)
        }
    }
    /// The minimum scale for the bottom cards.
    ///
    /// Default: 0.94
    @IBInspectable open var bottomStackedCardsMinimumScale: CGFloat = 0.94 {
        didSet {
            if self.bottomStackedCardsMinimumScale < 0.0 {
                self.bottomStackedCardsMinimumScale = 0.0
                return
            }
            self.collectionView?.performBatchUpdates({ self.invalidateLayout() }, completion: nil)
        }
    }
    /// The maximum scale for the bottom cards.
    ///
    /// Default: 0.94
    @IBInspectable open var bottomStackedCardsMaximumScale: CGFloat = 1.0 {
        didSet {
            if self.bottomStackedCardsMaximumScale > 1.0 {
                self.bottomStackedCardsMaximumScale = 1.0
                return
            }
            self.collectionView?.performBatchUpdates({ self.invalidateLayout() }, completion: nil)
        }
    }
    /// Specifies the margin for the top margin of a bottom stacked card.
    ///
    /// Value can be between 0 and 20
    ///
    /// Default: 10
    @IBInspectable open var bottomCardLookoutMargin: CGFloat = 10 {
        didSet {
            if bottomCardLookoutMargin < 0 {
                bottomCardLookoutMargin = 0
                return
            }
            if bottomCardLookoutMargin > 20 {
                bottomCardLookoutMargin = 20
                return
            }
            self.collectionView?.performBatchUpdates({ self.invalidateLayout() }, completion: nil)
        }
    }
    /// An additional topspace to show the top of the collectionViews backgroundView.
    ///
    /// Default: 0
    @IBInspectable open var spaceAtTopForBackgroundView: CGFloat = 0 {
        didSet {
            if spaceAtTopForBackgroundView < 0 {
                spaceAtTopForBackgroundView = 0
                return
            }
            self.collectionView?.performBatchUpdates({ self.invalidateLayout() }, completion: nil)
        }
    }
    /// Snaps the scrollView if the contentOffset is on the 'spaceAtTopForBackgroundView'
    ///
    /// Default: true
    @IBInspectable open var spaceAtTopShouldSnap: Bool = true
    /// Additional space at the bottom to expand the contentsize of the collectionView.
    ///
    /// Default: 0
    @IBInspectable open var spaceAtBottom: CGFloat = 0 {
        didSet {
            self.collectionView?.performBatchUpdates({ self.invalidateLayout() }, completion: nil)
        }
    }
    /// Area the top where to autoscroll while moving a card.
    ///
    /// Default 120
    @IBInspectable open var scrollAreaTop: CGFloat = 120 {
        didSet {
            if scrollAreaTop < 0 {
                scrollAreaTop = 0
                return
            }
        }
    }
    /// Area ot the bottom where to autoscroll while moving a card.
    ///
    /// Default 120
    @IBInspectable open var scrollAreaBottom: CGFloat = 120 {
        didSet {
            if scrollAreaBottom < 0 {
                scrollAreaBottom = 0
                return
            }
        }
    }
    /// The scrollView should snap the cardhead to the top.
    ///
    /// Default: false
    @IBInspectable open var scrollShouldSnapCardHead: Bool = false
    /// Cards are stopping at top while scrolling.
    ///
    /// Default: true
    @IBInspectable open var scrollStopCardsAtTop: Bool = true {
        didSet {
            self.collectionView?.performBatchUpdates({ self.invalidateLayout() }, completion: nil)
        }
    }
    /// All cards are collapsed at bottom.
    ///
    /// Default: false
    @IBInspectable open var collapseAllCards: Bool = false {
        didSet {
            self.flipRevealedCardBack(completion: {
                self.collectionView?.isScrollEnabled = !self.collapseAllCards
                var prvsRvldIndex = -1
                let collectionViewLayoutDelegate = self.collectionView?.delegate as? HFCardCollectionViewLayoutDelegate
                if self.revealedIndex >= 0 {
                    prvsRvldIndex =
                        self.revealedIndex
                    collectionViewLayoutDelegate?.cardCollectionViewLayout?(self,
                                                                            willUnrevealCardAtIndex: self.revealedIndex)
                    self.revealedIndex = -1
                }
                self.collectionView?.performBatchUpdates({ self.collectionView?.reloadData() }, completion: {(_) in
                    if prvsRvldIndex >= 0 {
                        collectionViewLayoutDelegate?.cardCollectionViewLayout?(self,
                                                                                didUnrevealCardAtIndex: prvsRvldIndex)
                    }
                })
            })
        }
    }
    /// Contains the revealed index.
    /// ReadOnly.
    private(set) open var revealedIndex: Int = -1
    // MARK: Public Actions
    /// Action for the InterfaceBuilder to flip back the revealed card.
    @IBAction open func flipBackRevealedCardAction() {
        self.flipRevealedCardBack()
    }
    /// Action for the InterfaceBuilder to Unreveal the revealed card.
    @IBAction open func unrevealRevealedCardAction() {
        self.unrevealCard()
    }
    /// Action to collapse all cards.
    @IBAction open func collapseAllCardsAction() {
        self.collapseAllCards = true
    }
    // MARK: Public Functions
    /// Reveal a card at the given index.
    ///
    /// - Parameter index: The index of the card.
    /// - Parameter completion: An optional completion block. Will be executed the animation is finished.
    open func revealCardAt(index: Int, completion: (() -> Void)? = nil) {
        var index = index
        let collectionViewLayoutDelegate = self.collectionView?.delegate as? HFCardCollectionViewLayoutDelegate
        let oldRevealedIndex = self.revealedIndex
        if oldRevealedIndex < 0 && index >= 0 && self.collapseAllCards == true {
            index = oldRevealedIndex
            self.collapseAllCards = false
            return
        }
        if ((self.revealedIndex >= 0 && self.revealedIndex == index) ||
            (self.revealedIndex >= 0 && index < 0)) && self.component.rvldCdIsFlipped == true {
            // do nothing, because the card is flipped
        } else if self.revealedIndex >= 0 && index >= 0 {
            if self.component.cvForceUnreveal == false {
                if collectionViewLayoutDelegate?.cardCollectionViewLayout?(self,
                                                                           canUnrevealCardAtIndex:
                    self.revealedIndex) == false {
                    return
                }
            }
            self.component.cvForceUnreveal = false
            if self.component.rvldCdIsFlipped == true {
                self.revealCardFlipped(at: index, and: oldRevealedIndex, with: collectionViewLayoutDelegate,
                                       completion: completion)
            } else {
                self.collectionView?.isScrollEnabled = true
                self.deinitializeRevealedCard()
                collectionViewLayoutDelegate?.cardCollectionViewLayout?(self,
                                                                        willUnrevealCardAtIndex: self.revealedIndex)
                self.revealedIndex = -1
                self.collectionView?.performBatchUpdates({ self.collectionView?.reloadData() }, completion: {(_) in
                    collectionViewLayoutDelegate?.cardCollectionViewLayout?(self,
                                                                            didUnrevealCardAtIndex: oldRevealedIndex)
                    completion?()
                })
            }
        } else {
            self.revealCardReorder(at: index, and: oldRevealedIndex, with: collectionViewLayoutDelegate,
                                   completion: completion)
        }
    }

    /// Mark: RevealCard refactory
    internal func revealCardFlipped(at index: Int,
                                    and oldRevealedIndex: Int,
                                    with collectionViewLayoutDelegate: HFCardCollectionViewLayoutDelegate?,
                                    completion: (() -> Void)? = nil) {
        self.flipRevealedCardBack(completion: {
            self.collectionView?.isScrollEnabled = true
            self.deinitializeRevealedCard()
            collectionViewLayoutDelegate?.cardCollectionViewLayout?(self,
                                                                    willUnrevealCardAtIndex: self.revealedIndex)
            self.revealedIndex = -1
            self.collectionView?.performBatchUpdates({ self.collectionView?.reloadData() }, completion: {(_) in
                collectionViewLayoutDelegate?.cardCollectionViewLayout?(self,
                                                                        didUnrevealCardAtIndex:
                    oldRevealedIndex)
                completion?()
            })
        })
    }

    internal func revealCardReorder(at index: Int,
                                    and oldRevealedIndex: Int,
                                    with collectionViewLayoutDelegate: HFCardCollectionViewLayoutDelegate?,
                                    completion: (() -> Void)? = nil) {
        if index < 0 && self.revealedIndex >= 0 {
            self.deinitializeRevealedCard()
            collectionViewLayoutDelegate?.cardCollectionViewLayout?(self,
                                                                    willUnrevealCardAtIndex: self.revealedIndex)
        }
        if index >= 0 {
            self.revealedIndex = index
            if collectionViewLayoutDelegate?.cardCollectionViewLayout?(self, canRevealCardAtIndex: index) == false {
                self.revealedIndex = -1
                self.collectionView?.isScrollEnabled = true
                self.deinitializeRevealedCard()
                return
            }
            collectionViewLayoutDelegate?.cardCollectionViewLayout?(self, willRevealCardAtIndex: index)
            _ = self.initializeRevealedCard()
            self.collectionView?.isScrollEnabled = false
            self.collectionView?.performBatchUpdates({ self.collectionView?.reloadData() }, completion: { (_) in
                collectionViewLayoutDelegate?.cardCollectionViewLayout?(self,
                                                                        didRevealCardAtIndex: self.revealedIndex)
                completion?()
            })
        } else if self.revealedIndex >= 0 {
            self.revealedIndex = index
            self.collectionView?.isScrollEnabled = false
            self.collectionView?.performBatchUpdates({ self.collectionView?.reloadData() }, completion: {(_) in
                collectionViewLayoutDelegate?.cardCollectionViewLayout?(self,
                                                                        didUnrevealCardAtIndex: oldRevealedIndex)
                completion?()
            })
        }
        self.revealedIndex = index
    }

    /// Unreveal the revealed card
    ///
    /// - Parameter completion: An optional completion block. Will be executed the animation is finished.
    open func unrevealCard(completion: (() -> Void)? = nil) {
        if self.revealedIndex == -1 {
            completion?()
        } else if self.component.rvldCdIsFlipped == true {
            self.flipRevealedCardBack(completion: {
                self.component.cvForceUnreveal = true
                self.revealCardAt(index: self.revealedIndex, completion: completion)
            })
        } else {
            self.component.cvForceUnreveal = true
            self.revealCardAt(index: self.revealedIndex, completion: completion)
        }
    }
    /// Flips the revealed card to the given view.
    /// The frame for the view will be the same as the cell
    ///
    /// - Parameter toView: The view for the backview of te card.
    /// - Parameter completion: An optional completion block. Will be executed the animation is finished.
    open func flipRevealedCard(toView: UIView, completion: (() -> Void)? = nil) {
        if self.component.rvldCdIsFlipped == true {
            return
        }
        if let cardCell = self.component.rvldCdCell, self.revealedIndex >= 0 {
            toView.removeFromSuperview()
            self.component.rvldCdFlipView = toView
            toView.frame = CGRect(x: 0, y: 0, width: cardCell.frame.width, height: cardCell.frame.height)
            toView.isHidden = true
            cardCell.addSubview(toView)
            self.component.rvldCdIsFlipped = true
            UIApplication.shared.keyWindow?.endEditing(true)
            let originalShouldRasterize = cardCell.layer.shouldRasterize
            cardCell.layer.shouldRasterize = false
            UIView.transition(with: cardCell, duration: 0.5,
                              options: [.transitionFlipFromRight], animations: { () -> Void in
                cardCell.contentView.isHidden = true
                toView.isHidden = false
            }, completion: { (_) -> Void in
                cardCell.layer.shouldRasterize = originalShouldRasterize
                completion?()
            })
        }
    }
    /// Flips the flipped card back to the frontview.
    ///
    /// - Parameter completion: An optional completion block. Will be executed the animation is finished.
    open func flipRevealedCardBack(completion: (() -> Void)? = nil) {
        if self.component.rvldCdIsFlipped == false {
            completion?()
            return
        }
        if let cardCell = self.component.rvldCdCell {
            if let flipView = self.component.rvldCdFlipView {
                let originalShouldRasterize = cardCell.layer.shouldRasterize
                UIApplication.shared.keyWindow?.endEditing(true)
                cardCell.layer.shouldRasterize = false
                UIView.transition(with: cardCell, duration: 0.5, options: [.transitionFlipFromLeft],
                                  animations: { () -> Void in
                    flipView.isHidden = true
                    cardCell.contentView.isHidden = false
                }, completion: { (_) -> Void in
                    flipView.removeFromSuperview()
                    cardCell.layer.shouldRasterize = originalShouldRasterize
                    self.component.rvldCdFlipView = nil
                    self.component.rvldCdIsFlipped = false
                    completion?()
                })
            }
        }
    }
    open func willInsert(indexPaths: [IndexPath]) {
        for indexPath in indexPaths where indexPath.section == 0 &&
            indexPath.item <= self.revealedIndex {
                    self.component.cvTemporaryTop += self.cardHeadHeight
                    self.revealedIndex += 1
            }
    }

    open func willDelete(indexPaths: [IndexPath]) {
        let collectionViewLayoutDelegate = self.collectionView?.delegate as? HFCardCollectionViewLayoutDelegate
        for indexPath in indexPaths where indexPath.section == 0 {
                if indexPath.item == self.revealedIndex {
                    self.revealedIndex = -1
                    self.collectionView?.isScrollEnabled = true
                    self.deinitializeRevealedCard()
                    collectionViewLayoutDelegate?.cardCollectionViewLayout?(self,
                                                                            willUnrevealCardAtIndex: indexPath.item)
                }
                if indexPath.item <= self.revealedIndex {
                    self.component.cvTemporaryTop -= self.cardHeadHeight
                    self.revealedIndex -= 1
                }
            }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////                                  Private                                       //////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Private Variables
    private var component = HFCardCollectionViewModel()
    // MARK: Private calculated Variable
    private var contentInset: UIEdgeInsets {
        if #available(iOS 11, *) {
            return self.collectionView!.adjustedContentInset
        } else {
            return self.collectionView!.contentInset
        }
    }
    private var contentOffsetTop: CGFloat {
        return self.collectionView!.contentOffset.y + self.contentInset.top
    }
    private var bottomCardCount: CGFloat {
        return CGFloat(min(self.component.cvItemCount,
                           min(self.bottomNumberOfStackedCards, self.component.cdCollBottomCardsSet.count)))
    }
    private var contentInsetBottom: CGFloat {
        if self.component.cvIgnoreBottomContentOffsetChanges == true {
            return self.component.cvLastBottomContentOffset
        }
        self.component.cvLastBottomContentOffset = self.contentInset.bottom
        return self.contentInset.bottom
    }
    private var scalePerCard: CGFloat {
        let maximumScale = self.bottomStackedCardsMaximumScale
        let minimumScale = (maximumScale <
            self.bottomStackedCardsMinimumScale) ? maximumScale: self.bottomStackedCardsMinimumScale
        return (maximumScale - minimumScale) / CGFloat(self.bottomNumberOfStackedCards)
    }
    // MARK: Initialize HFCardCollectionViewLayout
    internal func installMoveCardsGestureRecognizer() {
        self.component.mvCdGestureRecognizer = UILongPressGestureRecognizer(target:
            self, action: #selector(self.movingCardGestureHandler))
        self.component.mvCdGestureRecognizer?.minimumPressDuration = 0.49
        self.component.mvCdGestureRecognizer?.delegate = self
        self.collectionView?.addGestureRecognizer(self.component.mvCdGestureRecognizer!)
    }
    private func initializeCardCollectionViewLayout() {
        self.component.cvIsInitialized = true
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardDidHide(_:)),
                                               name: UIResponder.keyboardDidHideNotification, object: nil)
        self.component.cvTapGestureRecognizer = UITapGestureRecognizer(target:
            self, action: #selector(self.collectionViewTapGestureHandler))
        self.component.cvTapGestureRecognizer?.delegate = self
        self.collectionView?.addGestureRecognizer(self.component.cvTapGestureRecognizer!)
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        self.component.cvIgnoreBottomContentOffsetChanges = true
    }
    @objc func keyboardDidHide(_ notification: Notification) {
        self.component.cvIgnoreBottomContentOffsetChanges = false
    }
    // MARK: UICollectionViewLayout Overrides
    /// The width and height of the collection view’s contents.
    override open var collectionViewContentSize: CGSize {
        let contentHeight = (self.cardHeadHeight *
            CGFloat(self.component.cvItemCount)) + self.spaceAtTopForBackgroundView + self.spaceAtBottom
        let contentWidth = self.collectionView!.frame.width - (contentInset.left + contentInset.right)
        return CGSize.init(width: contentWidth, height: contentHeight)
    }

    /// Tells the layout object to update the current layout.
    override open func prepare() {
        super.prepare()
        self.component.cvItemCount = self.collectionView!.numberOfItems(inSection: 0)
        self.component.cdCollCellSize = self.generateCellSize()
        if self.component.cvIsInitialized == false {
            self.initializeCardCollectionViewLayout()
        }
        self.component.cdCollViewLayoutAttributes = self.generateCardCollectionViewLayoutAttributes()
    }
    /// A layout attributes object containing the information to apply to the item’s cell.
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.component.cdCollViewLayoutAttributes[indexPath.item]
    }
    /// An array of UICollectionViewLayoutAttributes objects representing the layout
    /// information for the cells and views. The default implementation returns nil.
    ///
    /// - Parameter rect: The rectangle
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes =  self.component.cdCollViewLayoutAttributes.filter { (layout) -> Bool in
            return (layout.frame.intersects(rect))
        }
        return attributes
    }
    /// true if the collection view requires a layout update or false if the layout does not need to change.
    ///
    /// - Parameter newBounds: The new bounds of the collection view.
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    /// The content offset that you want to use instead.
    ///
    /// - Parameter proposedContentOffset: The proposed point (in the collection
    /// view’s content view) at which to stop scrolling. This is the value at which
    /// scrolling would naturally stop if no adjustments were made. The point reflects the
    /// upper-left corner of the visible content.
    /// - Parameter velocity: The current scrolling velocity along both the
    /// horizontal and vertical axes. This value is measured in points per second.
    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                           withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let proposedContentOffsetY = proposedContentOffset.y + self.contentInset.top
        if self.spaceAtTopShouldSnap == true && self.spaceAtTopForBackgroundView > 0 {
            if proposedContentOffsetY > 0 && proposedContentOffsetY < self.spaceAtTopForBackgroundView {
                let scrollToTopY = self.spaceAtTopForBackgroundView * 0.5
                if proposedContentOffsetY < scrollToTopY {
                    return CGPoint(x: 0, y: 0 - self.contentInset.top)
                } else {
                    return CGPoint(x: 0, y: self.spaceAtTopForBackgroundView - self.contentInset.top)
                }
            }
        }
        if self.scrollShouldSnapCardHead == true && proposedContentOffsetY >
            self.spaceAtTopForBackgroundView && self.collectionView!.contentSize.height >
            self.collectionView!.frame.height + self.cardHeadHeight {
            let startIndex = Int((proposedContentOffsetY -
                self.spaceAtTopForBackgroundView) / self.cardHeadHeight) + 1
            let positionToGoUp = self.cardHeadHeight * 0.5
            let cardHeadPosition = (proposedContentOffsetY -
                self.spaceAtTopForBackgroundView).truncatingRemainder(dividingBy: self.cardHeadHeight)
            if cardHeadPosition > positionToGoUp {
                let targetY = (CGFloat(startIndex) * self.cardHeadHeight) +
                    (self.spaceAtTopForBackgroundView - self.contentInset.top)
                return CGPoint(x: 0, y: targetY)
            } else {
                let targetY = (CGFloat(startIndex) * self.cardHeadHeight) -
                    self.cardHeadHeight + (self.spaceAtTopForBackgroundView - self.contentInset.top)
                return CGPoint(x: 0, y: targetY)
            }
        }
        return proposedContentOffset
    }
    /// This method is called when there is an update with deletes to the collection view.
    override open func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        self.component.cvDeletedIndexPaths.removeAll(keepingCapacity: false)
        for update in updateItems {
            switch update.updateAction {
            case .delete:
                self.component.cvDeletedIndexPaths.append(update.indexPathBeforeUpdate!)
            default:
                return
            }
        }
    }
    /// Custom animation for deleting cells.
    override open func finalLayoutAttributesForDisappearingItem(at
        itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        if self.component.cvDeletedIndexPaths.contains(itemIndexPath) {
            if let attrs = attrs {
                attrs.alpha = 0.0
                attrs.transform3D = CATransform3DScale(attrs.transform3D, 0.001, 0.001, 1)
            }
        }
        return attrs
    }
    /// Remove deleted indexPaths
    override open func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        self.component.cvDeletedIndexPaths.removeAll(keepingCapacity: false)
    }
    // MARK: Private Functions for UICollectionViewLayout
    @objc internal func collectionViewTapGestureHandler() {
        if let tapLocation = self.component.cvTapGestureRecognizer?.location(in: self.collectionView) {
            if let indexPath = self.collectionView?.indexPathForItem(at: tapLocation) {
                self.collectionView?.delegate?.collectionView?(self.collectionView!, didSelectItemAt: indexPath)
            }
        }
    }
    private func generateCellSize() -> CGSize {
        let width = self.collectionView!.frame.width - (self.contentInset.left + self.contentInset.right)
        let maxHeight = self.collectionView!.frame.height -
            (self.bottomCardLookoutMargin *
                CGFloat(self.bottomNumberOfStackedCards)) - (self.contentInset.top + self.contentInsetBottom) - 2
        let height = (self.cardMaximumHeight == 0 || self.cardMaximumHeight >
            maxHeight) ? maxHeight: self.cardMaximumHeight
        let size = CGSize.init(width: width, height: height)
        return size
    }
    private func generateCardCollectionViewLayoutAttributes() -> [HFCardCollectionViewLayoutAttributes] {
        var cardCollectionViewLayoutAttributes: [HFCardCollectionViewLayoutAttributes] = []
        var shouldReloadAllItems = false
        if self.component.cdCollViewLayoutAttributes != nil &&
            self.component.cvItemCount == self.component.cdCollViewLayoutAttributes.count {
            cardCollectionViewLayoutAttributes = self.component.cdCollViewLayoutAttributes
        } else {
            shouldReloadAllItems = true
        }
        var startIndex = Int((self.collectionView!.contentOffset.y +
            self.contentInset.top - self.spaceAtTopForBackgroundView + self.component.cvTemporaryTop) /
            self.cardHeadHeight) - 10
        var endBeforeIndex = Int((self.collectionView!.contentOffset.y +
            self.collectionView!.frame.size.height + self.component.cvTemporaryTop) / self.cardHeadHeight) + 5
        if startIndex < 0 {
            startIndex = 0
        }
        if endBeforeIndex > self.component.cvItemCount {
            endBeforeIndex = self.component.cvItemCount
        }
        if shouldReloadAllItems == true {
            startIndex = 0
            endBeforeIndex = self.component.cvItemCount
        }
        self.component.cdCollBottomCardsSet = self.generateBottomIndexes()
        var bottomIndex: CGFloat = 0
        for itemIndex in startIndex..<endBeforeIndex {
            let indexPath = IndexPath(item: itemIndex, section: 0)
            let cardLayoutAttribute = HFCardCollectionViewLayoutAttributes.init(forCellWith: indexPath)
            cardLayoutAttribute.zIndex = itemIndex
            if self.revealedIndex < 0 && self.collapseAllCards == false {
                self.collectionView!.contentOffset.y += self.component.cvTemporaryTop
                self.component.cvTemporaryTop = 0
                self.generateNonRevealedCardsAttribute(cardLayoutAttribute)
            } else if self.revealedIndex == itemIndex && self.collapseAllCards == false {
                self.generateRevealedCardAttribute(cardLayoutAttribute)
            } else {
                self.generateBottomCardsAttribute(cardLayoutAttribute, bottomIndex: &bottomIndex)
            }
            if itemIndex < cardCollectionViewLayoutAttributes.count {
                cardCollectionViewLayoutAttributes[itemIndex] = cardLayoutAttribute
            } else {
                cardCollectionViewLayoutAttributes.append(cardLayoutAttribute)
            }
        }
        return cardCollectionViewLayoutAttributes
    }
    private func generateBottomIndexes() -> [Int] {
        if self.revealedIndex < 0 {
            if self.collapseAllCards == false {
                return []
            } else {
                let startIndex: Int = Int((self.contentOffsetTop + self.component.cvTemporaryTop)
                    / self.cardHeadHeight)
                let endIndex = max(0, startIndex + self.bottomNumberOfStackedCards - 2)
                return Array(startIndex...endIndex)
            }
        }
        let half = Int(self.bottomNumberOfStackedCards / 2)
        var minIndex = self.revealedIndex - half
        var maxIndex = self.revealedIndex + half
        if minIndex < 0 {
            minIndex = 0
            maxIndex = self.revealedIndex + half + abs(self.revealedIndex - half)
        } else if maxIndex >= self.component.cvItemCount {
            minIndex = (self.component.cvItemCount - 2 * half) - 1
            maxIndex = self.component.cvItemCount - 1
        }
        self.component.cdCollBottomCardsRevealedIndex = 0
        return Array(minIndex...maxIndex).filter({ (value) -> Bool in
            if value >= 0 && value != self.revealedIndex {
                if value < self.revealedIndex {
                    self.component.cdCollBottomCardsRevealedIndex += 1
                }
                return true
            }
            return false
        })
    }
    private func generateNonRevealedCardsAttribute(_ attribute: HFCardCollectionViewLayoutAttributes) {
        let cardHeadHeight = self.calculateCardHeadHeight()
        let startIndex = Int((self.contentOffsetTop + self.component.cvTemporaryTop -
            self.spaceAtTopForBackgroundView) / cardHeadHeight)
        let currentIndex = attribute.indexPath.item
        if currentIndex == self.component.mvCdSelectedIndex {
            attribute.alpha = 0.0
        } else {
            attribute.alpha = 1.0
        }
        let currentFrame = CGRect(x: 0, y: self.spaceAtTopForBackgroundView +
            cardHeadHeight * CGFloat(currentIndex),
                                  width: self.component.cdCollCellSize.width,
                                  height: self.component.cdCollCellSize.height)
        if self.contentOffsetTop >= 0 && self.contentOffsetTop <= self.spaceAtTopForBackgroundView {
            attribute.frame = currentFrame
        } else if self.contentOffsetTop > self.spaceAtTopForBackgroundView {
            attribute.isHidden = (self.scrollStopCardsAtTop == true && currentIndex < startIndex)
            if self.component.mvCdSelectedIndex >= 0 && currentIndex + 1 == self.component.mvCdSelectedIndex {
                attribute.isHidden = false
            }
            if self.scrollStopCardsAtTop == true && ((currentIndex != 0 &&
                currentIndex <= startIndex) || (currentIndex == 0 && (self.contentOffsetTop -
                    self.spaceAtTopForBackgroundView) > 0)) {
                var newFrame = currentFrame
                newFrame.origin.y = self.contentOffsetTop
                attribute.frame = newFrame
            } else {
                attribute.frame = currentFrame
            }
            if attribute.isHidden == true && currentIndex < startIndex - 5 {
                attribute.frame = currentFrame
                attribute.frame.origin.y = self.collectionView!.frame.height * -1.5
            }
        } else {
            if self.cardShouldStretchAtScrollTop == true {
                let stretchMultiplier: CGFloat = (1 + (CGFloat(currentIndex + 1) * -0.2))
                var newFrame = currentFrame
                newFrame.origin.y += CGFloat(self.contentOffsetTop * stretchMultiplier)
                attribute.frame = newFrame
            } else {
                attribute.frame = currentFrame
            }
        }
        attribute.isRevealed = false
    }
    private func generateRevealedCardAttribute(_ attribute: HFCardCollectionViewLayoutAttributes) {
        attribute.isRevealed = true
        if self.component.cvItemCount == 1 {
            attribute.frame = CGRect.init(x: 0, y: self.contentOffsetTop +
                self.spaceAtTopForBackgroundView + 0.01,
                                          width: self.component.cdCollCellSize.width,
                                          height: self.component.cdCollCellSize.height)
        } else {
            attribute.frame = CGRect.init(x: 0, y: self.contentOffsetTop +
                0.01, width: self.component.cdCollCellSize.width, height: self.component.cdCollCellSize.height)
        }
    }
    private func generateBottomCardsAttribute(_ attribute: HFCardCollectionViewLayoutAttributes,
                                              bottomIndex:inout CGFloat) {
        let index = attribute.indexPath.item
        let posY = self.cardHeadHeight * CGFloat(index)
        let currentFrame = CGRect(x: self.collectionView!.frame.origin.x,
                                  y: posY, width: self.component.cdCollCellSize.width,
                                  height: self.component.cdCollCellSize.height)
        let maxY = self.collectionView!.contentOffset.y +
            self.collectionView!.frame.height
        let contentFrame = CGRect(x: 0, y: self.collectionView!.contentOffset.y,
                                  width: self.collectionView!.frame.width, height: maxY)
        if self.component.cdCollBottomCardsSet.contains(index) {
            let margin: CGFloat = self.bottomCardLookoutMargin
            let baseHeight = (self.collectionView!.frame.height +
                self.collectionView!.contentOffset.y) -
                self.contentInsetBottom - (margin * self.bottomCardCount)
            let scale: CGFloat = self.calculateCardScale(forIndex: bottomIndex)
            let yAddition: CGFloat = (self.component.cdCollCellSize.height -
                (self.component.cdCollCellSize.height * scale)) / 2
            let yPos: CGFloat = baseHeight +
                (bottomIndex * margin) - yAddition
            attribute.frame = CGRect.init(x: 0, y: yPos, width:
                self.component.cdCollCellSize.width, height: self.component.cdCollCellSize.height)
            attribute.transform = CGAffineTransform(scaleX: scale, y: scale)
            bottomIndex += 1
        } else if contentFrame.intersects(currentFrame) {
            attribute.isHidden = true
            attribute.alpha = 0.0
            attribute.frame = CGRect.init(x: 0, y: maxY,
                                          width: self.component.cdCollCellSize.width,
                                          height: self.component.cdCollCellSize.height)
        } else {
            attribute.isHidden = true
            attribute.alpha = 0.0
            attribute.frame = CGRect(x: 0, y: posY,
                                     width: self.component.cdCollCellSize.width,
                                     height: self.component.cdCollCellSize.height)
        }
        attribute.isRevealed = false
    }
    private func calculateCardScale(forIndex index: CGFloat, scaleBehindCard: Bool = false) -> CGFloat {
        if self.bottomStackedCardsShouldScale == true {
            let scalePerCard = self.scalePerCard
            let addedDownScale: CGFloat = (scaleBehindCard == true && index < self.bottomCardCount) ? scalePerCard: 0.0
            return min(1.0, self.bottomStackedCardsMaximumScale -
                (((index + 1 - self.bottomCardCount) * -1) * scalePerCard) - addedDownScale)
        }
        return 1.0
    }
    private func calculateCardHeadHeight() -> CGFloat {
        var cardHeadHeight = self.cardHeadHeight
        if self.cardShouldExpandHeadHeight == true {
            cardHeadHeight = max(self.cardHeadHeight, (self.collectionView!.frame.height -
                (self.contentInset.top +
                    self.contentInsetBottom +
                    self.spaceAtTopForBackgroundView)) /
                CGFloat(self.component.cvItemCount))
        }
        return cardHeadHeight
    }
    // MARK: Revealed Card
    private func initializeRevealedCard() -> Bool {
        if let cell = self.collectionView?.cellForItem(at: IndexPath(item: self.revealedIndex, section: 0)) {
            self.component.rvldCdCell = cell
            self.component.rvldCdPanGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                                     action:
                #selector(self.revealedCardPanGestureHandler))
            self.component.rvldCdPanGestureRecognizer?.delegate = self
            self.component.rvldCdCell?.addGestureRecognizer(self.component.rvldCdPanGestureRecognizer!)
            return true
        }
        return false
    }
    private func deinitializeRevealedCard() {
        if self.component.rvldCdCell != nil && self.component.rvldCdPanGestureRecognizer != nil {
            self.component.rvldCdCell?.removeGestureRecognizer(self.component.rvldCdPanGestureRecognizer!)
            self.component.rvldCdPanGestureRecognizer = nil
            self.component.rvldCdCell = nil
        }
    }
    @objc internal func revealedCardPanGestureHandler() {
        if self.component.cvItemCount == 1 || self.component.rvldCdIsFlipped == true {
            return
        }
        if let revealedCardPanGestureRecognizer = self.component.rvldCdPanGestureRecognizer,
            self.component.rvldCdCell != nil {
            let gstrTouchLocation = revealedCardPanGestureRecognizer.location(in: self.collectionView)
            let shiftY: CGFloat = (gstrTouchLocation.y -
                self.component.rvldCdPanGestureTouchLocationY  >
                0) ? gstrTouchLocation.y - self.component.rvldCdPanGestureTouchLocationY: 0
            switch revealedCardPanGestureRecognizer.state {
            case .began:
                UIApplication.shared.keyWindow?.endEditing(true)
                self.component.rvldCdPanGestureTouchLocationY = gstrTouchLocation.y
            case .changed:
                let scaleTarget = self.calculateCardScale(forIndex:
                    self.component.cdCollBottomCardsRevealedIndex, scaleBehindCard: true)
                let scaleDiff: CGFloat = 1.0 - scaleTarget
                let scale: CGFloat = 1.0 - min(((shiftY * scaleDiff) /
                    (self.collectionView!.frame.height / 2)), scaleDiff)
                let transformY = CGAffineTransform.init(translationX: 0, y: shiftY)
                let transformScale = CGAffineTransform.init(scaleX: scale, y: scale)
                self.component.rvldCdCell?.transform = transformY.concatenating(transformScale)
            default:
                let isNeedReload = (shiftY > self.component.rvldCdCell!.frame.height / 7) ? true: false
                let resetY = (isNeedReload) ? self.collectionView!.frame.height: 0
                let scale: CGFloat = (isNeedReload) ?
                    self.calculateCardScale(forIndex:
                        self.component.cdCollBottomCardsRevealedIndex, scaleBehindCard: true): 1.0
                let transformScale = CGAffineTransform.init(scaleX: scale, y: scale)
                let transformY = CGAffineTransform.init(translationX: 0, y: resetY * (1.0 + (1.0 - scale)))
                UIView.animate(withDuration: 0.3, animations: {
                    self.component.rvldCdCell?.transform = transformY.concatenating(transformScale)
                }, completion: { (finished) in
                    if isNeedReload && finished {
                        self.revealCardAt(index: self.revealedIndex)
                    }
                })
            }
        }
    }
    // MARK: Moving Card
    @objc internal func movingCardGestureHandler() {
        if let movingCardGestureRecognizer = self.component.mvCdGestureRecognizer {
            switch movingCardGestureRecognizer.state {
            case .began:
                self.component.mvCdGestureStartLocation =
                    movingCardGestureRecognizer.location(in: self.collectionView)
                if let indexPath = self.collectionView?.indexPathForItem(at:
                    self.component.mvCdGestureStartLocation) {
                    self.gestureBegan(at: indexPath)
                } else {
                    self.component.mvCdActive = false
                }
            case .changed:
                if self.component.mvCdActive == true {
                    self.component.mvCdGestureCurrentLocation =
                        movingCardGestureRecognizer.location(in: self.collectionView)
                    self.gestureChangedPrepare()
                }
            case .ended:
                self.invalidateScrollTimer()
                if self.component.mvCdActive == true {
                    var indexPath = self.component.mvCdStartIndexPath!
                    if self.component.mvCdLastTouchedIndexPath != nil {
                        indexPath = self.component.mvCdLastTouchedIndexPath!
                    }
                    if let cell = self.collectionView?.cellForItem(at: indexPath) {
                        self.gestureEnded(with: cell, at: indexPath)
                    } else {
                        fallthrough
                    }
                }
            case .cancelled:
                self.gestureCancelled()
            default:
                break
            }
        }
    }
    /// Mark: Internal gesture functions
    internal func gestureBegan(at indexPath: IndexPath) {
        self.component.mvCdActive = true
        if indexPath.item < self.firstMovableIndex {
            self.component.mvCdActive = false
            return
        }
        if let cell = self.collectionView?.cellForItem(at: indexPath) {
            self.component.mvCdStartIndexPath = indexPath
            self.component.mvCdCenterStart = cell.center
            self.component.mvCdSnapshotCell = cell.snapshotView(afterScreenUpdates: false)
            self.component.mvCdSnapshotCell?.frame = cell.frame
            self.component.mvCdSnapshotCell?.alpha = 1.0
            self.component.mvCdSnapshotCell?.layer.zPosition = cell.layer.zPosition
            self.collectionView?.insertSubview(self.component.mvCdSnapshotCell!, aboveSubview: cell)
            cell.alpha = 0.0
            self.component.mvCdSelectedIndex = indexPath.item
            UIView.animate(withDuration: 0.2, animations: {
                self.component.mvCdSnapshotCell?.frame.origin.y -= self.component.moveUpOffset
            })
        }
    }

    internal func gestureChangedPrepare() {
        var currentCenter = self.component.mvCdCenterStart
        currentCenter.y += (self.component.mvCdGestureCurrentLocation.y -
            self.component.mvCdGestureStartLocation.y - self.component.moveUpOffset)
        self.component.mvCdSnapshotCell?.center = currentCenter
        if self.component.mvCdGestureCurrentLocation.y >
            ((self.collectionView!.contentOffset.y +
                self.collectionView!.frame.height) -
                self.spaceAtBottom - self.contentInsetBottom -
                self.scrollAreaBottom) {
            self.setupScrollTimer(direction: .down)
        } else if (self.component.mvCdGestureCurrentLocation.y -
            self.collectionView!.contentOffset.y) - self.contentInset.top < self.scrollAreaTop {
            self.setupScrollTimer(direction: .upwards)
        } else {
            self.invalidateScrollTimer()
        }
        var tempIndexPath = self.collectionView?.indexPathForItem(at:
            self.component.mvCdGestureCurrentLocation)
        if tempIndexPath == nil {
            tempIndexPath = self.collectionView?.indexPathForItem(at:
                self.component.mvCdLastTouchedLocation)
        }
        if let currentTouchedIndexPath = tempIndexPath {
            self.gestureChanged(at: currentTouchedIndexPath)
        }
    }

    internal func gestureChanged(at indexPath: IndexPath) {
        self.component.mvCdLastTouchedLocation = self.component.mvCdGestureCurrentLocation
        if indexPath.item < self.firstMovableIndex {
            return
        }
        if self.component.mvCdLastTouchedIndexPath ==
            nil && indexPath != self.component.mvCdStartIndexPath! {
            self.component.mvCdLastTouchedIndexPath = self.component.mvCdStartIndexPath
        }
        if self.self.component.mvCdLastTouchedIndexPath != nil &&
            self.component.mvCdLastTouchedIndexPath! != indexPath {
            let movingCell = self.collectionView?.cellForItem(at: indexPath)
            let movingCellAttr =
                self.collectionView?.layoutAttributesForItem(at: indexPath)
            if movingCell != nil {
                let cardHeadHeight = self.calculateCardHeadHeight()
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                    movingCell?.frame.origin.y -= cardHeadHeight
                }, completion: {(_) in
                    movingCellAttr?.frame.origin.y -= cardHeadHeight
                })
            }
            self.component.mvCdSelectedIndex = indexPath.item
            self.collectionView?.dataSource?.collectionView?(
                self.collectionView!,
                moveItemAt: indexPath, to: self.component.mvCdLastTouchedIndexPath!)
            UIView.performWithoutAnimation {
                self.collectionView?.moveItem(at:
                    indexPath, to: self.component.mvCdLastTouchedIndexPath!)
            }
            self.component.mvCdLastTouchedIndexPath = indexPath
            if let belowCell = self.collectionView?.cellForItem(at: indexPath) {
                self.component.mvCdSnapshotCell?.removeFromSuperview()
                self.collectionView?.insertSubview(self.component.mvCdSnapshotCell!,
                                                   belowSubview: belowCell)
                self.component.mvCdSnapshotCell?.layer.zPosition = belowCell.layer.zPosition
            } else {
                self.collectionView?.sendSubviewToBack(self.component.mvCdSnapshotCell!)
            }
        }
    }

    internal func gestureEnded(with cell: UICollectionViewCell, at indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2, animations: {
            self.component.mvCdSnapshotCell?.frame = cell.frame
        }, completion: {(_) in
            self.component.mvCdActive = false
            self.component.mvCdLastTouchedIndexPath = nil
            self.component.mvCdSelectedIndex = -1
            self.collectionView?.reloadData()
            self.component.mvCdSnapshotCell?.removeFromSuperview()
            self.component.mvCdSnapshotCell = nil
            if self.component.mvCdStartIndexPath == indexPath {
                UIView.animate(withDuration: 0, animations: {
                    self.invalidateLayout()
                })
            }
        })
    }

    internal func gestureCancelled() {
        self.component.mvCdActive = false
        self.component.mvCdLastTouchedIndexPath = nil
        self.component.mvCdSelectedIndex = -1
        self.collectionView?.reloadData()
        self.component.mvCdSnapshotCell?.removeFromSuperview()
        self.component.mvCdSnapshotCell = nil
        self.invalidateLayout()
    }

    private func setupScrollTimer(direction: HFCardCollectionScrollDirection) {
        if self.component.autoscrollDisplayLink != nil && self.component.autoscrollDisplayLink!.isPaused == false {
            if direction == self.component.autoscrollDirection {
                return
            }
        }
        self.invalidateScrollTimer()
        self.component.autoscrollDisplayLink = CADisplayLink(target: self,
                                                   selector: #selector(self.autoscrollHandler(displayLink:)))
        self.component.autoscrollDirection = direction
        self.component.autoscrollDisplayLink?.add(to: .main, forMode: RunLoop.Mode.common)
    }
    private func invalidateScrollTimer() {
        if self.component.autoscrollDisplayLink != nil && self.component.autoscrollDisplayLink!.isPaused == false {
            self.component.autoscrollDisplayLink?.invalidate()
        }
        self.component.autoscrollDisplayLink = nil
    }
    @objc internal func autoscrollHandler(displayLink: CADisplayLink) {
        let direction = self.component.autoscrollDirection
        if direction == .unknown {
            return
        }
        let scrollMultiplier = self.generateScrollSpeedMultiplier()
        let frameSize = self.collectionView!.frame.size
        let contentSize = self.collectionView!.contentSize
        let contentOffset = self.collectionView!.contentOffset
        let contentInset = self.contentInset
        var distance: CGFloat = CGFloat(rint(scrollMultiplier * displayLink.duration))
        var translation = CGPoint.zero
        switch direction {
        case .upwards:
            distance = -distance
            let minY: CGFloat = 0.0 - contentInset.top
            if (contentOffset.y + distance) <= minY {
                distance = -contentOffset.y - contentInset.top
            }
            translation = CGPoint(x: 0.0, y: distance)
        case .down:
            let maxY: CGFloat = max(contentSize.height, frameSize.height) - frameSize.height + self.contentInsetBottom
            if (contentOffset.y + distance) >= maxY {
                distance = maxY - contentOffset.y
            }
            translation = CGPoint(x: 0.0, y: distance)
        default:
            break
        }
        self.collectionView!.contentOffset = self.cgPointAdd(contentOffset, translation)
        self.movingCardGestureHandler()
    }
    private func generateScrollSpeedMultiplier() -> Double {
        var multiplier: Double = 250.0
        if let movingCardGestureRecognizer = self.component.mvCdGestureRecognizer {
            let touchLocation = movingCardGestureRecognizer.location(in: self.collectionView)
            let maxSpeed: CGFloat = 600
            if self.component.autoscrollDirection == .upwards {
                let touchPosY = min(max(0, self.scrollAreaTop -
                    (touchLocation.y - self.contentOffsetTop)), self.scrollAreaTop)
                multiplier = Double(maxSpeed * (touchPosY / self.scrollAreaTop))
            } else if self.component.autoscrollDirection == .down {
                let offsetTop = ((self.collectionView!.contentOffset.y +
                    self.collectionView!.frame.height) -
                    self.spaceAtBottom - self.contentInsetBottom - self.scrollAreaBottom)
                let touchPosY = min(max(0, (touchLocation.y - offsetTop)), self.scrollAreaBottom)
                multiplier = Double(maxSpeed * (touchPosY / self.scrollAreaBottom))
            }
        }
        return multiplier
    }
    private func cgPointAdd(_ point1: CGPoint, _ point2: CGPoint) -> CGPoint {
        return CGPoint(x: point1.x + point2.x, y: point1.y + point2.y)
    }
    // MARK: UIGestureRecognizerDelegate
    /// Return true no card is revealed.
    ///
    /// - Parameter gestureRecognizer: The gesture recognizer.
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.component.mvCdGestureRecognizer ||
            gestureRecognizer == self.component.cvTapGestureRecognizer {
            if self.revealedIndex >= 0 {
                return false
            }
        }
        if gestureRecognizer == self.component.rvldCdPanGestureRecognizer {
            let velocity =  self.component.rvldCdPanGestureRecognizer?.velocity(in:
                self.component.rvldCdPanGestureRecognizer?.view)
            let result = abs(velocity!.y) > abs(velocity!.x)
            return result
        }
        return true
    }
}
