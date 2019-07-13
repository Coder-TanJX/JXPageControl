//
//  ExchangeVC.swift
//  JXPageControl_Example
//
//  Created by 谭家祥 on 2019/7/13.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import JXPageControl

class ExchangeVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var `default`: JXPageControlExchange!
    @IBOutlet weak var inactivehollow: JXPageControlExchange!
    @IBOutlet weak var activehollow: JXPageControlExchange!
    @IBOutlet weak var allHollow: JXPageControlExchange!
    
    @IBOutlet weak var toEllipe: JXPageControlExchange!
    @IBOutlet weak var toCircle: JXPageControlExchange!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
    }
    
}

extension ExchangeVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let progress = scrollView.contentOffset.x / scrollView.bounds.width
        let currentPage = Int(round(progress))
        
        // 方式一
        `default`.progress = progress
        inactivehollow.progress = progress
        activehollow.progress = progress
        allHollow.progress = progress
        toEllipe.progress = progress
        toCircle.progress = progress
        
        
        // 方式二
//        `default`.currentPage = currentPage
//        inactivehollow.currentPage = currentPage
//        activehollow.currentPage = currentPage
//        allHollow.currentPage = currentPage
//        toEllipe.currentPage = currentPage
//        toCircle.currentPage = currentPage
        
        
    }
    
}


