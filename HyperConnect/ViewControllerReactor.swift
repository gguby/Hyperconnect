//
//  ViewControllerReactor.swift
//  HyperConnect
//
//  Created by wsjung on 2017. 12. 22..
//  Copyright © 2017년 wsjung. All rights reserved.
//

import UIKit
import ImageSlideshow
import ReactorKit
import RxCocoa
import RxSwift

final class ViewControllerReactor : Reactor {
    
    enum Action {
        case updateInterval(String?)
        case toggleSlide
        case nextPage(Int)
    }
    
    enum Mutation {
        case setInterval(Double)
        case toggleSlide(Bool)
        case setImages([FlickrItem])
        case appendImages([FlickrItem])
        case setLoadingNextPage(Bool)
        case nextPage(Int)
    }
    
    struct State {
        var interval : Double?
        var images : [KingfisherSource] = []
        var isShow : Bool = false
        var isLoadingNextPage : Bool = false
        var currenPage : Int = 0
        var btnText : String = "START"
    }
    
    let initialState = State()
    
    fileprivate let service : FlickrService
    
    init(service : FlickrService) {
        self.service = service
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateInterval(interval):
            let str = interval ?? "0"
            let intervarlDouble = Double(str) ?? 0
            return Observable.just(Mutation.setInterval(intervarlDouble))
        case .toggleSlide:
            let isShow = !self.currentState.isShow
            return Observable.concat([
                    Observable.just(Mutation.toggleSlide(isShow)),
                    
                    self.service.getPhotos()
                        .debug()
                        .map {
                            feed in
                            Mutation.setImages(feed.items)
                        },
                ])
        case let .nextPage(page):
            let imageCount = self.currentState.images.count
            if page == imageCount - 1 {
                return Observable.concat([
                    Observable.just(Mutation.setLoadingNextPage(true)),
                    
                    self.service.getPhotos()
                        .debug()
                        .map {
                            feed in
                            Mutation.appendImages(feed.items)
                    },
                    Observable.just(Mutation.setLoadingNextPage(false)),
                ])
            }
            
            return Observable.just(Mutation.nextPage(page))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setInterval(interval):
            newState.interval = interval
            return newState
        case let .toggleSlide(isShow):
            newState.isShow = isShow
            newState.btnText = isShow ? "STOP" : "START"
            return newState
        case let .setImages(items):
            var images : [KingfisherSource] = []
            for item in items {
                let source = KingfisherSource(urlString: item.media["m"]!)
                images.append(source!)
            }
            newState.images = images
            return newState
        case let .nextPage(page):
            newState.currenPage = page
            return newState
        case let .appendImages(items):
            for item in items {
                let source = KingfisherSource(urlString: item.media["m"]!)
                newState.images.append(source!)
            }
            return newState
        case let .setLoadingNextPage(isLoadingNextPage):
            newState.isLoadingNextPage = isLoadingNextPage
            return newState
        }
    }
}
