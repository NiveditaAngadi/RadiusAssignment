//
//  JSONParamterEncoder.swift
//  RadiusAssignment
//
//  Created by Nivedita on 25/08/18.
//  Copyright © 2018 RadiusAssignment. All rights reserved.
//

import Foundation


public struct JSONParameterEncoder: ParameterEncoder {
    
    public static func encode(urlRequest: inout URLRequest, with paramters: Parameters) throws {
        do {
            
            let jsonAsData = try JSONSerialization.data(withJSONObject: paramters, options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
            if (urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)  {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }
        catch {
            throw NetworkError.encodingFailed
        }
    }
}
