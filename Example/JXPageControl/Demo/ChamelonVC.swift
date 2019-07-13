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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
    }
    
}

extension ChamelonVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let progress = scrollView.contentOffset.x / scrollView.bounds.width
        let currentPage = Int(round(progress))
        
        // 方式一
        `default`.progress = progress
        inactivehollow.progress = progress
        
        
        // 方式二
//        `default`.currentPage = currentPage
//        inactivehollow.currentPage = currentPage
        
        
    }
    
}


