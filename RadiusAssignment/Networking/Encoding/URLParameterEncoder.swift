//
//  URLParameterEncoder.swift
//  RadiusAssignment
//
//  Created by Nivedita on 25/08/18.
//  Copyright © 2018 RadiusAssignment. All rights reserved.
//

import Foundation

public struct URLParameterEncoder: ParameterEncoder {
    
    public static func encode(urlRequest: inout URLRequest, with paramters: Parameters) throws {
        guard let url = urlRequest.url else {throw NetworkError.missingURL}
        
        if var urlComponents = URLComponents(url: url,
                                             resolvingAgainstBaseURL: false), !paramters.isEmpty {
            
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key, value) in paramters {
                
                let queryItem = URLQueryItem(name: key,
                                             value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }
        
        if (urlRequest.value(forHTTPHeaderField: "Content-Type") == nil) {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}
