//
//  EndPointType.swift
//  RadiusAssignment
//
//  Created by Nivedita on 25/08/18.
//  Copyright © 2018 RadiusAssignment. All rights reserved.
//

import Foundation

protocol EndPointType {
    //Based on the project -> set the base URL, in this project we have only one api to intergrate as of now. so base URL need not to set now.
    //var baseURL: URL { get }
    var path: String { get }
    var urlPath: URL { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get } 
    
    
}
