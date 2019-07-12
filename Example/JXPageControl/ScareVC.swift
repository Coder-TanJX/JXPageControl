//
//  ScareVC.swift
//  JXPageControl_Example
//
//  Created by 谭家祥 on 2019/7/12.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class ScareVC: UIViewController {


    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var `default`: JXPageControlScale!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
    }
    
}

extension ScareVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let progress = scrollView.contentOffset.x / scrollView.bounds.width
        let currentPage = Int(round(progress))
        
        // 方式一
//        `default`.progress = progress
//        NoFlexble.progress = progress
//        NoAnimation.progress = progress
//        NoAnimationAndFlexble.progress = progress
//        inactiveHollow.progress = progress
//        activeHollow.progress = progress
//        allHollow.progress = progress
//        smallActive.progress = progress
//        line.progress = progress
//        boldLine.progress = progress
//        ellipse.progress = progress
        
        // 方式二
                `default`.currentPage = currentPage
        //        NoFlexble.currentPage = currentPage
        //        NoAnimation.currentPage = currentPage
        //        NoAnimationAndFlexble.currentPage = currentPage
        //        inactiveHollow.currentPage = currentPage
        //        activeHollow.currentPage = currentPage
        //        allHollow.currentPage = currentPage
        //        smallActive.currentPage = currentPage
        //        line.currentPage = currentPage
        //        boldLine.currentPage = currentPage
        //        ellipse.currentPage = currentPage
        
        
        
    }
    
}

