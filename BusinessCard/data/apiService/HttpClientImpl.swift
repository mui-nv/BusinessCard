//
//  HttpClientImpl.swift
//  BusinessCard
//
//  Created by AxiZ on 2020/01/24.
//  Copyright © 2020 AxiZ. All rights reserved.
//

import Foundation
import UIKit

public class HttpClientImpl {
    // アップロードデータをダウンロードするためのAPI
    private let session: URLSession
    
    // URLSessionの設定を提供するクラス
    // タイムアウト値、キャッシュやクッキーの扱い方、端末回線での接続の許可などを変更できる
    public init(config: URLSessionConfiguration? = nil) {
        self.session = config.map {URLSession(configuration: $0)} ?? URLSession.shared
    }
    
    // URLRequestは、httpMethodプロパティをサーバの要求に合わせてPOSTまたはPUTし、
    // ヘッダーにContent-typeなどを設定します
    public func execute(request: URLRequest) -> (NSData?, URLResponse?, NSError?) {
        var d: NSData? = nil
        var r: URLResponse? = nil
        var e: NSError? = nil
        // 共有リソースを排他制御するための仕組みを抽象化したクラス
        let semaphore = DispatchSemaphore(value: 0)
        session.dataTask(with: request) { (data, response, error) -> Void in
            d = data as NSData?
            r = response
            e = error as NSError?
            semaphore.signal()
            }.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return (d, r, e)
    }
}
