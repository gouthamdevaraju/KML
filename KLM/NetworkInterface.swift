//
//  NetworkInterface.swift
//  KLM
//
//  Created by Goutham Devaraju on 04/03/20.
//  Copyright © 2020 Goutham. All rights reserved.
//

import Foundation

struct RequestConstants {
    static let BaseURL = "https://gist.githubusercontent.com/"
}

let CONTENTTYPE = "Content-Type"
let APPLICATION_JSON = "application/json"
let FORM_URL_ENCODE =  "application/x-www-form-urlencoded"
let ACCEPT =  "Accept"
let XREQUESTID = "X-RequestId"

enum DataErrors : Error {
    case invalidJSONData
    case dataParseError
    case noData
}

enum NetworkError : Error {
    case httpStatus201
    case httpStatus204
    case httpStatus400
    case httpStatus404
    case httpStatus410
    case httpStatusUnknownError
}

enum RequestType {
    case get_flight_details
}

class NetworkRequests {
    
    static func BaseURL() -> String {
        let baseURL = RequestConstants.BaseURL
        return baseURL
    }
    
    //MARK: - GET Requests
    static func getRequestofType(_ requestType:RequestType, headers:NSDictionary?,  urlParams:NSDictionary?) -> URLRequest {
        
        var request:URLRequest!
        
        switch requestType {
            
        case .get_flight_details:
            let path = "tdreyno/4278655/raw/7b0762c09b519f40397e4c3e100b097d861f5588/airports.json"
            let endpoint = RequestConstants.BaseURL + path
            request = self.createGETRequest(endpoint, headers: headers, urlParams: urlParams)
            break
            //        default:
            //            break
        }
        
        return request
    }
    
    static func createGETRequest(_ baseURL:String , headers:NSDictionary?, urlParams:NSDictionary?) -> URLRequest {
        
        var headerAsString:String = ""
        
        if (urlParams != nil && urlParams!.count > 0) {
            
            for (_,value) in urlParams! {
                headerAsString += value as! String
            }
        }
        
        let fullUrlString = baseURL + headerAsString;
        let urlPath = NSString(format: fullUrlString as NSString).addingPercentEscapes(using: String.Encoding.utf8.rawValue)!
        let url = URL(string: urlPath)
        let request = NSMutableURLRequest(url: url!)
        print(fullUrlString)
        print(headers!)
        
        if headers != nil {
            for (key,value) in headers! {
                request.addValue(value as! String, forHTTPHeaderField: key as! String)
            }
        }
        request.httpMethod = "GET"
        request.timeoutInterval = 60
        request.httpShouldHandleCookies=false
        return request as URLRequest
    }
    
    
    
    //Commenting out post requests for now
    
    //MARK: - POST Requests
//    static func postRequestofType(_ requestType:RequestType ,headers:NSDictionary?, urlParams:NSDictionary?, payload :[String:Any]? ) -> URLRequest {
//
//        var request:URLRequest!
//
//        switch requestType {
//
//        case .post_flight_details:
//            let authPath = "tdreyno/4278655/raw/7b0762c09b519f40397e4c3e100b097d861f5588/airports.json"
//            let endpoint = RequestConstants.BaseURL + authPath
//            request = self.createPOSTRequest(endpoint, headers: headers,urlParams: urlParams, payload: payload!)
//            break
//
//            //        default:
//            //            break
//        }
//        return request
//    }
//
//
//    static func createPOSTRequest(_ baseURL:String ,headers:NSDictionary?,urlParams: NSDictionary?, payload:[String:Any]) -> URLRequest {
//
//        var headerAsString:String = ""
//
//        if (urlParams != nil && urlParams!.count > 0) {
//            for (key,_) in urlParams! {
//                headerAsString += key as! String
//            }
//        }
//
//        let fullUrlString = baseURL + headerAsString;
//        let url = URL(string: fullUrlString)
//        let request = NSMutableURLRequest(url: url!)
//
//        if headers != nil {
//            for (key,value) in headers! {
//                request.addValue(value as! String, forHTTPHeaderField: key as! String)
//            }
//        }
//
//        do{
//            let data = try JSONSerialization.data(withJSONObject: payload, options: [])
//            let post = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
//            request.httpBody = post.data(using: String.Encoding.utf8);
//        }catch {
//            print("json error: \(error)")
//        }
//
//        request.httpMethod = "POST"
//        request.timeoutInterval = 80
//        request.httpShouldHandleCookies=false
//
//        return request as URLRequest
//    }
    
    
    
}


