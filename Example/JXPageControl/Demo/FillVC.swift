//
//  FillVC.swift
//  JXPageControl_Example
//
//  Created by 谭家祥 on 2019/7/13.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import JXPageControl

class FillVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var `default`: JXPageControlFill!
    @IBOutlet weak var inactiveHollow: JXPageControlFill!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
    }
    
    deinit {
        print("\(#function ) --> \(#file)")
    }
    
}

extension FillVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let progress = scrollView.contentOffset.x / scrollView.bounds.width
//        let currentPage = Int(round(progress))
        
        // 方式一
        `default`.progress = progress
        inactiveHollow.progress = progress

        // 方式二
//        `default`.currentPage = currentPage
//        inactiveHollow.currentPage = currentPage
        
        
    }
    
}

