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
    
    let slidePage = PublishSubject<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        slideView.backgroundColor = UIColor.white

        slideView.pageControlPosition = PageControlPosition.underScrollView
        slideView.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        slideView.pageControl.pageIndicatorTintColor = UIColor.black
        slideView.contentScaleMode = UIViewContentMode.scaleAspectFill
        slideView.circular = false
        
        slideView.activityIndicator = DefaultActivityIndicator()
        
        slideView.currentPageChanged = { [weak self] page in
            print("current page:", page)
            self?.slidePage.onNext(page)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func bind(reactor: ViewControllerReactor) {
        
        // Input
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapBackground)
        
        self.slidePage
            .map{ Reactor.Action.nextPage($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        self.textfield.rx
            .text.changed
            .map{ Reactor.Action.updateInterval($0) }
            .bind(to : reactor.action)
            .disposed(by :disposeBag)
        
        self.btnSlide.rx.tap
            .map{ Reactor.Action.toggleSlide }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // Output
        reactor.state.map { $0.isShow == false }
            .bind(to: self.slideView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.btnText }
            .bind(to: self.btnSlide.rx.title())
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.images }
            .bind(to: self.slideView.rx.imageBinder)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.interval ?? 0 }
            .bind(to: self.slideView.rx.slideInterval)
            .disposed(by: disposeBag)
        
        // error
        reactor.state.map {$0.errorText}
            .filter { $0?.isEmpty == false }
            .subscribe(onNext: { [weak self] text in
                let actionSheet = UIAlertController(title: text, message: nil, preferredStyle: .actionSheet)
                let ok = UIAlertAction(title: "Ok", style: .default) { _ in
                    reactor.action.onNext(.updateInterval(nil))
                    self?.textfield.text = "0"
                }
                actionSheet.addAction(ok)
                self?.present(actionSheet, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

