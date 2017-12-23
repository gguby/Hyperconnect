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
    
    public var slideInterval : Binder<Double> {
        return Binder(self.base) { view , interval in
            view.slideshowInterval = interval
        }
    }

    public var currentPage : Binder<Int> {
        return Binder(self.base) { view , currentPage in
            view.pageControl.currentPage = currentPage
        }
    }
    
    public var imageBinder : Binder<[InputSource]> {
        return Binder(self.base) { view , images in
            view.setImageInputs(images)
        }
    }
}

extension ImageSlideshow {

}
