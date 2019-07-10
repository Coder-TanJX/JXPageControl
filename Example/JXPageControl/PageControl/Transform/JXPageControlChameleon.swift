//
//  JXPageControlChameleon.swift
//  JXPageControl_Example
//
//  Created by 谭家祥 on 2019/7/4.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

@IBDesignable public class JXPageControlChameleon: UIView, JXPageControlType {
    var isActiveHollow: Bool = false
    
    var indicatorSize: CGSize = CGSize.zero
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setBase()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setBase()
    }
    
    func setBase() {
        addSubview(contentView)
    }
    
    public override var contentMode: UIViewContentMode {
        didSet {
            switch contentMode {
                
            case .center:
                contentAlignment = JXPageControlAlignment(.center, .center)
            case .left:
                contentAlignment = JXPageControlAlignment(.left, .center)
            case .right:
                contentAlignment = JXPageControlAlignment(.right, .center)
                
            case .bottom:
                contentAlignment = JXPageControlAlignment(.center, .bottom)
            case .bottomLeft:
                contentAlignment = JXPageControlAlignment(.left, .bottom)
            case .bottomRight:
                contentAlignment = JXPageControlAlignment(.right, .bottom)
                
            case .top:
                contentAlignment = JXPageControlAlignment(.center, .top)
            case .topLeft:
                contentAlignment = JXPageControlAlignment(.left, .top)
            case .topRight:
                contentAlignment = JXPageControlAlignment(.right, .top)
                
            default:
                contentAlignment = JXPageControlAlignment(.center, .center)
            }
        }
    }
    
    // MARK: - -------------------------- JXPageControlType --------------------------
    
    /// Default is 0
    @IBInspectable public var numberOfPages: Int = 0 {
        didSet { reloadData() }
    }
    
    private var currentIndex: Int = 0
    public var currentPage: Int {
        set { updateCurrentPage(newValue) }
        get { return currentIndex }
    }
    
    /// Default is 0.0. value pinned to 0.0..numberOfPages-1
    @IBInspectable public var progress: CGFloat = 0.0 {
        didSet { updateProgress(progress) }
    }
    
    /// Hide the the indicator if there is only one page. default is NO
    @IBInspectable public var hidesForSinglePage: Bool = false {
        didSet { resetHidden() }
    }
    
    /// Inactive item tint color
    @IBInspectable public var inactiveColor: UIColor =
        UIColor.groupTableViewBackground.withAlphaComponent(0.3) {
        didSet {
            inactiveLayer.forEach() {
                $0.backgroundColor = inactiveColor.cgColor
            }
        }
    }
    
    /// Active item ting color
    @IBInspectable public var activeColor: UIColor =
        UIColor.orange {
        didSet {
            inactiveLayer[currentIndex].backgroundColor = activeColor.cgColor
        }
    }
    
    /// Inactive item size
    @IBInspectable var inactiveSize: CGSize = CGSize(width: 10,
                                                     height: 10) {
        didSet { reloadLayout() }
    }
    
    /// Active item size
    @IBInspectable var activeSize: CGSize = CGSize(width: 10,
                                                   height: 10) {
        didSet {
            reloadLayout()
            updateProgress(progress)
        }
    }
    
    /// Column spacing
    @IBInspectable public var columnSpacing: CGFloat = 5.0 {
        didSet { reloadLayout() }
    }
    
    /// Inactive hollow figure
    @IBInspectable public var isInactiveHollow: Bool = false {
        didSet {}
    }
    
    /// Content location
    public var contentAlignment: JXPageControlAlignment =
        JXPageControlAlignment(.center,
                               .center) {
        didSet { layoutContentView() }
    }
    
    /// Refresh the data and UI again
    func reload() {
        reloadData()
    }
    
    // MARK: - -------------------------- Custom property list --------------------------
    
    @IBInspectable public var isFlexible: Bool = true
    
    @IBInspectable public var isAnimation: Bool = true {
        didSet { layoutActiveIndicator() }
    }
    
    private let contentView: UIView = UIView()
    
    private var maxIndicatorSize: CGSize = CGSize(width: 2, height: 2)
    
    private var minIndicatorSize: CGSize = CGSize(width: 2, height: 2)
    
    private var inactiveLayer: [CALayer] = []
    
    private var inactiveOriginFrame: [CGRect] = []
    
    // MARK: - -------------------------- Update tht data --------------------------
    func reloadData() {
        resetInactiveLayer()
        resetActiveLayer()
        resetHidden()
        reloadLayout()
        progress = 0.0
    }
    
    func reloadLayout() {
        layoutContentView()
        layoutInactiveIndicators()
        layoutActiveIndicator()
    }
    
    func updateProgress(_ progress: CGFloat) {
        guard progress >= 0 ,
            progress <= CGFloat(numberOfPages - 1)
            else { return }

        let leftIndex = Int(floor(progress))
        let rightIndex = leftIndex + 1 > numberOfPages - 1 ? leftIndex : leftIndex + 1
        
        if leftIndex == rightIndex {
            for index in 0 ..< numberOfPages {
                if index != leftIndex{
                    let layer = inactiveLayer[index]
                    layer.frame = inactiveOriginFrame[index]
                    layer.backgroundColor = inactiveColor.cgColor
                    if inactiveSize.width > inactiveSize.height {
                        layer.cornerRadius = inactiveSize.width*0.5
                    }else {
                        layer.cornerRadius = inactiveSize.height*0.5
                    }
                }else {
                    let layer = inactiveLayer[index]
                    let frame = inactiveOriginFrame[index]
                    layer.frame = CGRect(x: frame.origin.x - (activeSize.width - inactiveSize.width) * 0.5,
                                         y: (maxIndicatorSize.width - activeSize.height) * 0.5,
                                         width: activeSize.width,
                                         height: activeSize.height)
                    layer.backgroundColor = activeColor.cgColor
                    if activeSize.width > activeSize.height {
                        layer.cornerRadius = activeSize.width*0.5
                    }else {
                        layer.cornerRadius = activeSize.height*0.5
                    }
                }
            }
        }else {
            let leftLayer = inactiveLayer[leftIndex]
            let rightLayer = inactiveLayer[rightIndex]
            
            let rightScare = progress - floor(progress)
            let leftScare = 1 - rightScare
            
            
            CATransaction.begin()
            CATransaction.setDisableActions(!isAnimation)
            CATransaction.setAnimationDuration(0.2)
            
            leftLayer.backgroundColor = UIColor.transform(originColor: inactiveColor,
                                                          targetColor: activeColor,
                                                          proportion: leftScare).cgColor
            rightLayer.backgroundColor = UIColor.transform(originColor: inactiveColor,
                                                           targetColor: activeColor,
                                                           proportion: rightScare).cgColor
            
            let activeWidth = activeSize.width > kMinItemWidth ? activeSize.width : kMinItemWidth
            let activeHeight = activeSize.height > kMinItemHeight ? activeSize.height : kMinItemHeight
            let inactiveWidth = inactiveSize.width > kMinItemWidth ? inactiveSize.width : kMinItemWidth
            let inactiveHeight = inactiveSize.height > kMinItemHeight ? inactiveSize.height : kMinItemHeight
            
            let marginWidth = activeWidth - inactiveWidth
            let marginHeight = activeHeight - inactiveHeight
            
            let leftWidth = inactiveWidth + marginWidth * leftScare
            let rightWidth = inactiveWidth + marginWidth * rightScare
            let leftHeight = inactiveHeight + marginHeight * leftScare
            let rightHeight = inactiveHeight + marginHeight * rightScare
            
            
            let leftX = (maxIndicatorSize.width - leftWidth) * 0.5 + (maxIndicatorSize.width + columnSpacing) * CGFloat(leftIndex)
            let rightX = (maxIndicatorSize.width - rightWidth) * 0.5 + (maxIndicatorSize.width + columnSpacing) * CGFloat(rightIndex)
            
            leftLayer.frame = CGRect(x: leftX,
                                     y: (maxIndicatorSize.width - leftHeight) * 0.5,
                                     width: leftWidth,
                                     height: leftHeight)
            
            
            
            rightLayer.frame = CGRect(x: rightX,
                                      y: (maxIndicatorSize.width - rightHeight) * 0.5,
                                      width: rightWidth,
                                      height: rightHeight)
            
            
            if leftWidth > leftHeight {
                leftLayer.cornerRadius = leftHeight*0.5
            }else {
                leftLayer.cornerRadius = leftWidth*0.5
            }
            if rightWidth > rightHeight {
                rightLayer.cornerRadius = rightHeight*0.5
            }else {
                rightLayer.cornerRadius = rightWidth*0.5
            }
            
            
            
            for index in 0 ..< numberOfPages {
                if index != leftIndex,
                    index != rightIndex {
                    let layer = inactiveLayer[index]
                    layer.frame = inactiveOriginFrame[index]
                    layer.backgroundColor = inactiveColor.cgColor
                    if layer.frame.width > layer.frame.height {
                        layer.cornerRadius = layer.frame.height*0.5
                    }else {
                        layer.cornerRadius = layer.frame.width*0.5
                    }
                }
            }
            CATransaction.commit()
        }
        currentIndex = Int(progress)
    }
    
    func updateCurrentPage(_ pageIndex: Int) {
        guard pageIndex >= 0 ,
            pageIndex <= numberOfPages - 1,
            pageIndex != currentIndex
            else { return }
        
        for index in 0 ..< numberOfPages {
            if index == currentIndex {
                CATransaction.begin()
                CATransaction.setDisableActions(!isAnimation)
                CATransaction.setAnimationDuration(0.7)
                let layer = inactiveLayer[index]
                layer.frame = inactiveOriginFrame[index]
                layer.backgroundColor = inactiveColor.cgColor
                if inactiveSize.width > inactiveSize.height {
                    layer.cornerRadius = inactiveSize.height*0.5
                }else {
                    layer.cornerRadius = inactiveSize.width*0.5
                }
                CATransaction.commit()
            }else if index == pageIndex {
                let layer = inactiveLayer[index]
                let frame = inactiveOriginFrame[index]
                
                CATransaction.begin()
                CATransaction.setDisableActions(!isAnimation)
                CATransaction.setAnimationDuration(0.7)
                layer.frame = CGRect(x: frame.origin.x - (self.activeSize.width - self.inactiveSize.width) * 0.5,
                                     y: (self.maxIndicatorSize.width - self.activeSize.height) * 0.5,
                                     width: self.activeSize.width,
                                     height: self.activeSize.height)
                layer.backgroundColor = self.activeColor.cgColor
                if self.activeSize.width > self.activeSize.height {
                    layer.cornerRadius = self.activeSize.height*0.5
                }else {
                    layer.cornerRadius = self.activeSize.width*0.5
                }
                CATransaction.commit()
                
                
            }
        }
        currentIndex = pageIndex
    }
    
    // MARK: - -------------------------- Reset --------------------------
    func resetHidden() {
        if hidesForSinglePage,
            numberOfPages == 1 {
            inactiveLayer.forEach { $0.isHidden = true }
        }else {
            inactiveLayer.forEach { $0.isHidden = false }
        }
    }
    
    func resetInactiveLayer() {
        // clear data
        inactiveLayer.forEach() { $0.removeFromSuperlayer() }
        inactiveLayer = [CALayer]()
        // set new layers
        for _ in 0..<numberOfPages {
            let layer = CALayer()
            layer.backgroundColor = inactiveColor.cgColor
            contentView.layer.addSublayer(layer)
            inactiveLayer.append(layer)
        }
    }
    
    func resetActiveLayer() {}
    
    // MARK: - -------------------------- Layout --------------------------
    private func layoutContentView() {
        
        // MaxItem size
        var itemWidth = kMinItemWidth
        var itemHeight = kMinItemHeight
        minIndicatorSize.width = kMinItemWidth
        minIndicatorSize.height = kMinItemHeight
        
        if activeSize.width >= inactiveSize.width,
            activeSize.width > kMinItemWidth{
            itemWidth = activeSize.width
            minIndicatorSize.width = inactiveSize.width
        } else if inactiveSize.width > activeSize.width,
            inactiveSize.width > kMinItemWidth{
            itemWidth = inactiveSize.width
            minIndicatorSize.width = activeSize.width
        }
        
        if activeSize.height >= inactiveSize.height,
            activeSize.height > kMinItemHeight{
            itemHeight = activeSize.height
            minIndicatorSize.height = inactiveSize.height
        } else if inactiveSize.height > activeSize.height,
            inactiveSize.height > kMinItemHeight{
            itemHeight = inactiveSize.height
            minIndicatorSize.height = activeSize.height
        }
        maxIndicatorSize.height = itemHeight
        maxIndicatorSize.width = itemWidth
        
        // Content Size and frame
        var x: CGFloat = 0
        var y: CGFloat = 0
        let width = CGFloat(numberOfPages) * (itemWidth + columnSpacing) - columnSpacing
        let height = itemHeight
        
        // Horizon layout
        switch contentAlignment.horizon {
        case .left:
            x = 0
        case .right:
            x = (frame.width - width)
        case .center:
            x = (frame.width - width) * 0.5
        }
        
        // Vertical layout
        switch contentAlignment.vertical {
        case .top:
            y = 0
        case .bottom:
            y = frame.height - height
        case .center:
            y = (frame.height - height) * 0.5
        }
        
        contentView.frame = CGRect(x: x,
                                   y: y,
                                   width: width,
                                   height: height)
    }
    
    private func layoutActiveIndicator() {}
    
    private func layoutInactiveIndicators() {
        let x = (maxIndicatorSize.width - inactiveSize.width) * 0.5
        let y = (maxIndicatorSize.height - inactiveSize.height) * 0.5
        let inactiveWidth = inactiveSize.width > kMinItemWidth ? inactiveSize.width : kMinItemWidth
        let inactiveHeight = inactiveSize.height > kMinItemHeight ? inactiveSize.height : kMinItemHeight
        var layerFrame = CGRect(x: x,
                                y: y,
                                width: inactiveWidth ,
                                height: inactiveHeight)
        inactiveLayer.forEach() { layer in
            layer.cornerRadius = inactiveSize.height * 0.5
            layer.frame = layerFrame
            inactiveOriginFrame.append(layerFrame)
            layerFrame.origin.x +=  maxIndicatorSize.width + columnSpacing
        }
    }
}


