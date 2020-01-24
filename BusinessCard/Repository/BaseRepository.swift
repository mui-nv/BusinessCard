//
//  BaseRepository.swift
//  BusinessCard
//
//  Created by AxiZ on 2020/01/24.
//  Copyright © 2020 AxiZ. All rights reserved.
//

import Foundation

class BaseRepository {
    let key = "abcdefghijklmnop"
    let iv  = "1234567890123456"
    
    func encodeString(data: String) -> String {
        let aes = EncryptionAES()
        return aes.encrypt(key: key, iv: iv, text: data)
    }
    
    func decodeString(data: String) -> String {
        let aes = EncryptionAES()
        return aes.decrypt(key: key, iv: iv, base64: data)
    }
}
