//
//  FlickrService.swift
//  HyperConnect
//
//  Created by wsjung on 2017. 12. 21..
//  Copyright © 2017년 wsjung. All rights reserved.
//

import Foundation
import Moya
import Mapper
import RxSwift
import RxOptional
import Moya_ModelMapper

struct FlickrFeed: Mappable {
    
    let title : String
    let link : String
    let items : [FlickrItem]
    
    init(map: Mapper) throws {
        try title = map.from("title")
        try link = map.from("link")
        try items = map.from("items")
    }
}

struct FlickrItem: Mappable {
    let title : String
    let link : String
    let media : [String:String]
    
    init(map: Mapper) throws {
        try title = map.from("title")
        try link = map.from("link")
        try media = map.from("media")
    }
}

struct FlickrService {
    let provider = MoyaProvider<Flickr>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    func getPhotos() -> Observable<FlickrFeed> {
        return self.provider.rx
            .request(Flickr.getPhotos)
            .map(to: FlickrFeed.self)
            .asObservable()
    } 
}
