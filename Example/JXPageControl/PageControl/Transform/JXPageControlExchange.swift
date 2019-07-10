//
//  JXPageControlExchange.swift
//  JXPageControl_Example
//
//  Created by 谭家祥 on 2019/7/3.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit


@IBDesignable public class JXPageControlExchange: UIView, JXPageControlType {
    var indicatorSize: CGSize = CGSize(width: 10, height: 10)
    
    
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
    
    /// Default is 0. value pinned to 0..numberOfPages-1
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
        didSet { inactiveHollowLayout() }
    }
    
    /// Active item ting color
    @IBInspectable public var activeColor: UIColor =
        UIColor.orange {
        didSet { activeHollowLayout() }
    }
    
    /// Inactive item size
    @IBInspectable var inactiveSize: CGSize = CGSize(width: 20,
                                                     height: 20) {
        didSet { reloadLayout() }
    }
    
    /// Active item size
    @IBInspectable var activeSize: CGSize = CGSize(width: 20,
                                                   height: 20) {
        didSet {
            reloadLayout()
            updateProgress(progress)
        }
    }
    
    /// Column spacing
    @IBInspectable public var columnSpacing: CGFloat = 10 {
        didSet { reloadLayout() }
    }
    
    /// Inactive hollow figure
    @IBInspectable public var isInactiveHollow: Bool = false {
        didSet { inactiveHollowLayout() }
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
    /// Inactive hollow figure
    @IBInspectable public var isActiveHollow: Bool = false {
        didSet { activeHollowLayout() }
    }
    
    @IBInspectable public var isFlexible: Bool = true
    
    @IBInspectable public var isAnimation: Bool = true {
        didSet { layoutActiveIndicator() }
    }
    
    private let contentView: UIView = UIView()
    
    private var maxIndicatorSize: CGSize = CGSize(width: 2, height: 2)
    
    private var inactiveLayer: [CALayer] = []
    
    private var inactiveOriginFrame: [CGRect] = []
    
    private var activeLayer: CALayer!
    
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
            
            CATransaction.setDisableActions(true)
            
            let marginX: CGFloat = maxIndicatorSize.width + columnSpacing
            
            // 活跃点布局
            let activeLayerX = (maxIndicatorSize.width - activeSize.width) * 0.5 + floor(progress) * marginX
            activeLayer?.frame = CGRect(x: activeLayerX,
                                        y: activeLayer?.frame.minY ?? 0,
                                        width: activeSize.width,
                                        height: activeSize.height)
            
            // 不活跃点布局
            for index in 0 ..< numberOfPages - 1 {

                var layerFrame: CGRect = inactiveOriginFrame[index]
                let layer = inactiveLayer[index]

                if index < Int(progress) {
                    layerFrame.origin.x -=  marginX
                    layer.frame = layerFrame
                }else if index > Int(progress) {
                    layer.frame = layerFrame
                }
            }
            
            CATransaction.commit()
            
            
        }else {
            
            CATransaction.setDisableActions(true)
            
            let marginX: CGFloat = maxIndicatorSize.width + columnSpacing
            
            // 活跃点布局
            let activeLayerX = (maxIndicatorSize.width - activeSize.width) * 0.5 + progress * marginX
            activeLayer?.frame = CGRect(x: activeLayerX,
                                        y: activeLayer?.frame.minY ?? 0,
                                        width: activeSize.width,
                                        height: activeSize.height)
            
            // 不活跃点布局
            for index in 0 ..< numberOfPages - 1 {
                
                var layerFrame: CGRect = inactiveOriginFrame[index]
                let layer = inactiveLayer[index]
                
                if index < Int(progress) {
                    layerFrame.origin.x -=  marginX
                    layer.frame = layerFrame
                }else if index > Int(progress) {
                    layer.frame = layerFrame
                }else {
                    let leftScare = progress - floor(progress)
                    layerFrame.origin.x =  layerFrame.origin.x - leftScare * marginX
                    layer.frame = layerFrame
                }
            }
            
            CATransaction.commit()
        }
    }
    
    func updateCurrentPage(_ pageIndex: Int) {
        guard pageIndex >= 0 ,
            pageIndex <= numberOfPages - 1,
            pageIndex != currentIndex
            else { return }

        let marginX: CGFloat = maxIndicatorSize.width + columnSpacing
        
        // 活跃点布局
        let activeLayerX = (maxIndicatorSize.width - activeSize.width) * 0.5 + CGFloat(pageIndex) * marginX
        activeLayer?.frame = CGRect(x: activeLayerX,
                                    y: activeLayer?.frame.minY ?? 0,
                                    width: activeSize.width,
                                    height: activeSize.height)
        
        // 不活跃点布局
        for index in 0 ..< numberOfPages - 1 {
            
            var layerFrame: CGRect = inactiveOriginFrame[index]
            let layer = inactiveLayer[index]
            
            if index < pageIndex {
                layerFrame.origin.x -=  marginX
                layer.frame = layerFrame
            }else if index >=  pageIndex {
                layer.frame = layerFrame
            }
        }

        

        currentIndex = pageIndex
    }
    
    func inactiveHollowLayout() {
        if isInactiveHollow {
            inactiveLayer.forEach { (layer) in
                layer.backgroundColor = UIColor.clear.cgColor
                layer.borderColor = inactiveColor.cgColor
                layer.borderWidth = 1
            }
        }else {
            inactiveLayer.forEach { (layer) in
                layer.backgroundColor = inactiveColor.cgColor
                layer.borderWidth = 0
            }
        }
    }
    
    func activeHollowLayout() {
        if isActiveHollow {
            activeLayer.backgroundColor = UIColor.clear.cgColor
            activeLayer.borderColor = activeColor.cgColor
            activeLayer.borderWidth = 1
        }else {
            activeLayer.backgroundColor = activeColor.cgColor
            activeLayer.borderWidth = 0
        }
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
        inactiveOriginFrame = []
        // set new layers
        for _ in 0 ..< numberOfPages - 1 {
            let layer = CALayer()
            contentView.layer.addSublayer(layer)
            inactiveLayer.append(layer)
        }
    }
    
    func resetActiveLayer() {
        
        activeLayer?.removeFromSuperlayer()
        activeLayer = CALayer()
        activeLayer?.cornerRadius = activeSize.height * 0.5
        contentView.layer.addSublayer(activeLayer!)
    }
    
    // MARK: - -------------------------- Layout --------------------------
    private func layoutContentView() {
        
        // MaxItem size
        var itemWidth = kMinItemWidth
        var itemHeight = kMinItemHeight
        
        if activeSize.width >= inactiveSize.width,
            activeSize.width > kMinItemWidth{
            itemWidth = activeSize.width
        } else if inactiveSize.width > activeSize.width,
            inactiveSize.width > kMinItemWidth{
            itemWidth = inactiveSize.width
        }
        
        if activeSize.height >= inactiveSize.height,
            activeSize.height > kMinItemHeight{
            itemHeight = activeSize.height
        } else if inactiveSize.height > activeSize.height,
            inactiveSize.height > kMinItemHeight{
            itemHeight = inactiveSize.height
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
    
    private func layoutActiveIndicator() {
        let x = (maxIndicatorSize.width - activeSize.width) * 0.5
        let y = (maxIndicatorSize.height - activeSize.height) * 0.5
        activeLayer?.frame = CGRect(x: x,
                                    y: y,
                                    width: activeSize.width,
                                    height: activeSize.height)
        activeHollowLayout()
    }
    
    private func layoutInactiveIndicators() {
        let x = (maxIndicatorSize.width - inactiveSize.width) * 0.5
        let y = (maxIndicatorSize.height - inactiveSize.height) * 0.5
        var layerFrame = CGRect(x: x + maxIndicatorSize.width + columnSpacing,
                                y: y,
                                width: inactiveSize.width,
                                height: inactiveSize.height)
        inactiveLayer.forEach() { layer in
            layer.cornerRadius = inactiveSize.height * 0.5
            layer.frame = layerFrame
            inactiveOriginFrame.append(layerFrame)
            layerFrame.origin.x +=  maxIndicatorSize.width + columnSpacing
        }
        inactiveHollowLayout()
    }
}
