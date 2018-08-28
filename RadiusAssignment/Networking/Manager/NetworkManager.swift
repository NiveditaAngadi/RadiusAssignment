//
//  NetworkManager.swift
//  RadiusAssignment
//
//  Created by Nivedita on 25/08/18.
//  Copyright © 2018 RadiusAssignment. All rights reserved.
//

import Foundation


enum NetwokEnvironment {
    case qa
    case production
    case staging
}


enum NetworkResponse:String {
    case success
    case authenticationError = "Authentication is required."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success
    case failure(String)
}


struct NetworkManager {
    //You can set different environment as per the testing and release schedule.
    static let environment: NetwokEnvironment = .staging
    
    func fetchFacilitiesAndOptions(completion: @escaping (_ response:FacilityAndOptionsApiResponse?,_ error:String?)->()) {
        let router = Router<FacilitiesAndOptionsApi>()
        router.request(.facilitiesAndOptionsListApi) { data, response, error in
            if error != nil  {
                completion(nil, "Please check your network connection")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        let facilityOptionsObject = FacilityAndOptionsApiResponse.init(jsonData as? [String : AnyObject])
                        completion(facilityOptionsObject,nil)
                    } catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }

    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
}


