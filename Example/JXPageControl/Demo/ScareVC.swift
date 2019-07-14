//
//  ScareVC.swift
//  JXPageControl_Example
//
//  Created by 谭家祥 on 2019/7/12.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import JXPageControl

class ScareVC: UIViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var `default`: JXPageControlScale!
    @IBOutlet weak var inactivehollow: JXPageControlScale!
    @IBOutlet weak var allHollow: JXPageControlScale!
    @IBOutlet weak var toSmall: JXPageControlScale!
    @IBOutlet weak var toEllipe: JXPageControlScale!
    @IBOutlet weak var toCircle: JXPageControlScale!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self 
    }
    
    deinit {
        print("\(#function ) --> \(#file)")
    }
    
}

extension ScareVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let progress = scrollView.contentOffset.x / scrollView.bounds.width
        let currentPage = Int(round(progress))
        
        // 方式一
        `default`.progress = progress
        inactivehollow.progress = progress
        allHollow.progress = progress
        toSmall.progress = progress
        toEllipe.progress = progress
        toCircle.progress = progress

        
        // 方式二
//        `default`.currentPage = currentPage
//        inactivehollow.currentPage = currentPage
//        allHollow.currentPage = currentPage
//        toSmall.currentPage = currentPage
//        toEllipe.currentPage = currentPage
//        toCircle.currentPage = currentPage
        
        
    }
    
}

