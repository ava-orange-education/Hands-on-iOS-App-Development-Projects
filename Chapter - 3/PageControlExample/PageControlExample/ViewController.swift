//
//  ViewController.swift
//  PageControlExample
//
//  Created by Aiswarya Kodali on 2/9/2023.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var screenWidth : CGFloat = UIScreen.main.bounds.size.width
    var screenHeight : CGFloat = UIScreen.main.bounds.size.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView?.contentSize = CGSizeMake((screenWidth * 3), (screenWidth * 0.67))
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        
        for i in 0...2 {
            let contentView = UIView()
            contentView.frame = CGRect(x: screenWidth * CGFloat (i), y: 0, width: screenWidth,height: screenHeight)
            if i == 0 {
                contentView.backgroundColor = UIColor.green
            }
            
            if i == 1 {
                contentView.backgroundColor = UIColor.blue
            }
            
            if i == 2 {
                contentView.backgroundColor = UIColor.red
            }
            scrollView?.addSubview(contentView)
        }

    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        setIndiactorForCurrentPage()
    }

    func setIndiactorForCurrentPage()  {
        let page = (scrollView.contentOffset.x)/screenWidth
        pageControl.currentPage = Int(page)
    }

}

