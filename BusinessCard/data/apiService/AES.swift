//
//  AES.swift
//  BusinessCard
//
//  Created by AxiZ on 2020/01/24.
//  Copyright © 2020 AxiZ. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift

class EncryptionAES {
    
    // 暗号化処理
    // key:変換キー
    // iv:初期化ベクトル(時間などを使用してランダム生成するとよりセキュアになる)
    // text:文字列
    func encrypt(key: String, iv:String, text:String) -> String {
        
        do {
            // 暗号化処理
            // AES インスタンス化
            let aes = try AES(key: key, iv: iv)
            let encrypt = try aes.encrypt(Array(text.utf8))
            
            // Data 型変換
            let data = Data( encrypt )
            // base64 変換
            let base64Data = data.base64EncodedData()
            // UTF-8変換 nil 不可
            guard let base64String =
                String(data: base64Data as Data, encoding: String.Encoding.utf8)
                else { return "" }

            // base64文字列
            return base64String
            
        } catch {
            // エラー処理
            return ""
        }
    }
    
    // 複合処理
    // key:変換キー
    // iv:初期化ベクトル(時間などを使用してランダム生成するとよりセキュアになる)
    // base64:文字列
    func decrypt(key: String, iv:String, base64:String) -> String {
        
        do {
            // AES インスタンス化
            let aes = try AES(key: key, iv:iv)
            
            // base64 から Data型へ
            let byteData = base64.data(using: String.Encoding.utf8)! as Data
            // base64 デーコード
            guard let data = Data(base64Encoded: byteData)
                else { return "" }
            
            // UInt8 配列の作成
            let aBuffer = Array<UInt8>(data)
            // AES 複合
            let decrypted = try aes.decrypt(aBuffer)
            // UTF-8変換
            guard let text = String(data: Data(decrypted), encoding: .utf8)
                else { return "" }
            
            return text
        } catch {
            // エラー処理
            return ""
        }
    }
    
    
}
