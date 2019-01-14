//
//  Logger.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/23.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//
import Foundation
import SwiftyBeaver

class Logger {

    static let shared = Logger()

    let log = SwiftyBeaver.self

    private init() {
        let console = ConsoleDestination()
        log.addDestination(console)
    }

    func apiRequestLogger(_ URLRequest: URLRequest) {

        guard let body = URLRequest.httpBody else {
            return
        }

        guard let jsonObject: Dictionary = Data.convertToJSON(body) else {
            return
        }

        var text: String = ""

        text = "\n*******************************************************************************"
        text += "\n\(URLRequest.url!)へのリクエスト"
        text += "\n*******************************************************************************"
        text += "\n【URLRequest AllHTTPHeaderFields】"
        text += "\n\(URLRequest.allHTTPHeaderFields!)"
        text += "\n【URLRequest URL】"
        text += "\n\(URLRequest.url!)"
        text += "\n【URLRequest Method】"
        text += "\n\(String(describing: URLRequest.httpMethod))"
        text += "\n【URLRequest Body】"
        text += "\n\(jsonObject)"
        text += "\n\n"

        log.debug(text)

    }

    func apiResponseLogger(_ object: Any, URLResponse: HTTPURLResponse) {

        guard let body = String(data: (object as? Data)!, encoding: .utf8) else {
            return
        }

        var text: String = ""

        text = "\n*******************************************************************************"
        text += "\n\(URLResponse.url!)のレスポンス"
        text += "\n*******************************************************************************"
        text += "\n【URLResponse AllHTTPHeaderFields】"
        text += "\n\(URLResponse)"
        text += "\n【URLResponse URL】"
        text += "\n\(URLResponse.url!)"
        text += "\n【URLResponse StatusCode】"
        text += "\n\(URLResponse.statusCode)"
        text += "\n【URLResponse Body】"
        text += "\n\(body)"
        text += "\n\n"

        log.debug(text)
    }
}

