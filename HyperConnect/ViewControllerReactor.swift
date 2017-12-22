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
        case updateInterval(Int)
        case startSlide
        case stopSlide
    }
    
    enum Mutation {
        case setInterval(Int)
        case showSlideView
        case hiddenSlideView
        case setImages([FlickrItem])
        case appendImages([FlickrItem])
        case setLoadingNextPage(Bool)
    }
    
    struct State {
        var interval : Int?
        var images : [KingfisherSource] = []
        var isShow : Bool = false
        var isLoadingNextPage : Bool = false
    }
    
    let initialState = State()
    
    fileprivate let service : FlickrService
    
    init(service : FlickrService) {
        self.service = service
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateInterval(interval):
            return Observable.just(Mutation.setInterval(interval))
        case .startSlide:
            return Observable.concat([
                    Observable.just(Mutation.showSlideView),
                    
                    self.service.getPhotos()
                        .debug()
                        .map{
                            feed in
                            Mutation.setImages(feed.items)
                        },
                ])
            
        case .stopSlide:
            return Observable.just(Mutation.hiddenSlideView)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setInterval(interval):
            var newState = state
            newState.interval = interval
            return newState
        case .showSlideView:
            var newState = state
            newState.isShow = true
            return newState
        case .hiddenSlideView:
            var newState = state
            newState.isShow = false
            return newState
        case let .setImages(items):
            var newState = state
            var images : [KingfisherSource] = []
            for item in items {
                let source = KingfisherSource(urlString: item.link)
                images.append(source!)
            }
            newState.images = images
            return newState
        case let .appendImages(items):
            var newState = state
            for item in items {
                let source = KingfisherSource(urlString: item.link)
                newState.images.append(source!)
            }
            return newState
        case let .setLoadingNextPage(isLoadingNextPage):
            var newState = state
            newState.isLoadingNextPage = isLoadingNextPage
            return newState
        }
    }
    
}
