//
//  JXPageControlFill.swift
//  JXPageControl_Example
//
//  Created by 谭家祥 on 2019/6/10.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import CoreGraphics

private let kMinContentSize = CGSize(width: 2, height: 2)

@IBDesignable public class JXPageControlFill: UIView, JXPageControlType {
    var indicatorSize: CGSize = CGSize.zero
    
    var isActiveHollow: Bool = false
    
    
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
        didSet { updateProgress(progress) }
    }
    
    /// Inactive item size
     var inactiveSize: CGSize = CGSize(width: 10,
                                       height: 10)
    
    /// Active item size
    var activeSize: CGSize = CGSize(width: 10,
                                    height: 10)
    
    /// Column spacing
    @IBInspectable public var columnSpacing: CGFloat = 5.0 {
        didSet { reloadLayout() }
    }
    
    /// Inactive hollow figure
    @IBInspectable public var isInactiveHollow: Bool = true {
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
    /// Indicator diameter
    @IBInspectable var diameter: CGFloat = 10.0 {
        didSet {
            reloadLayout()
            updateProgress(progress)
        }
    }
    
    /// Indicator ring borderWidth
    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            reloadLayout()
            updateProgress(progress)
        }
    }
    
    @IBInspectable public var isAnimation: Bool = true {
        didSet { layoutActiveIndicator() }
    }
    
    private let contentView: UIView = UIView()
    
    private var inactiveLayer: [CALayer] = []
    
    
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
        
        let borderW: CGFloat = isInactiveHollow ? borderWidth : 0
        let insetRect = CGRect(x: 0,
                          y: 0,
                          width: diameter,
                          height: diameter).insetBy(dx: borderW, dy: borderW)

        let left = floor(progress)
        let page = Int(progress)
        let move = insetRect.width / 2

        let rightInset = move * CGFloat(progress - left)
        let rightRect = insetRect.insetBy(dx: rightInset, dy: rightInset)

        let leftInset = (1 - CGFloat(progress - left)) * move
        let leftRect = insetRect.insetBy(dx: leftInset, dy: leftInset)
        
        for (index, layer) in inactiveLayer.enumerated() {
            switch index {
            case page:
                hollowLayout(layer: layer,
                             insetRect: leftRect)
            case page + 1:
                 hollowLayout(layer: layer,
                              insetRect: rightRect)
                break
            default:
                 hollowLayout(layer: layer,
                              insetRect: insetRect)
                break
            }
        }
        currentIndex = Int(progress)
    }
    
    func updateCurrentPage(_ pageIndex: Int) {
        guard pageIndex >= 0 ,
            pageIndex <= numberOfPages - 1,
            pageIndex != currentIndex
            else { return }
        
        
        let borderW: CGFloat = isInactiveHollow ? borderWidth : 0
        let insetRect = CGRect(x: 0,
                               y: 0,
                               width: diameter,
                               height: diameter).insetBy(dx: borderW, dy: borderW)
        let maxW = insetRect.width / 2
        
        
        for (index, layer) in inactiveLayer.enumerated() {
            if index == currentIndex {
                hollowLayout(layer: layer,
                              insetRect: insetRect,
                              coefficient: maxW,
                              maxW: nil)
                
            }else if index == pageIndex {
                hollowLayout(layer: layer,
                             insetRect: insetRect,
                             coefficient: 1,
                             maxW: maxW)
            }
        }
        
        currentIndex = pageIndex
    }
    
    func hollowLayout(layer: CALayer,
                      insetRect: CGRect,
                      coefficient: CGFloat,
                      maxW: CGFloat?) {
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.02)
        CATransaction.setCompletionBlock { [weak self] in
            guard let strongSelf = self else { return }
            
            
            if let maxW = maxW {
                let tempCoefficient = coefficient + 1
                if tempCoefficient <= maxW {
                    strongSelf.hollowLayout(layer: layer,
                                            insetRect: insetRect,
                                            coefficient: tempCoefficient,
                                            maxW: maxW)
                }
            }else {
                let tempCoefficient = coefficient - 1
                if tempCoefficient >= 0 {
                    strongSelf.hollowLayout(layer: layer,
                                             insetRect: insetRect,
                                             coefficient: tempCoefficient,
                                             maxW: nil)
                }
            }
            
        }
        
        let tempInsetRect = insetRect.insetBy(dx: coefficient,
                                              dy: coefficient)
        hollowLayout(layer: layer, insetRect: tempInsetRect)
        CATransaction.commit()
    }
    
    func hollowLayout(layer: CALayer, insetRect: CGRect) {
        
        layer.sublayers?.forEach({ (sublayer) in
            sublayer.removeFromSuperlayer()
        })
        
        let mask = CAShapeLayer()
        mask.fillRule = kCAFillRuleEvenOdd
        let bounds = UIBezierPath(rect: layer.bounds)
        bounds.append(UIBezierPath(ovalIn: insetRect))
        mask.path = bounds.cgPath

        if !isInactiveHollow {
            layer.backgroundColor = inactiveColor.cgColor
            let backgroundLayer = CALayer()
            backgroundLayer.frame = layer.bounds
            backgroundLayer.backgroundColor = activeColor.cgColor
            backgroundLayer.cornerRadius = diameter * 0.5
            layer.addSublayer(backgroundLayer)
            backgroundLayer.mask = mask
        }else {
            layer.backgroundColor = activeColor.cgColor
            layer.mask = mask
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
        // set new layers
        for _ in 0..<numberOfPages {
            let layer = CALayer()
            contentView.layer.addSublayer(layer)
            inactiveLayer.append(layer)
        }
    }
    
    func resetActiveLayer() {}
    
    // MARK: - -------------------------- Layout --------------------------
    private func layoutContentView() {
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        var width = kMinContentSize.width
        var height = kMinContentSize.height
        
        if diameter > 0 {
            width = CGFloat(numberOfPages) * (diameter + columnSpacing) - columnSpacing
            height = diameter
        }
        
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
        var layerFrame = CGRect(x: 0,
                                y: 0,
                                width: diameter,
                                height: diameter)
        inactiveLayer.forEach() { layer in
            layer.cornerRadius = diameter * 0.5
            layer.frame = layerFrame
            layerFrame.origin.x +=  diameter + columnSpacing
        }
    }
}
