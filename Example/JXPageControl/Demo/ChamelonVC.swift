//
//  ChamelonVC.swift
//  JXPageControl_Example
//
//  Created by 谭家祥 on 2019/7/13.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import JXPageControl

class ChamelonVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var `default`: JXPageControlChameleon!
    @IBOutlet weak var inactivehollow: JXPageControlChameleon!
    
    lazy var codePageControl: JXPageControlJump = {
        let pageControl = JXPageControlJump(frame: CGRect(x: 0,
                                                          y: 0,
                                                          width: UIScreen.main.bounds.width,
                                                          height: 30))
        pageControl.numberOfPages = 4
        
        // JXPageControlType: default property
//        pageControl.currentPage = 0
//        pageControl.progress = 0.0
//        pageControl.hidesForSinglePage = false
//        pageControl.inactiveColor = UIColor.white.withAlphaComponent(0.5)
//        pageControl.activeColor = UIColor.white
//        pageControl.inactiveSize = CGSize(width: 10, height: 10)
//        pageControl.activeSize = CGSize(width: 10, height: 10)
//        pageControl.inactiveSize = CGSize(width: 10, height: 10)
//        pageControl.columnSpacing = 10
//        pageControl.contentAlignment = JXPageControlAlignment(.center,
//                                                              .center)
//        pageControl.contentMode = .center
//        pageControl.isInactiveHollow = false
//        pageControl.isActiveHollow = false
        
        // JXPageControlJump: default "custom property"
        pageControl.isAnimation  = true
        
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(codePageControl)
        scrollView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        codePageControl.center = view.center
    }
    
    deinit {
        print("\(#function ) --> \(#file)")
    }
    
}

extension ChamelonVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let progress = scrollView.contentOffset.x / scrollView.bounds.width
        let currentPage = Int(round(progress))
        
        // 方式一
        `default`.progress = progress
        inactivehollow.progress = progress
        codePageControl.progress = progress
        
        // 方式二
//        `default`.currentPage = currentPage
//        inactivehollow.currentPage = currentPage
//        codePageControl.currentPagev = currentPage
        
        
    }
    
}


