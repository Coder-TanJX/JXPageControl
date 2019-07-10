//
//  ViewController.swift
//  JXPageControl
//
//  Created by bboyXFX on 06/07/2019.
//  Copyright (c) 2019 bboyXFX. All rights reserved.
//

import UIKit
import JXPageControl

class ViewController: UIViewController {
    
  
    @IBOutlet weak var jump: JXPageControlJump!
    @IBOutlet weak var line: JXPageControlLine!
    @IBOutlet weak var boldLine: JXPageControlBoldLine!
    @IBOutlet weak var ellipse: JXPageControlEllipse!
    @IBOutlet weak var fill: JXPageControlFill!
    @IBOutlet weak var scare: JXPageControlScale!
    @IBOutlet weak var exchange: JXPageControlExchange!
    @IBOutlet weak var system: JXPageControlChameleon!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let jumpCode: JXPageControlJump = JXPageControlJump(frame: CGRect(x: 100, y: 450, width: 200, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        scrollView.isPagingEnabled = true

        view.addSubview(jump)
        jumpCode.numberOfPages = 3

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Update scroll view content size.
        let contentSize = CGSize(width: scrollView.bounds.width * 4,
                                 height: scrollView.bounds.height)
        scrollView.contentSize = contentSize
    }
}


// MARK: - Scroll View Delegate

var tempIndex = 10000

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.bounds.width
//        let progressInPage = scrollView.contentOffset.x - (page * scrollView.bounds.width)
//        let currentPage = Int(CGFloat(page) + progressInPage)
        let currentPage = Int(round(page))
//        let progress = CGFloat(page) + progressInPage
        let progress = page
//        print(progress)
        jump.progress = progress
        line.progress = progress
        boldLine.progress = progress
        ellipse.progress = progress
        fill.progress = progress
        scare.progress = progress
        jumpCode.progress = progress
//        exchange.progress = progress
//        system.progress = progress
//        print(progress)
        if tempIndex != currentPage {
            tempIndex = currentPage
//            jump.currentPage = currentPage
//            line.currentPage = currentPage
//            boldLine.currentPage = currentPage
//            ellipse.currentPage = currentPage
//            fill.currentPage = currentPage
//            scare.currentPage = currentPage
//            jumpCode.currentPage = currentPage
            exchange.currentPage = currentPage
//            system.currentPage = currentPage
        }
        
        

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        jumpCode.contentAlignment = JXPageControlAlignment(horizon: .right,
//                                                       vertical: .center)
//        jump.progress = 3
//        line.progress = 3
//        boldLine.progress = 3
//        ellipse.progress = 3
//        fill.progress = 3
//        scare.progress = 3
//        jumpCode.progress = 3
//        exchange.progress = 3
//        system.progress = 3
//        scrollView.contentOffset.x = scrollView.bounds.width * 3
//        scrollView.delegate = self
        
        
//        jump.currentPage = 3
//        line.currentPage = 3
//        boldLine.currentPage = 3
//        ellipse.currentPage = 3
        fill.currentPage = 3
        scare.currentPage = 3
//        jumpCode.progress = 3
        exchange.currentPage = 3
//        system.progress = 3
        scrollView.contentOffset.x = scrollView.bounds.width * 3
        scrollView.delegate = self
        
    }
}


