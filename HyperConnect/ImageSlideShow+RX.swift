//
//  ImageSlideShow+RX.swift
//  HyperConnect
//
//  Created by wsjung on 2017. 12. 22..
//  Copyright © 2017년 wsjung. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ImageSlideshow

extension Reactive where Base: ImageSlideshow {

    public var currentPage : Binder<Int> {
        return Binder(self.base) { view , currentPage in
            view.pageControl.currentPage = currentPage
        }
    }
}

extension ImageSlideshow {

}
