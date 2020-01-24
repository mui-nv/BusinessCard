//
//  ApiService.swift
//  BusinessCard
//
//  Created by AxiZ on 2020/01/24.
//  Copyright © 2020 AxiZ. All rights reserved.
//

import Foundation

class ApiService {
    static let baseUrl = "http://localhost/BusinessCard/"
    static let createUrl = "create.php"
    static let getUrl = "allData.php"
    static let deleteUrl = "delete.php"
    static let getImageUrl = "getImage.php"
    static let createUserUrl = "CreateUser.php"
    static let selectUserUrl = "SelectUser.php"
    
    func requestAPI(object: Data?, method: String, url: String, success: (Data?) -> (), error: (String) -> ()) {
        let myUrl: URL = URL(string: url)!
        let req = NSMutableURLRequest(url: myUrl)
        
        req.httpMethod = method
        if object != nil {
            req.httpBody = object
        }
        
        let myHttpSession = HttpClientImpl()
        
        let (data, response, _) = myHttpSession.execute(request: req as URLRequest)
        
        let code = (response as! HTTPURLResponse).statusCode
        if code != 200 {
            error("something wrong with server: \(code)")
            return
        }
        
        if data != nil {
            success(data! as Data)
        }
    }
    
    func getImageApi(url: String, data: ImageData, getSuccess: (ImageData?) -> (), getError: (String) -> ()) {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        let dataObj = try! encoder.encode(data)
        requestAPI(object: dataObj, method: "POST", url: url, success: { encodePlayer in
            
            do {
                let sucessData: Param = try decoder.decode(Param.self, from: encodePlayer!)
                print(sucessData)
            } catch let errors as NSError {
                getError(errors.description)
            }
        }, error: getError)
    }
    
    func createUser(url: String, data: CreateUserParam, createSuccess: (CreateUserResponse?) -> (), createError: (String) -> ()) {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        let dataObj = try! encoder.encode(data)
        requestAPI(object: dataObj, method: "POST", url: url, success: { userData in
            
            do {
                let sucessData: CreateUserResponse = try decoder.decode(CreateUserResponse.self, from: userData!)
                print(sucessData)
            } catch let errors as NSError {
                createError(errors.description)
            }
        }, error: createError)
    }
    
    func selectUser(url: String, data: Data, selectSuccess: (Param?) -> (), selectError: (String) -> ()) {
        let decoder = JSONDecoder()
        requestAPI(object: data, method: "POST", url: url, success: { userData in
            do {
                let sucessData: Param = try decoder.decode(Param.self, from: userData!)
                selectSuccess(sucessData)
            } catch let errors as NSError {
                selectError(errors.description)
            }
        }, error: selectError)
    }
}