typealias RequestCompletionType = (Bool, Data?, HTTPURLResponse?, Error?, [AnyHashable:Any]?) -> (Void)

class NetworkInterface: NSObject {
    
    static func getRequest(_ requestType:RequestType , headers:NSDictionary? = [:], params:NSDictionary? = [:], requestCompletionHander:@escaping RequestCompletionType) -> URLSessionDataTask {
        
        return self.sendAsyncRequest(NetworkRequests.getRequestofType(requestType, headers: headers, urlParams: params)) { (success, data, response, error, headers) -> (Void) in
            
            if (success == true && response != nil) {
                
                let httpResponse: HTTPURLResponse = response!
                let httpStatusCode = httpResponse.statusCode
                
                switch httpStatusCode {
                    
                case 200:
                    let succcess = (data != nil)
                    if (succcess) {
                        requestCompletionHander(succcess, data, response, nil, httpResponse.allHeaderFields)
                    } else {
                        requestCompletionHander(false, nil, response , DataErrors.invalidJSONData, httpResponse.allHeaderFields)
                    }
                    break
                case 204:
                    requestCompletionHander(false, nil, response, NetworkError.httpStatus204, httpResponse.allHeaderFields)
                    break
                case 404:
                    requestCompletionHander(false,nil,response, NetworkError.httpStatus404, httpResponse.allHeaderFields)
                    break
                case 410:
                    requestCompletionHander(false, nil, response, NetworkError.httpStatus410, httpResponse.allHeaderFields)
                    break
                default:
                    requestCompletionHander(false,nil,response,NetworkError.httpStatusUnknownError, httpResponse.allHeaderFields)
                    break
                }
            }
            else {
                requestCompletionHander(false,nil,response,error, nil)
            }
        }
    }
    
    
    //Commenting out post requests for now
    
//    static func postRequest(_ requestType: RequestType, headers: NSDictionary? = [:], params: NSDictionary? = [:],  payload :[String:Any], requestCompletionHander:@escaping RequestCompletionType) -> URLSessionDataTask{
//
//        return self.sendAsyncRequest(NetworkRequests.postRequestofType(requestType, headers: headers, urlParams:params, payload: payload  ), completionHandler: { (success, json, response, error, headers) -> (Void) in
//
//            if (success == true && response != nil) {
//
//                let httpResponse: HTTPURLResponse = response!
//                let httpStatusCode = httpResponse.statusCode
//
//                switch httpStatusCode {
//
//                case 200:
//                    let succcess = (json != nil)
//                    if (succcess) {
//                        requestCompletionHander(succcess, json, response, nil, httpResponse.allHeaderFields)
//                    } else {
//                        requestCompletionHander(false, nil, response , DataErrors.invalidJSONData, httpResponse.allHeaderFields)
//                    }
//                    break
//                case 204:
//                    requestCompletionHander(false, nil, response, NetworkError.httpStatus204, httpResponse.allHeaderFields)
//                    break
//                case 404:
//                    requestCompletionHander(false,nil,response, NetworkError.httpStatus404, httpResponse.allHeaderFields)
//                    break
//                case 410:
//                    requestCompletionHander(false, nil, response, NetworkError.httpStatus410, httpResponse.allHeaderFields)
//                    break
//                default:
//                    requestCompletionHander(false,nil,response,NetworkError.httpStatusUnknownError, httpResponse.allHeaderFields)
//                    break
//                }
//            }
//            else {
//                requestCompletionHander(false,nil,response,error, nil)
//            }
//
//        })
//    }
    
    
    static fileprivate func sendAsyncRequest(_ request:URLRequest, completionHandler:@escaping RequestCompletionType) -> URLSessionDataTask{
        
        let task = URLSession.shared.dataTask(with: request) { ( data_,response, error) in
            
            DispatchQueue.main.async {
                
                guard let data = data_, let httpUrlResponse = response as? HTTPURLResponse else {
                    completionHandler(false, nil, nil, DataErrors.invalidJSONData, nil)
                    return
                }
                
                completionHandler(true, data, httpUrlResponse, nil, httpUrlResponse.allHeaderFields)
            }
        }
        
        task.resume()
        return task
    }
}

import UIKit

//let modelName = UIDevice.modelName
public extension UIDevice {

    static let phoneModelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod touch (5th generation)"
            case "iPod7,1":                                 return "iPod touch (6th generation)"
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2", "iPhone5,3", "iPhone5,4", "iPhone6,1", "iPhone6,2":                 return "iPhone 5"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()

}
