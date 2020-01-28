//
//  UserRepository.swift
//  BusinessCard
//
//  Created by AxiZ on 2020/01/24.
//  Copyright © 2020 AxiZ. All rights reserved.
//

import Foundation
import RxSwift

class UserRepository: BaseRepository {
    let apiService = ApiService()
    let realmDB = RealmDB()
    
    func createUser(data: CreateUserParam) -> Observable<CreateUserResponse> {
        let requestUrl = ApiService.baseUrl + ApiService.createUserUrl
        return apiService.createUser(url: requestUrl, data: data)
    }
    
    func findUser() -> UserObject? {
        return realmDB.findUser()
    }
    
    func selectUser(data: CreateUserParam) -> Observable<CreateUserResponse> {
        let requestUrl = ApiService.baseUrl + ApiService.selectUserUrl
        
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        
        let userData = try! encoder.encode(data)
        let stringData = "{\"param\":\"" + encodeString(data: Util.dataToString(dataIn: userData)) + "\"}"
        let dataObject = Util.stringToData(string: stringData)
        
        return apiService.selectUser(url: requestUrl, data: dataObject!)
            .flatMap { (paramData) -> Observable<CreateUserResponse> in
                let stringResult = self.decodeString(data: paramData.param)
                let resultData = Util.stringToData(string: stringResult)
                
                do {
                    let json:CreateUserResponse = try decoder.decode(CreateUserResponse.self, from: resultData! as Data)
                    self.realmDB.saveUser(user: json)
                    return .just(json)
                } catch _ as NSError {
                    return .error(BaseError.unexpectedError)
                }
        }
    }
}
