//
//  ApiService.swift
//  BusinessCard
//
//  Created by AxiZ on 2020/01/24.
//  Copyright © 2020 AxiZ. All rights reserved.
//

import Foundation
import RxSwift

class ApiService {
    static let baseUrl = "http://localhost/BusinessCard/"
    static let createUrl = "create.php"
    static let searchUrl = "allData.php"
    static let deleteUrl = "delete.php"
    static let getImageUrl = "getImage.php"
    static let updateUrl = "update.php"
    
    static let createUserUrl = "CreateUser.php"
    static let selectUserUrl = "SelectUser.php"
    
    func requestAPI(object: Data?, method: String, url: String) -> Observable<Data> {
        return Observable.create { observer in
            
            let myUrl: URL = URL(string: url)!
            let req = NSMutableURLRequest(url: myUrl)
            
            req.httpMethod = method
            if object != nil {
                req.httpBody = object
            }
            
            let myHttpSession = HttpClientImpl()
            
            let (data, response, _) = myHttpSession.execute(request: req as URLRequest)
            
            if response == nil || (response as! HTTPURLResponse).statusCode != 200 {
                observer.onError(BaseError.unexpectedError)
            }
            
            if data != nil {
                observer.onNext(data! as Data)
            }
            
            return Disposables.create()
        }
    }
    
    func createUser(url: String, data: CreateUserParam) -> Observable<CreateUserResponse> {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        let dataObj = try! encoder.encode(data)
        return requestAPI(object: dataObj, method: "POST", url: url)
            .flatMap { (paramData) -> Observable<CreateUserResponse> in
                
                do {
                    let sucessData: CreateUserResponse = try decoder.decode(CreateUserResponse.self, from: paramData)
                    return .just(sucessData)
                } catch _ as NSError {
                    return .error(BaseError.unexpectedError)
                }
        }
    }
    
    func selectUser(url: String, data: Data) -> Observable<Param> {
        let decoder = JSONDecoder()
        
        return requestAPI(object: data, method: "POST", url: url)
            .flatMap { (paramData) -> Observable<Param> in
                
                do {
                    let sucessData: Param = try decoder.decode(Param.self, from: paramData)
                    return .just(sucessData)
                } catch _ as NSError {
                    return .error(BaseError.unexpectedError)
                }
        }
    }
    
    func requestApiData(url: String, data: Data) -> Observable<Param> {
        let decoder = JSONDecoder()
        return requestAPI(object: data, method: "POST", url: url)
            .flatMap { (responseData) -> Observable<Param> in
                
                do {
                    let sucessData: Param = try decoder.decode(Param.self, from: responseData)
                    return .just(sucessData)
                } catch _ as NSError {
                    return .error(BaseError.unexpectedError)
                }
        }
    }
}
