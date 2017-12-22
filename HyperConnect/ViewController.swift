//
//  ViewController.swift
//  HyperConnect
//
//  Created by wsjung on 2017. 12. 21..
//  Copyright © 2017년 wsjung. All rights reserved.
//

import UIKit
import ImageSlideshow
import RxCocoa
import RxSwift
import ReactorKit

class ViewController: UIViewController, StoryboardView {
    
    typealias Reactor = ViewControllerReactor
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var slideView: ImageSlideshow!
    @IBOutlet weak var btnSlide: UIButton!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        slideView.backgroundColor = UIColor.white
        
        slideView.pageControlPosition = PageControlPosition.underScrollView
        slideView.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        slideView.pageControl.pageIndicatorTintColor = UIColor.black
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func bind(reactor: ViewControllerReactor) {

    }
}

