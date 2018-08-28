//
//  HTTPTask.swift
//  RadiusAssignment
//
//  Created by Nivedita on 25/08/18.
//  Copyright © 2018 RadiusAssignment. All rights reserved.
//

import Foundation


public typealias HTTPHeaders = [String:String]

public enum HTTPTask {
    
    case request
    
    case requestParameters (bodyParameters: Parameters?, urlParameters: Parameters?)
    
    case reqeustParametersAndHeaders(bodyParameters: Parameters?, urlParamters: Parameters?, additionHeaders: HTTPHeaders?)
    
}
