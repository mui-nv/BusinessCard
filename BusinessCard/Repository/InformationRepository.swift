//
//  InformationRepository.swift
//  BusinessCard
//
//  Created by AxiZ on 2020/01/24.
//  Copyright © 2020 AxiZ. All rights reserved.
//

import Foundation
import RxSwift

class InformationRepository: BaseRepository {
    let apiService = ApiService()
    let realmDB = RealmDB()
    let userRepository = UserRepository()
    
    func createInfo(data: CreateInfoParam) -> Observable<CreateInformationResponse> {
        let requestUrl = ApiService.baseUrl + ApiService.createUrl
        
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        
        let userID = userRepository.findUser()?.userID
        var tmpData = data
        tmpData.userID = userID!
        
        let userData = try! encoder.encode(tmpData)
        let stringData = "{\"param\":\"" + encodeString(data: Util.dataToString(dataIn: userData)) + "\"}"
        let dataObject = Util.stringToData(string: stringData)
        return apiService.requestApiData(url: requestUrl, data: dataObject!)
            .flatMap { (paramData) -> Observable<CreateInformationResponse> in
                let stringResult = self.decodeString(data: paramData.param)
                let resultData = Util.stringToData(string: stringResult)
                
                do {
                    let json:CreateInformationResponse = try decoder.decode(CreateInformationResponse.self, from: resultData! as Data)
                    return .just(json)
                } catch _ as NSError {
                    return .error(BaseError.unexpectedError)
                }
        }
    }
    
    func deleteInfo(data: DeleteParam) -> Observable<DeleteResponse> {
        let userID = userRepository.findUser()?.userID
        var tmpData = data
        tmpData.userID = userID!
        
        let requestUrl = ApiService.baseUrl + ApiService.deleteUrl
        
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        
        let userData = try! encoder.encode(tmpData)
        let stringData = "{\"param\":\"" + encodeString(data: Util.dataToString(dataIn: userData)) + "\"}"
        print(stringData)
        let dataObject = Util.stringToData(string: stringData)
        
        return apiService.requestApiData(url: requestUrl, data: dataObject!)
            .flatMap { (paramData) -> Observable<DeleteResponse> in
                let stringResult = self.decodeString(data: paramData.param)
                let resultData = Util.stringToData(string: stringResult)
                
                do {
                    let json:DeleteResponse = try decoder.decode(DeleteResponse.self, from: resultData! as Data)
                    return .just(json)
                } catch _ as NSError {
                    return .error(BaseError.unexpectedError)
                }
        }
    }
    
    func searchInfo(data: SearchParam) -> Observable<[Information]> {
        let userID = userRepository.findUser()?.userID
        var tmpData = data
        tmpData.userID = userID!
        
        let requestUrl = ApiService.baseUrl + ApiService.searchUrl
        
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        
        let userData = try! encoder.encode(tmpData)
        let stringData = "{\"param\":\"" + encodeString(data: Util.dataToString(dataIn: userData)) + "\"}"
        let dataObject = Util.stringToData(string: stringData)
        return apiService.requestApiData(url: requestUrl, data: dataObject!)
            .flatMap { (paramData) -> Observable<[Information]> in
                let stringResult = self.decodeString(data: paramData.param)
                let resultData = Util.stringToData(string: stringResult)
                
                do {
                    let json:[Information] = try decoder.decode([Information].self, from: resultData! as Data)
                    self.realmDB.saveInfo(infos: json)
                    return .just(json)
                } catch _ as NSError {
                    return .error(BaseError.unexpectedError)
                }
        }
    }
    
    func getImage(data: ImageParam) -> Observable<ImageResponse> {
        let requestUrl = ApiService.baseUrl + ApiService.getImageUrl
        
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        
        let userData = try! encoder.encode(data)
        let stringData = "{\"param\":\"" + encodeString(data: Util.dataToString(dataIn: userData)) + "\"}"
        let dataObject = Util.stringToData(string: stringData)
        
        return apiService.requestApiData(url: requestUrl, data: dataObject!)
            .flatMap { (paramData) -> Observable<ImageResponse> in
                
                let stringResult = self.decodeString(data: paramData.param)
                let resultData = Util.stringToData(string: stringResult)
                
                do {
                    let json:ImageResponse = try decoder.decode(ImageResponse.self, from: resultData! as Data)
                    return .just(json)
                } catch _ as NSError {
                    return .error(BaseError.unexpectedError)
                }
        }
    }
    
    func updateInfo(data: CreateInfoParam) -> Observable<DeleteResponse> {
        let userID = userRepository.findUser()?.userID
        var tmpData = data
        tmpData.userID = userID!
        
        let requestUrl = ApiService.baseUrl + ApiService.updateUrl
        
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        
        let userData = try! encoder.encode(tmpData)
        let stringData = "{\"param\":\"" + encodeString(data: Util.dataToString(dataIn: userData)) + "\"}"
        let dataObject = Util.stringToData(string: stringData)
        
        return apiService.requestApiData(url: requestUrl, data: dataObject!)
            .flatMap { (paramData) -> Observable<DeleteResponse> in
                
                let stringResult = self.decodeString(data: paramData.param)
                let resultData = Util.stringToData(string: stringResult)
                
                do {
                    let json:DeleteResponse = try decoder.decode(DeleteResponse.self, from: resultData! as Data)
                    return .just(json)
                } catch _ as NSError {
                    return .error(BaseError.unexpectedError)
                }
        }
    }
}
