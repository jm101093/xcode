    //
//  AlamofireAPIWrapper.swift
//
//
//  Created by Bitcot Inc on 08/12/15 ----  Updated by California Exposure 2019
//  Copyright © 2015 Bitcot. All rights reserved.
//
// Bitcot really needs to learn how to COMMENT THEIR DAMNED CODE

import UIKit
import Alamofire

let baseURL = "https://mrcitation.com/"
let versionURL = "api/v1/"

class AlamofireAPIWrapper: NSObject {
    
    static let sharedInstance = AlamofireAPIWrapper()
    private let loggedInUser = LoggedInUser.sharedInstance
    
    var authHeaders:[String:String]{
        get{
            return ["X-User-Token":loggedInUser.authToken,"X-User-Email":loggedInUser.email!, "Content-Type":"application/json","Accept":"application/json"]
        }
    }

    var additionalHeaders:[String:String]{
        get{
            return ["Content-Type":"application/json","Accept":"application/json"]
        }
    }
    
    func syncDeviceToken(requestDict:[String:AnyObject],responseBlock:@escaping CompletionBlock) {
        let urlString = "auth.php"
        let header = additionalHeaders
        Alamofire.request(baseURL + urlString, method: .post, parameters: requestDict, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: {(response) -> Void in
            if let error = response.result.error {
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.result.value {
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        })
    }
    
    //MARK: - User Login / Signup
    func userSignUp(params:[String:AnyObject],responseBlock:@escaping CompletionBlock) {
        let urlString = "auth.php"
        let header = additionalHeaders
        Alamofire.request(baseURL + urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: {(response) -> Void in
            if let error = response.result.error {
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.result.value {
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        })
    }
    
    func userSignIn(requestDict:[String:AnyObject],responseBlock:@escaping CompletionBlock) {
        let urlString = "auth.php"
        let header = additionalHeaders
        print(baseURL+urlString)
        print(requestDict.description)
        Alamofire.request(baseURL + urlString, method: .post, parameters: requestDict, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: {(response) -> Void in
            if let error = response.result.error {
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.result.value {
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        })
    }
    
    func forgotPassword(requestDict:[String:AnyObject], responseBlock:@escaping CompletionBlock) {
        let urlString = "auth.php"
        let header = additionalHeaders
        Alamofire.request(baseURL + urlString, method:.post, parameters: requestDict, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: {(response) -> Void in
            print(response.request)
            print(response.response)
            if let error = response.result.error {
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.result.value {
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        })
    }
    
    func resetPassword(requestDict:[String:AnyObject],responseBlock:@escaping CompletionBlock) {
        let urlString = "users/password"
        let header = additionalHeaders
        Alamofire.request(baseURL + urlString, method:.put, parameters: requestDict, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: {(response) -> Void in
            print(response.request)
            print(response.response)
            if let error = response.result.error {
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.result.value {
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        })
    }
    
    func updateUserProfile(profileImage:UIImage?, requestDict:[String:AnyObject], responseBlock:@escaping CompletionBlock) {
        let urlString = "users"
        let header = authHeaders
        
        var URL = try! URLRequest(url: baseURL+urlString, method: .put, headers: header)
        URL.timeoutInterval = 2400
        let currentMillis = NSDate().timeIntervalSince1970
        
        Alamofire.upload(multipartFormData: {(multipartFormData) in
            if let _ = profileImage{
                let imageData = UIImageJPEGRepresentation(profileImage!, 0.2)
                multipartFormData.append(imageData!, withName: "user[photo]", fileName: "\(currentMillis)" + ".jpg", mimeType: "image/jpeg")
            }
            
            for(key,value) in requestDict{
                print("key:\(key),value:\(value)")
                
                if let _ = value as? [AnyObject] {
                    for element in value as! [Int]{
                        let stringValue = element.description
                        multipartFormData.append(stringValue.data(using: String.Encoding.utf8)!, withName: "user[\(key)][]")
                    }
                }else if let value = value as? [String:AnyObject]{
                    if let last_location_attributes = value["last_location_attributes"] as? [String:AnyObject]{
                        for(subkey,subvalue) in last_location_attributes{
                            let subVal = subvalue as! NSNumber
                            let floatVal = subVal.doubleValue
                            multipartFormData.append("\(floatVal)".data(using: String.Encoding.utf8)!, withName: "user[last_location_attributes][\(subkey)]")
                        }
                    }else if  "address" == key{
                        for(subkey,subvalue) in value as [String:AnyObject]{
                            if subkey.contains("latitude") || subkey.contains("longitude") {
                                let subVal = subvalue as! NSNumber
                                let floatVal = subVal.doubleValue
                                multipartFormData.append("\(floatVal)".data(using: String.Encoding.utf8)!, withName: "user[address][\(subkey)]")
                            }else{
                                let subVal = subvalue as! String
                                multipartFormData.append(subVal.data(using: String.Encoding.utf8)!, withName: "user[address][\(subkey)]")
                            }
                        }
                    }
                }
                else {
                    multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: "user[\(key)]")
                }
            }
        }, with: URL, encodingCompletion: { (result) in
            
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress {progress in
                    print(progress.fractionCompleted)
                }
                
                upload.responseJSON { response in
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                    }
                    DispatchQueue.main.async {
                        let apiResponse = AlamofireAPIResponse.init(response: response.result.value as JSON?, errorCode: 0, errorMessage: "Profile Updated Successfully", successful: true)
                        responseBlock(apiResponse)
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: 1, errorMessage: "Couldn't update Profile", successful: false)
                responseBlock(apiResponse)
            }
        })
    }
    
    func fetchMediaURLs(request:JSONDictionary , sessionID:Int, responseBlock:@escaping CompletionBlock){
        let urlString = "media_url"
        let header = authHeaders
        Alamofire.request(baseURL + versionURL + urlString, method: .put, parameters: request, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if let error = response.result.error{
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.result.value{
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        }
    }
    
    func uploadImage(uploadURL:URL,
                     image:UIImage,
                     responseBlock:@escaping CompletionBlock) {
        
        let headers = [
            "cache-control": "no-cache",
            ]
        
        let imageData = UIImageJPEGRepresentation(image, 0.5)

        let request = NSMutableURLRequest(url: uploadURL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 2400.0)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let dataTask = session.uploadTask(with: request as URLRequest, from: imageData!, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error ?? "")
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: 1, errorMessage: "Couldn't upload", successful: false)
                responseBlock(apiResponse)
                
            }else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse ?? "")
                print(httpResponse?.statusCode)
                if httpResponse!.statusCode == 200{
                    let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: 0, errorMessage: "", successful: true)
                    responseBlock(apiResponse)
                }else{
                    let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: 0, errorMessage: "Couldn't upload", successful: false)
                    responseBlock(apiResponse)
                }
                //                httpResponse.reps
            }
        })
        dataTask.resume()
        
    }

    func uploadVideo(uploadURL:URL,
                     videoFilePath:URL?,
                     responseBlock:@escaping CompletionBlock) {
        
        let headers = [
            "cache-control": "no-cache",
        ]
        
        let request = NSMutableURLRequest(url: uploadURL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 2400.0)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let dataTask = session.uploadTask(with: request as URLRequest, fromFile: videoFilePath!, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error ?? "")
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: 1, errorMessage: "Couldn't upload", successful: false)
                responseBlock(apiResponse)

            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse ?? "")
//                httpResponse.reps
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        })
        dataTask.resume()
    }
    
    func updateUploadedMediaURLs(request:JSONDictionary , sessionID:Int, responseBlock:@escaping CompletionBlock){
        let urlString = ""
        let header = authHeaders
        Alamofire.request(baseURL + versionURL + urlString, method: .post, parameters: request, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if let error = response.result.error{
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.result.value{
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        }
    }
    
    func getAllTickets(request:JSONDictionary, responseBlock:@escaping CompletionBlock) {
        let urlString = "auth.php"
        let header = additionalHeaders
        Alamofire.request(baseURL + urlString, method: .post, parameters: request, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if let error = response.result.error{
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.result.value{
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        }
    }
    
    func uploadTicketWithRecords(request:JSONDictionary, responseBlock:@escaping CompletionBlock) {
        let urlString = "auth.php"
        let header = additionalHeaders
        Alamofire.request(baseURL + urlString, method: .post, parameters: request, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if let error = response.result.error{
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.result.value{
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        }
    }
    
    func updateBadge(request:JSONDictionary, responseBlock:@escaping CompletionBlock) {
        let urlString = "auth.php"
        let header = additionalHeaders
        Alamofire.request(baseURL + urlString, method: .post, parameters: request, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if let error = response.result.error{
                print(error.localizedDescription)
                let apiResponse = AlamofireAPIResponse.init(response: nil, errorCode: (error as NSError).code, errorMessage: error.localizedDescription, successful: false)
                responseBlock(apiResponse)
            } else if let jsonValue = response.result.value{
                print(jsonValue)
                let apiResponse = AlamofireAPIResponse.init(response: jsonValue as JSON?, errorCode: 0, errorMessage: "", successful: true)
                responseBlock(apiResponse)
            }
        }
    }

}
