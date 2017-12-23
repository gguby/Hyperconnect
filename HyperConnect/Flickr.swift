//
//  FlickrAPI.swift
//  HyperConnect
//
//  Created by wsjung on 2017. 12. 21..
//  Copyright © 2017년 wsjung. All rights reserved.
//

import Foundation
import Moya

private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

enum Flickr {
    case getPhotos
}

extension Flickr : TargetType {
    var baseURL: URL {
        return URL(string: "https://api.flickr.com/")!
    }
    
    var path: String {
        switch self {
        case .getPhotos:
            return "services/feeds/photos_public.gne"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getPhotos:
            return .requestParameters(parameters: ["format" : "json", "nojsoncallback" : 1], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}