//@IBDesignable public class JXPageControlChameleon: UIView, JXPageControlType {
//
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//        setBase()
//    }
//
//    internal required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setBase()
//    }
//
//    func setBase() {
//        addSubview(contentView)
//    }
//
//    public override var contentMode: UIViewContentMode {
//        didSet {
//            switch contentMode {
//
//            case .center:
//                contentAlignment = JXPageControlAlignment(.center, .center)
//            case .left:
//                contentAlignment = JXPageControlAlignment(.left, .center)
//            case .right:
//                contentAlignment = JXPageControlAlignment(.right, .center)
//
//            case .bottom:
//                contentAlignment = JXPageControlAlignment(.center, .bottom)
//            case .bottomLeft:
//                contentAlignment = JXPageControlAlignment(.left, .bottom)
//            case .bottomRight:
//                contentAlignment = JXPageControlAlignment(.right, .bottom)
//
//            case .top:
//                contentAlignment = JXPageControlAlignment(.center, .top)
//            case .topLeft:
//                contentAlignment = JXPageControlAlignment(.left, .top)
//            case .topRight:
//                contentAlignment = JXPageControlAlignment(.right, .top)
//
//            default:
//                contentAlignment = JXPageControlAlignment(.center, .center)
//            }
//        }
//    }
//
//    // MARK: - -------------------------- JXPageControlType --------------------------
//
//    /// Default is 0
//    @IBInspectable public var numberOfPages: Int = 0 {
//        didSet { reloadData() }
//    }
//
//    /// Default is 0. value pinned to 0..numberOfPages-1
//    public var currentPage: Int {
//        set { progress = CGFloat(currentPage) }
//        get { return Int(progress) }
//    }
//
//    /// Default is 0.0. value pinned to 0.0..numberOfPages-1
//    @IBInspectable public var progress: CGFloat = 0.0 {
//        didSet { updateProgress(progress) }
//    }
//
//    /// Hide the the indicator if there is only one page. default is NO
//    @IBInspectable public var hidesForSinglePage: Bool = false {
//        didSet { resetHidden() }
//    }
//
//    /// Inactive item tint color
//    @IBInspectable public var inactiveColor: UIColor =
//        UIColor.groupTableViewBackground.withAlphaComponent(0.3) {
//        didSet {
//            inactiveLayer.forEach() {
//                $0.backgroundColor = inactiveColor.cgColor
//            }
//        }
//    }
//
//    /// Active item ting color
//    @IBInspectable public var activeColor: UIColor =
//        UIColor.orange {
//        didSet {
//            //            activeLayer.backgroundColor
//            //                = activeColor.cgColor
//        }
//    }
//
//    /// Inactive item size
//    @IBInspectable var inactiveSize: CGSize = CGSize(width: 20,
//                                                     height: 20) {
//        didSet { reloadLayout() }
//    }
//
//    /// Active item size
//    @IBInspectable var activeSize: CGSize = CGSize(width: 20,
//                                                   height: 20) {
//        didSet {
//            reloadLayout()
//            updateProgress(progress)
//        }
//    }
//
//    /// Column spacing
//    @IBInspectable public var columnSpacing: CGFloat = 5.0 {
//        didSet { reloadLayout() }
//    }
//
//    /// Inactive hollow figure
//    @IBInspectable public var isInactiveHollow: Bool = false {
//        didSet {}
//    }
//
//    /// Content location
//    public var contentAlignment: JXPageControlAlignment =
//        JXPageControlAlignment(.center,
//                               .center) {
//        didSet { layoutContentView() }
//    }
//
//    /// Refresh the data and UI again
//    func reload() {
//        reloadData()
//    }
//    // MARK: - -------------------------- Custom property list --------------------------
//
//    @IBInspectable public var isFlexible: Bool = true
//
//    @IBInspectable public var isAnimation: Bool = true {
//        didSet { layoutActiveIndicator() }
//    }
//
//    private let contentView: UIView = UIView()
//
//    private var maxIndicatorSize: CGSize = CGSize(width: 2, height: 2)
//
//    private var inactiveLayer: [CALayer] = []
//
//    private var inactiveOriginFrame: [CGRect] = []
//
//    // MARK: - -------------------------- Update tht data --------------------------
//    func reloadData() {
//        resetInactiveLayer()
//        resetActiveLayer()
//        resetHidden()
//        reloadLayout()
//        progress = 0.0
//    }
//
//    func reloadLayout() {
//        layoutContentView()
//        layoutInactiveIndicators()
//        layoutActiveIndicator()
//    }
//
//    func updateProgress(_ progress: CGFloat) {
//        guard progress >= 0 ,
//            progress <= CGFloat(numberOfPages - 1)
//            else { return }
//
//
//
//
//        let leftIndex = Int(floor(progress))
//        let rightIndex = leftIndex + 1 > numberOfPages - 1 ? leftIndex : leftIndex + 1
//
//        if leftIndex == rightIndex {
//            for index in 0 ..< numberOfPages {
//                if index != leftIndex{
//                    let layer = inactiveLayer[index]
//                    layer.backgroundColor = inactiveColor.cgColor
//
//                }else {
//                    let layer = inactiveLayer[index]
//                    layer.backgroundColor = activeColor.cgColor
//                }
//            }
//        }else {
//            let leftLayer = inactiveLayer[leftIndex]
//            let rightLayer = inactiveLayer[rightIndex]
//            let rightScare = progress - floor(progress)
//            let leftScare = 1 - rightScare
//
//            CATransaction.setDisableActions(true)
//
//            leftLayer.backgroundColor = UIColor.transform(originColor: inactiveColor,
//                                                          targetColor: activeColor,
//                                                          proportion: leftScare).cgColor
//            rightLayer.backgroundColor = UIColor.transform(originColor: inactiveColor,
//                                                           targetColor: activeColor,
//                                                           proportion: rightScare).cgColor
//
//            for index in 0 ..< numberOfPages {
//                if index != leftIndex,
//                    index != rightIndex {
//                    let layer = inactiveLayer[index]
//                    layer.backgroundColor = inactiveColor.cgColor
//
//                }
//            }
//
//
//            CATransaction.commit()
//        }
//
//    }
//
//    // MARK: - -------------------------- Reset --------------------------
//    func resetHidden() {
//        if hidesForSinglePage,
//            numberOfPages == 1 {
//            inactiveLayer.forEach { $0.isHidden = true }
//        }else {
//            inactiveLayer.forEach { $0.isHidden = false }
//        }
//    }
//
//    func resetInactiveLayer() {
//        // clear data
//        inactiveLayer.forEach() { $0.removeFromSuperlayer() }
//        inactiveLayer = [CALayer]()
//        // set new layers
//        for _ in 0..<numberOfPages {
//            let layer = CALayer()
//            layer.backgroundColor = inactiveColor.cgColor
//            contentView.layer.addSublayer(layer)
//            inactiveLayer.append(layer)
//        }
//    }
//
//    func resetActiveLayer() {}
//
//    // MARK: - -------------------------- Layout --------------------------
//    private func layoutContentView() {
//
//        // MaxItem size
//        var itemWidth = kMinItemWidth
//        var itemHeight = kMinItemHeight
//
//        if activeSize.width >= inactiveSize.width,
//            activeSize.width > kMinItemWidth{
//            itemWidth = activeSize.width
//        } else if inactiveSize.width > activeSize.width,
//            inactiveSize.width > kMinItemWidth{
//            itemWidth = inactiveSize.width
//        }
//
//        if activeSize.height >= inactiveSize.height,
//            activeSize.height > kMinItemHeight{
//            itemHeight = activeSize.height
//        } else if inactiveSize.height > activeSize.height,
//            inactiveSize.height > kMinItemHeight{
//            itemHeight = inactiveSize.height
//        }
//        maxIndicatorSize.height = itemHeight
//        maxIndicatorSize.width = itemWidth
//
//        // Content Size and frame
//        var x: CGFloat = 0
//        var y: CGFloat = 0
//        let width = CGFloat(numberOfPages) * (itemWidth + columnSpacing) - columnSpacing
//        let height = itemHeight
//
//        // Horizon layout
//        switch contentAlignment.horizon {
//        case .left:
//            x = 0
//        case .right:
//            x = (frame.width - width)
//        case .center:
//            x = (frame.width - width) * 0.5
//        }
//
//        // Vertical layout
//        switch contentAlignment.vertical {
//        case .top:
//            y = 0
//        case .bottom:
//            y = frame.height - height
//        case .center:
//            y = (frame.height - height) * 0.5
//        }
//
//        contentView.frame = CGRect(x: x,
//                                   y: y,
//                                   width: width,
//                                   height: height)
//    }
//
//    private func layoutActiveIndicator() {}
//
//    private func layoutInactiveIndicators() {
//        let x = (maxIndicatorSize.width - inactiveSize.width) * 0.5
//        let y = (maxIndicatorSize.height - inactiveSize.height) * 0.5
//        var layerFrame = CGRect(x: x,
//                                y: y,
//                                width: inactiveSize.width,
//                                height: inactiveSize.height)
//        inactiveLayer.forEach() { layer in
//            layer.cornerRadius = inactiveSize.height * 0.5
//            layer.frame = layerFrame
//            inactiveOriginFrame.append(layerFrame)
//            layerFrame.origin.x +=  maxIndicatorSize.width + columnSpacing
//        }
//    }
//}
