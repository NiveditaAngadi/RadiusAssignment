//
//  FacilitiesOptionsEndPoint.swift
//  RadiusAssignment
//
//  Created by Nivedita on 25/08/18.
//  Copyright © 2018 RadiusAssignment. All rights reserved.
//

import Foundation

//Created enum for the list of related api's of facilities and options. As of now we have only one api to intergrate. Can be added list of other cases like recommended facilities, top listed facilities etc
public enum FacilitiesAndOptionsApi {
    case facilitiesAndOptionsListApi
}



extension FacilitiesAndOptionsApi: EndPointType {
    
    var path: String {
        switch self {
        case .facilitiesAndOptionsListApi:
            return "https://my-json-server.typicode.com/iranjith4/ad-assignment/db"
        }
    }
    var urlPath: URL {
            guard let url = URL(string: self.path) else { fatalError("URL could not be configured.")}
            return url
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch  self {
        case .facilitiesAndOptionsListApi:
           return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
