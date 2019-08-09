//
//  HFCardCollectionViewLayout.swift
//  HFCardCollectionViewLayout
//
//  Created by Hendrik Frahmann on 02.11.16.
//  Copyright © 2016 Hendrik Frahmann. All rights reserved.
//

import UIKit

/// Layout attributes for the HFCardCollectionViewLayout
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
                var previousRevealedIndex = -1
                let collectionViewLayoutDelegate = self.collectionView?.delegate as? HFCardCollectionViewLayoutDelegate
                if self.revealedIndex >= 0 {
                    previousRevealedIndex = self.revealedIndex
                    collectionViewLayoutDelegate?.cardCollectionViewLayout?(self,
                                                                            willUnrevealCardAtIndex: self.revealedIndex)
                    self.revealedIndex = -1
                }
                self.collectionView?.performBatchUpdates({ self.collectionView?.reloadData() },
                                                         completion: {(_) in
                    if previousRevealedIndex >= 0 {
                        collectionViewLayoutDelegate?.cardCollectionViewLayout?(self,
                                                                                didUnrevealCardAtIndex:
                            previousRevealedIndex)
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
            (self.revealedIndex >= 0 && index < 0)) && self.rvldCardIsFlipped == true {
            // do nothing, because the card is flipped
        } else if self.revealedIndex >= 0 && index >= 0 {
            if self.collectionViewForceUnreveal == false {
                if collectionViewLayoutDelegate?.cardCollectionViewLayout?(self,
                            canUnrevealCardAtIndex: self.revealedIndex) == false {
                    return
                }
            }
            self.collectionViewForceUnreveal = false
            if self.rvldCardIsFlipped == true {
                self.flipRevealedCardBack(completion: {
                    self.collectionView?.isScrollEnabled = true
                    self.deinitializeRevealedCard()
                    collectionViewLayoutDelegate?.cardCollectionViewLayout?(self,
                                                                            willUnrevealCardAtIndex: self.revealedIndex)
                    self.revealedIndex = -1
                    self.collectionView?.performBatchUpdates({ self.collectionView?.reloadData() },
                                                             completion: { (_) in
                        collectionViewLayoutDelegate?.cardCollectionViewLayout?(self,
                                            didUnrevealCardAtIndex: oldRevealedIndex)
                        completion?()
                    })
                })
            } else {
                self.collectionView?.isScrollEnabled = true
                self.deinitializeRevealedCard()
                collectionViewLayoutDelegate?.cardCollectionViewLayout?(self,
                                                                        willUnrevealCardAtIndex: self.revealedIndex)
                self.revealedIndex = -1
                self.collectionView?.performBatchUpdates({ self.collectionView?.reloadData() },
                                                         completion: { (_) in
                    collectionViewLayoutDelegate?.cardCollectionViewLayout?(self,
                                                                            didUnrevealCardAtIndex: oldRevealedIndex)
                    completion?()
                })
            }
        } else {
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

                self.collectionView?.performBatchUpdates({ self.collectionView?.reloadData() },
                                                         completion: { (_) in
                    collectionViewLayoutDelegate?.cardCollectionViewLayout?(self,
                                                                            didRevealCardAtIndex: self.revealedIndex)
                    completion?()
                })
            } else if self.revealedIndex >= 0 {
                self.revealedIndex = index
                self.collectionView?.isScrollEnabled = false
                self.collectionView?.performBatchUpdates({ self.collectionView?.reloadData() },
                                                         completion: { (_) in
                    collectionViewLayoutDelegate?.cardCollectionViewLayout?(self,
                                                                            didUnrevealCardAtIndex: oldRevealedIndex)
                    completion?()
                })
            }
            self.revealedIndex = index
        }
    }

    /// Unreveal the revealed card
    ///
    /// - Parameter completion: An optional completion block. Will be executed the animation is finished.
    open func unrevealCard(completion: (() -> Void)? = nil) {
        if self.revealedIndex == -1 {
            completion?()
        } else if self.rvldCardIsFlipped == true {
            self.flipRevealedCardBack(completion: {
                self.collectionViewForceUnreveal = true
                self.revealCardAt(index: self.revealedIndex, completion: completion)
            })
        } else {
            self.collectionViewForceUnreveal = true
            self.revealCardAt(index: self.revealedIndex, completion: completion)
        }
    }

    /// Flips the revealed card to the given view.
    /// The frame for the view will be the same as the cell
    ///
    /// - Parameter toView: The view for the backview of te card.
    /// - Parameter completion: An optional completion block. Will be executed the animation is finished.
    open func flipRevealedCard(toView: UIView, completion: (() -> Void)? = nil) {
        if self.rvldCardIsFlipped == true {
            return
        }
        if let cardCell = self.revealedCardCell, self.revealedIndex >= 0 {
            toView.removeFromSuperview()
            self.rvldCardFlipView = toView
            toView.frame = CGRect(x: 0, y: 0, width: cardCell.frame.width, height: cardCell.frame.height)
            toView.isHidden = true
            cardCell.addSubview(toView)

            self.rvldCardIsFlipped = true
            UIApplication.shared.keyWindow?.endEditing(true)
            let originalShouldRasterize = cardCell.layer.shouldRasterize
            cardCell.layer.shouldRasterize = false
            UIView.transition(with: cardCell, duration: 0.5, options: [.transitionFlipFromRight],
                              animations: { () -> Void in
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
        if self.rvldCardIsFlipped == false {
            completion?()
            return
        }
        if let cardCell = self.revealedCardCell {
            if let flipView = self.rvldCardFlipView {
                let originalShouldRasterize = cardCell.layer.shouldRasterize
                UIApplication.shared.keyWindow?.endEditing(true)
                cardCell.layer.shouldRasterize = false

                UIView.transition(with: cardCell, duration: 0.5,
                                  options: [.transitionFlipFromLeft], animations: { () -> Void in
                    flipView.isHidden = true
                    cardCell.contentView.isHidden = false
                }, completion: { (_) -> Void in
                    flipView.removeFromSuperview()
                    cardCell.layer.shouldRasterize = originalShouldRasterize
                    self.rvldCardFlipView = nil
                    self.rvldCardIsFlipped = false
                    completion?()
                })
            }
        }
    }

    open func willInsert(indexPaths: [IndexPath]) {
        for indexPath in indexPaths where
             indexPath.section == 0 && indexPath.item <= self.revealedIndex {
                    collectionViewTemporaryTop += self.cardHeadHeight
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
                    collectionViewTemporaryTop -= self.cardHeadHeight
                    self.revealedIndex -= 1
                }
            }
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////                                  Private                                       //////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////

    // MARK: Private Variables

    private var collectionViewIsInitialized = false
    private var collectionViewItemCount: Int = 0
    private var collectionViewTapGestureRecognizer: UITapGestureRecognizer?
    private var collectionViewIgnoreBtCtOffsetChanges: Bool = false
    private var collectionViewLastBottomContentOffset: CGFloat = 0
    private var collectionViewForceUnreveal: Bool = false
    private var collectionViewDeletedIndexPaths = [IndexPath]()
    private var collectionViewTemporaryTop: CGFloat = 0

    private var cardCollectionBoundsSize: CGSize = .zero
    private var cardCollectionViewLayoutAttributes: [HFCardCollectionViewLayoutAttributes]!
    private var cardCollectionBottomCardsSet: [Int] = []
    private var cardCollectionBottomCardsRevealedIndex: CGFloat = 0
    private var cardCollectionCellSize: CGSize = .zero

    private var revealedCardCell: UICollectionViewCell?
    private var rvldCardPanGestRecognizer: UIPanGestureRecognizer?
    private var rvldCardPanGestureTouchLocationY: CGFloat = 0
    private var rvldCardFlipView: UIView?
    private var rvldCardIsFlipped: Bool = false

    private var mvngCardSelectedIndex: Int = -1
    private var mvngCardGestureRecognizer: UILongPressGestureRecognizer?
    private var mvngCardActive: Bool = false
    private var mvngCardGestureStartLocation: CGPoint = .zero
    private var mvngCardGestureCurrentLocation: CGPoint = .zero
    private var mvngCardCenterStart: CGPoint = .zero
    private var mvngCardSnapshotCell: UIView?
    private var mvngCardLastTouchedLocation: CGPoint = .zero
    private var mvngCardLastTouchedIndexPath: IndexPath?
    private var mvngCardStartIndexPath: IndexPath?

    private var autoscrollDisplayLink: CADisplayLink?
    private var autoscrollDirection: HFCardCollectionScrollDirection = .unknown

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
        return CGFloat(min(self.collectionViewItemCount, min(self.bottomNumberOfStackedCards,
                                                             self.cardCollectionBottomCardsSet.count)))
    }

    private var contentInsetBottom: CGFloat {
        if self.collectionViewIgnoreBtCtOffsetChanges == true {
            return self.collectionViewLastBottomContentOffset
        }
        self.collectionViewLastBottomContentOffset = self.contentInset.bottom
        return self.contentInset.bottom
    }

    private var scalePerCard: CGFloat {
        let maximumScale = self.bottomStackedCardsMaximumScale
        let minimumScale = (maximumScale < self.bottomStackedCardsMinimumScale) ?
            maximumScale: self.bottomStackedCardsMinimumScale
        return (maximumScale - minimumScale) / CGFloat(self.bottomNumberOfStackedCards)
    }

    // MARK: Initialize HFCardCollectionViewLayout

    internal func installMvCardsGestureRecognizer() {
        self.mvngCardGestureRecognizer = UILongPressGestureRecognizer(target: self,
                                                                        action: #selector(self.mvngCardGestureHandler))
        self.mvngCardGestureRecognizer?.minimumPressDuration = 0.49
        self.mvngCardGestureRecognizer?.delegate = self
        self.collectionView?.addGestureRecognizer(self.mvngCardGestureRecognizer!)
    }

    private func initializeCardCollectionViewLayout() {
        self.collectionViewIsInitialized = true

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name:
            UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide(_:)), name:
            UIResponder.keyboardDidHideNotification, object: nil)

        self.collectionViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action:
            #selector(self.collectionViewTapGestureHandler))
        self.collectionViewTapGestureRecognizer?.delegate = self
        self.collectionView?.addGestureRecognizer(self.collectionViewTapGestureRecognizer!)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        self.collectionViewIgnoreBtCtOffsetChanges = true
    }

    @objc func keyboardDidHide(_ notification: Notification) {
        self.collectionViewIgnoreBtCtOffsetChanges = false
    }

    // MARK: UICollectionViewLayout Overrides

    /// The width and height of the collection view’s contents.
    override open var collectionViewContentSize: CGSize {
            let contentHeight = (self.cardHeadHeight * CGFloat(self.collectionViewItemCount)) +
                self.spaceAtTopForBackgroundView + self.spaceAtBottom
            let contentWidth = self.collectionView!.frame.width - (contentInset.left + contentInset.right)
            return CGSize.init(width: contentWidth, height: contentHeight)
    }

    /// Tells the layout object to update the current layout.
    override open func prepare() {
        super.prepare()

        self.collectionViewItemCount = self.collectionView!.numberOfItems(inSection: 0)
        self.cardCollectionCellSize = self.generateCellSize()

        if self.collectionViewIsInitialized == false {
            self.initializeCardCollectionViewLayout()
        }

        self.cardCollectionViewLayoutAttributes = self.generateCardCollectionViewLayoutAttributes()
    }

    /// A layout attributes object containing the information to apply to the item’s cell.
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.cardCollectionViewLayoutAttributes[indexPath.item]
    }

    /// An array of UICollectionViewLayoutAttributes objects representing the
    /// layout information for the cells and views.
    /// The default implementation returns nil.
    ///
    /// - Parameter rect: The rectangle
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes =  self.cardCollectionViewLayoutAttributes.filter { (layout) -> Bool in
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
    /// - Parameter proposedContentOffset: The proposed point (in the collection view’s content view)
    /// at which to stop scrolling. This is the value at which scrolling would naturally stop if no
    /// adjustments were made. The point reflects the upper-left corner of the visible content.
    /// - Parameter velocity: The current scrolling velocity along both the horizontal and vertical axes.
    /// This value is measured in points per second.
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
            self.spaceAtTopForBackgroundView &&
            self.collectionView!.contentSize.height > self.collectionView!.frame.height + self.cardHeadHeight {
            let startIndex = Int((proposedContentOffsetY - self.spaceAtTopForBackgroundView)
                / self.cardHeadHeight) + 1
            let positionToGoUp = self.cardHeadHeight * 0.5
            let cardHeadPosition = (proposedContentOffsetY -
                self.spaceAtTopForBackgroundView).truncatingRemainder(dividingBy: self.cardHeadHeight)
            if cardHeadPosition > positionToGoUp {
                let targetY = (CGFloat(startIndex) * self.cardHeadHeight) +
                    (self.spaceAtTopForBackgroundView - self.contentInset.top)
                return CGPoint(x: 0, y: targetY)
            } else {
                let targetY = (CGFloat(startIndex) * self.cardHeadHeight) -
                    self.cardHeadHeight + (self.spaceAtTopForBackgroundView -
                    self.contentInset.top)
                return CGPoint(x: 0, y: targetY)
            }
        }
        return proposedContentOffset
    }

    /// This method is called when there is an update with deletes to the collection view.
    override open func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)

        collectionViewDeletedIndexPaths.removeAll(keepingCapacity: false)

        for update in updateItems {
            switch update.updateAction {
            case .delete:
                collectionViewDeletedIndexPaths.append(update.indexPathBeforeUpdate!)
            default:
                return
            }
        }
    }

    /// Custom animation for deleting cells.
    override open func finalLayoutAttributesForDisappearingItem(at
        itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)

        if collectionViewDeletedIndexPaths.contains(itemIndexPath) {
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
        collectionViewDeletedIndexPaths.removeAll(keepingCapacity: false)
    }

    // MARK: Private Functions for UICollectionViewLayout

    @objc internal func collectionViewTapGestureHandler() {
        if let tapLocation = self.collectionViewTapGestureRecognizer?.location(in: self.collectionView) {
            if let indexPath = self.collectionView?.indexPathForItem(at: tapLocation) {
                self.collectionView?.delegate?.collectionView?(self.collectionView!, didSelectItemAt: indexPath)
            }
        }
    }

    private func generateCellSize() -> CGSize {
        let width = self.collectionView!.frame.width - (self.contentInset.left + self.contentInset.right)
        let maxHeight = self.collectionView!.frame.height - (self.bottomCardLookoutMargin *
            CGFloat(self.bottomNumberOfStackedCards)) - (self.contentInset.top + self.contentInsetBottom) - 2
        let height = (self.cardMaximumHeight == 0 ||
            self.cardMaximumHeight > maxHeight) ? maxHeight: self.cardMaximumHeight
        let size = CGSize.init(width: width, height: height)
        return size
    }

    private func generateCardCollectionViewLayoutAttributes() -> [HFCardCollectionViewLayoutAttributes] {
        var cardCollectionViewLayoutAttributes: [HFCardCollectionViewLayoutAttributes] = []
        var shouldReloadAllItems = false
        if self.cardCollectionViewLayoutAttributes != nil &&
            self.collectionViewItemCount == self.cardCollectionViewLayoutAttributes.count {
            cardCollectionViewLayoutAttributes = self.cardCollectionViewLayoutAttributes
        } else {
            shouldReloadAllItems = true
        }

        var startIndex = Int((self.collectionView!.contentOffset.y +
            self.contentInset.top - self.spaceAtTopForBackgroundView +
            collectionViewTemporaryTop) / self.cardHeadHeight) - 10
        var endBeforeIndex = Int((self.collectionView!.contentOffset.y +
            self.collectionView!.frame.size.height + collectionViewTemporaryTop) /
            self.cardHeadHeight) + 5

        if startIndex < 0 {
            startIndex = 0
        }
        if endBeforeIndex > self.collectionViewItemCount {
            endBeforeIndex = self.collectionViewItemCount
        }
        if shouldReloadAllItems == true {
            startIndex = 0
            endBeforeIndex = self.collectionViewItemCount
        }

        self.cardCollectionBottomCardsSet = self.generateBottomIndexes()

        var bottomIndex: CGFloat = 0
        for itemIndex in startIndex..<endBeforeIndex {
            let indexPath = IndexPath(item: itemIndex, section: 0)
            let cardLayoutAttribute = HFCardCollectionViewLayoutAttributes.init(forCellWith: indexPath)
            cardLayoutAttribute.zIndex = itemIndex

            if self.revealedIndex < 0 && self.collapseAllCards == false {
                self.collectionView!.contentOffset.y += collectionViewTemporaryTop
                collectionViewTemporaryTop = 0
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
                let startIndex: Int = Int((self.contentOffsetTop + collectionViewTemporaryTop) / self.cardHeadHeight)
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
        } else if maxIndex >= self.collectionViewItemCount {
            minIndex = (self.collectionViewItemCount - 2 * half) - 1
            maxIndex = self.collectionViewItemCount - 1
        }

        self.cardCollectionBottomCardsRevealedIndex = 0

        return Array(minIndex...maxIndex).filter({ (value) -> Bool in
            if value >= 0 && value != self.revealedIndex {
                if value < self.revealedIndex {
                    self.cardCollectionBottomCardsRevealedIndex += 1
                }
                return true
            }
            return false
        })
    }

    private func generateNonRevealedCardsAttribute(_ attribute: HFCardCollectionViewLayoutAttributes) {
        let cardHeadHeight = self.calculateCardHeadHeight()

        let startIndex = Int((self.contentOffsetTop + collectionViewTemporaryTop -
            self.spaceAtTopForBackgroundView) / cardHeadHeight)
        let currentIndex = attribute.indexPath.item
        if currentIndex == self.mvngCardSelectedIndex {
            attribute.alpha = 0.0
        } else {
            attribute.alpha = 1.0
        }

        let currentFrame = CGRect(x: 0, y: self.spaceAtTopForBackgroundView +
            cardHeadHeight * CGFloat(currentIndex), width: self.cardCollectionCellSize.width,
                                                    height: self.cardCollectionCellSize.height)

        if self.contentOffsetTop >= 0 && self.contentOffsetTop <= self.spaceAtTopForBackgroundView {
            attribute.frame = currentFrame
        } else if self.contentOffsetTop > self.spaceAtTopForBackgroundView {
            attribute.isHidden = (self.scrollStopCardsAtTop == true && currentIndex < startIndex)

            if self.mvngCardSelectedIndex >= 0 && currentIndex + 1 == self.mvngCardSelectedIndex {
                attribute.isHidden = false
            }
            if self.scrollStopCardsAtTop == true && ((currentIndex != 0 &&
                currentIndex <= startIndex) || (currentIndex == 0 &&
                    (self.contentOffsetTop - self.spaceAtTopForBackgroundView) > 0)) {
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
        if self.collectionViewItemCount == 1 {
            attribute.frame = CGRect.init(x: 0, y: self.contentOffsetTop +
                self.spaceAtTopForBackgroundView + 0.01, width: self.cardCollectionCellSize.width,
                                                         height: self.cardCollectionCellSize.height)
        } else {
            attribute.frame = CGRect.init(x: 0, y: self.contentOffsetTop + 0.01,
                                          width: self.cardCollectionCellSize.width,
                                          height: self.cardCollectionCellSize.height)
        }
    }

    private func generateBottomCardsAttribute(_ attribute: HFCardCollectionViewLayoutAttributes,
                                              bottomIndex:inout CGFloat) {
        let index = attribute.indexPath.item
        let posY = self.cardHeadHeight * CGFloat(index)
        let currentFrame = CGRect(x: self.collectionView!.frame.origin.x, y:
            posY, width: self.cardCollectionCellSize.width, height: self.cardCollectionCellSize.height)
        let maxY = self.collectionView!.contentOffset.y + self.collectionView!.frame.height
        let contentFrame = CGRect(x: 0, y: self.collectionView!.contentOffset.y,
                                  width: self.collectionView!.frame.width, height: maxY)
        if self.cardCollectionBottomCardsSet.contains(index) {
            let margin: CGFloat = self.bottomCardLookoutMargin
            let baseHeight = (self.collectionView!.frame.height +
                self.collectionView!.contentOffset.y) - self.contentInsetBottom - (margin * self.bottomCardCount)
            let scale: CGFloat = self.calculateCardScale(forIndex: bottomIndex)
            let yAddition: CGFloat = (self.cardCollectionCellSize.height -
                (self.cardCollectionCellSize.height * scale)) / 2
            let yPos: CGFloat = baseHeight + (bottomIndex * margin) - yAddition
            attribute.frame = CGRect.init(x: 0, y: yPos,
                                          width: self.cardCollectionCellSize.width,
                                          height: self.cardCollectionCellSize.height)
            attribute.transform = CGAffineTransform(scaleX: scale, y: scale)
            bottomIndex += 1
        } else if contentFrame.intersects(currentFrame) {
            attribute.isHidden = true
            attribute.alpha = 0.0
            attribute.frame = CGRect.init(x: 0, y: maxY,
                                          width: self.cardCollectionCellSize.width,
                                          height: self.cardCollectionCellSize.height)
        } else {
            attribute.isHidden = true
            attribute.alpha = 0.0
            attribute.frame = CGRect(x: 0, y: posY, width: cardCollectionCellSize.width,
                                     height: cardCollectionCellSize.height)
        }
        attribute.isRevealed = false
    }

    private func calculateCardScale(forIndex index: CGFloat, scaleBehindCard: Bool = false) -> CGFloat {
        if self.bottomStackedCardsShouldScale == true {
            let scalePerCard = self.scalePerCard
            let addedDownScale: CGFloat = (scaleBehindCard == true && index < self.bottomCardCount) ? scalePerCard: 0.0
            return min(1.0, self.bottomStackedCardsMaximumScale - (((index + 1 -
                self.bottomCardCount) * -1) * scalePerCard) - addedDownScale)
        }
        return 1.0
    }

    private func calculateCardHeadHeight() -> CGFloat {
        var cardHeadHeight = self.cardHeadHeight
        if self.cardShouldExpandHeadHeight == true {
            cardHeadHeight = max(self.cardHeadHeight,
                                 (self.collectionView!.frame.height - (self.contentInset.top +
                                    self.contentInsetBottom + self.spaceAtTopForBackgroundView)) /
                                    CGFloat(self.collectionViewItemCount))
        }
        return cardHeadHeight
    }

    // MARK: Revealed Card

    private func initializeRevealedCard() -> Bool {
        if let cell = self.collectionView?.cellForItem(at: IndexPath(item: self.revealedIndex, section: 0)) {
            self.revealedCardCell = cell
            self.rvldCardPanGestRecognizer = UIPanGestureRecognizer(target: self,
                                        action: #selector(self.rvldCardPanGestureHandler))
            self.rvldCardPanGestRecognizer?.delegate = self
            self.revealedCardCell?.addGestureRecognizer(self.rvldCardPanGestRecognizer!)
            return true
        }
        return false
    }

    private func deinitializeRevealedCard() {
        if self.revealedCardCell != nil && self.rvldCardPanGestRecognizer != nil {
            self.revealedCardCell?.removeGestureRecognizer(self.rvldCardPanGestRecognizer!)
            self.rvldCardPanGestRecognizer = nil
            self.revealedCardCell = nil
        }
    }

    @objc internal func rvldCardPanGestureHandler() {
        if self.collectionViewItemCount == 1 || self.rvldCardIsFlipped == true {
            return
        }
        if let revealedCardPanGestureRecognizer = self.rvldCardPanGestRecognizer, self.revealedCardCell != nil {
            let gestureTouchLocation = revealedCardPanGestureRecognizer.location(in: self.collectionView)
            let shiftY: CGFloat = (gestureTouchLocation.y -
                self.rvldCardPanGestureTouchLocationY  > 0) ? gestureTouchLocation.y -
                    self.rvldCardPanGestureTouchLocationY: 0

            switch revealedCardPanGestureRecognizer.state {
            case .began:
                UIApplication.shared.keyWindow?.endEditing(true)
                self.rvldCardPanGestureTouchLocationY = gestureTouchLocation.y
            case .changed:
                let scaleTarget = self.calculateCardScale(forIndex: self.cardCollectionBottomCardsRevealedIndex,
                                                          scaleBehindCard: true)
                let scaleDiff: CGFloat = 1.0 - scaleTarget
                let scale: CGFloat = 1.0 - min(((shiftY * scaleDiff) /
                    (self.collectionView!.frame.height / 2)), scaleDiff)
                let transformY = CGAffineTransform.init(translationX: 0, y: shiftY)
                let transformScale = CGAffineTransform.init(scaleX: scale, y: scale)
                self.revealedCardCell?.transform = transformY.concatenating(transformScale)
            default:
                let isNeedReload = (shiftY > self.revealedCardCell!.frame.height / 7) ? true: false
                let resetY = (isNeedReload) ? self.collectionView!.frame.height: 0
                let scale: CGFloat = (isNeedReload) ?
                    self.calculateCardScale(forIndex: self.cardCollectionBottomCardsRevealedIndex,
                                            scaleBehindCard: true): 1.0

                let transformScale = CGAffineTransform.init(scaleX: scale, y: scale)
                let transformY = CGAffineTransform.init(translationX: 0, y: resetY * (1.0 + (1.0 - scale)))

                UIView.animate(withDuration: 0.3, animations: {
                    self.revealedCardCell?.transform = transformY.concatenating(transformScale)
                }, completion: { (finished) in
                    if isNeedReload && finished {
                        self.revealCardAt(index: self.revealedIndex)
                    }
                })
            }
        }
    }

    // MARK: Moving Card

    @objc internal func mvngCardGestureHandler() {
        let moveUpOffset: CGFloat = 20

        if let movingCardGestureRecognizer = self.mvngCardGestureRecognizer {
            switch movingCardGestureRecognizer.state {
            case .began:
                self.mvngCardGestureStartLocation = movingCardGestureRecognizer.location(in: self.collectionView)
                if let indexPath = self.collectionView?.indexPathForItem(at: self.mvngCardGestureStartLocation) {
                    self.mvngCardActive = true
                    if indexPath.item < self.firstMovableIndex {
                        self.mvngCardActive = false
                        return
                    }
                    if let cell = self.collectionView?.cellForItem(at: indexPath) {
                        self.mvngCardStartIndexPath = indexPath
                        self.mvngCardCenterStart = cell.center
                        self.mvngCardSnapshotCell = cell.snapshotView(afterScreenUpdates: false)
                        self.mvngCardSnapshotCell?.frame = cell.frame
                        self.mvngCardSnapshotCell?.alpha = 1.0
                        self.mvngCardSnapshotCell?.layer.zPosition = cell.layer.zPosition
                        self.collectionView?.insertSubview(self.mvngCardSnapshotCell!, aboveSubview: cell)
                        cell.alpha = 0.0
                        self.mvngCardSelectedIndex = indexPath.item
                        UIView.animate(withDuration: 0.2, animations: {
                            self.mvngCardSnapshotCell?.frame.origin.y -= moveUpOffset
                        })
                    }
                } else {
                    self.mvngCardActive = false
                }
            case .changed:
                if self.mvngCardActive == true {
                    self.mvngCardGestureCurrentLocation =
                        movingCardGestureRecognizer.location(in: self.collectionView)
                    var currentCenter = self.mvngCardCenterStart
                    currentCenter.y += (self.mvngCardGestureCurrentLocation.y -
                        self.mvngCardGestureStartLocation.y - moveUpOffset)
                    self.mvngCardSnapshotCell?.center = currentCenter
                    if self.mvngCardGestureCurrentLocation.y > ((self.collectionView!.contentOffset.y +
                        self.collectionView!.frame.height) - self.spaceAtBottom -
                        self.contentInsetBottom - self.scrollAreaBottom) {
                        self.setupScrollTimer(direction: .down)
                    } else if (self.mvngCardGestureCurrentLocation.y -
                        self.collectionView!.contentOffset.y) - self.contentInset.top < self.scrollAreaTop {
                        self.setupScrollTimer(direction: .upwards)
                    } else {
                        self.invalidateScrollTimer()
                    }

                    var tempIndexPath = self.collectionView?.indexPathForItem(at: self.mvngCardGestureCurrentLocation)
                    if tempIndexPath == nil {
                        tempIndexPath = self.collectionView?.indexPathForItem(at: self.mvngCardLastTouchedLocation)
                    }

                    if let currentTouchedIndexPath = tempIndexPath {
                        self.mvngCardLastTouchedLocation = self.mvngCardGestureCurrentLocation
                        if currentTouchedIndexPath.item < self.firstMovableIndex {
                            return
                        }
                        if self.mvngCardLastTouchedIndexPath == nil &&
                            currentTouchedIndexPath != self.mvngCardStartIndexPath! {
                            self.mvngCardLastTouchedIndexPath = self.mvngCardStartIndexPath
                        }
                        if self.self.mvngCardLastTouchedIndexPath != nil &&
                            self.mvngCardLastTouchedIndexPath! != currentTouchedIndexPath {
                            let movingCell = self.collectionView?.cellForItem(at: currentTouchedIndexPath)
                            let movingCellAttr = self.collectionView?.layoutAttributesForItem(at:
                                currentTouchedIndexPath)

                            if movingCell != nil {
                                let cardHeadHeight = self.calculateCardHeadHeight()
                                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                                    movingCell?.frame.origin.y -= cardHeadHeight
                                }, completion: { (_) in
                                    movingCellAttr?.frame.origin.y -= cardHeadHeight
                                })
                            }

                            self.mvngCardSelectedIndex = currentTouchedIndexPath.item
                            self.collectionView?.dataSource?.collectionView?(self.collectionView!,
                                            moveItemAt: currentTouchedIndexPath, to: self.mvngCardLastTouchedIndexPath!)
                            UIView.performWithoutAnimation {
                                self.collectionView?.moveItem(at: currentTouchedIndexPath,
                                                              to: self.mvngCardLastTouchedIndexPath!)
                            }

                            self.mvngCardLastTouchedIndexPath = currentTouchedIndexPath
                            if let belowCell = self.collectionView?.cellForItem(at: currentTouchedIndexPath) {
                                self.mvngCardSnapshotCell?.removeFromSuperview()
                                self.collectionView?.insertSubview(self.mvngCardSnapshotCell!,
                                                                   belowSubview: belowCell)
                                self.mvngCardSnapshotCell?.layer.zPosition = belowCell.layer.zPosition
                            } else {
                                self.collectionView?.sendSubviewToBack(self.mvngCardSnapshotCell!)
                            }
                        }
                    }
                }
            case .ended:
                self.invalidateScrollTimer()
                if self.mvngCardActive == true {
                    var indexPath = self.mvngCardStartIndexPath!
                    if self.mvngCardLastTouchedIndexPath != nil {
                        indexPath = self.mvngCardLastTouchedIndexPath!
                    }
                    if let cell = self.collectionView?.cellForItem(at: indexPath) {
                        UIView.animate(withDuration: 0.2, animations: {
                            self.mvngCardSnapshotCell?.frame = cell.frame
                        }, completion: { (_) in
                            self.mvngCardActive = false
                            self.mvngCardLastTouchedIndexPath = nil
                            self.mvngCardSelectedIndex = -1
                            self.collectionView?.reloadData()
                            self.mvngCardSnapshotCell?.removeFromSuperview()
                            self.mvngCardSnapshotCell = nil
                            if self.mvngCardStartIndexPath == indexPath {
                                UIView.animate(withDuration: 0, animations: {
                                    self.invalidateLayout()
                                })
                            }
                        })
                    } else {
                        fallthrough
                    }
                }
            case .cancelled:
                self.mvngCardActive = false
                self.mvngCardLastTouchedIndexPath = nil
                self.mvngCardSelectedIndex = -1
                self.collectionView?.reloadData()
                self.mvngCardSnapshotCell?.removeFromSuperview()
                self.mvngCardSnapshotCell = nil
                self.invalidateLayout()
            default:
                break
            }
        }
    }

    // MARK: AutoScroll

    enum HFCardCollectionScrollDirection: Int {
        case unknown = 0
        case upwards
        case down
    }

    private func setupScrollTimer(direction: HFCardCollectionScrollDirection) {
        if self.autoscrollDisplayLink != nil && self.autoscrollDisplayLink!.isPaused == false {
            if direction == self.autoscrollDirection {
                return
            }
        }
        self.invalidateScrollTimer()
        self.autoscrollDisplayLink = CADisplayLink(target: self,
                                                   selector: #selector(self.autoscrollHandler(displayLink:)))
        self.autoscrollDirection = direction
        self.autoscrollDisplayLink?.add(to: .main, forMode: RunLoop.Mode.common)
    }

    private func invalidateScrollTimer() {
        if self.autoscrollDisplayLink != nil && self.autoscrollDisplayLink!.isPaused == false {
            self.autoscrollDisplayLink?.invalidate()
        }
        self.autoscrollDisplayLink = nil
    }

    @objc internal func autoscrollHandler(displayLink: CADisplayLink) {
        let direction = self.autoscrollDirection
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
        self.mvngCardGestureHandler()
    }

    private func generateScrollSpeedMultiplier() -> Double {
        var multiplier: Double = 250.0
        if let movingCardGestureRecognizer = self.mvngCardGestureRecognizer {
            let touchLocation = movingCardGestureRecognizer.location(in: self.collectionView)
            let maxSpeed: CGFloat = 600
            if self.autoscrollDirection == .upwards {
                let touchPosY = min(max(0, self.scrollAreaTop -
                    (touchLocation.y - self.contentOffsetTop)), self.scrollAreaTop)
                multiplier = Double(maxSpeed * (touchPosY / self.scrollAreaTop))
            } else if self.autoscrollDirection == .down {
                let offsetTop = ((self.collectionView!.contentOffset.y +
                    self.collectionView!.frame.height) - self.spaceAtBottom -
                    self.contentInsetBottom - self.scrollAreaBottom)
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
        if gestureRecognizer == self.mvngCardGestureRecognizer ||
            gestureRecognizer == self.collectionViewTapGestureRecognizer {
            if self.revealedIndex >= 0 {
                return false
            }
        }

        if gestureRecognizer == self.rvldCardPanGestRecognizer {
            let velocity =  self.rvldCardPanGestRecognizer?.velocity(in:
                self.rvldCardPanGestRecognizer?.view)
            let result = abs(velocity!.y) > abs(velocity!.x)
            return result
        }
        return true
    }
}
