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
    
    let kingfisherSource = [KingfisherSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080")!, KingfisherSource(urlString: "https://images.unsplash.com/photo-1447746249824-4be4e1b76d66?w=1080")!, KingfisherSource(urlString: "https://images.unsplash.com/photo-1463595373836-6e0b0a8ee322?w=1080")!]
    
    enum Action {
        case updateInterval(String?)
        case startSlide
        case stopSlide
    }
    
    enum Mutation {
        case setInterval(Double)
        case showSlideView
        case hiddenSlideView
        case setImages([FlickrItem])
        case appendImages([FlickrItem])
        case setLoadingNextPage(Bool)
    }
    
    struct State {
        var interval : Double?
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
            let str = interval ?? "0"
            let intervarlDouble = Double(str) ?? 0
            return Observable.just(Mutation.setInterval(intervarlDouble))
        case .startSlide:
            return Observable.concat([
                    Observable.just(Mutation.showSlideView),
                    
                    self.service.getPhotos()
                        .debug()
                        .map {
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
                let source = KingfisherSource(urlString: item.media["m"]!)
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
