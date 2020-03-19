//
//  BaseAPIProtocol.swift
//  iOS-training-app-sample
//
//  Created by Iichiro Kawashima on 2018/12/23.
//  Copyright © 2018 Iichiro Kawashima. All rights reserved.
//

import Foundation
import APIKit

enum APPErrorCode: Int {
    case error400 = 400
    case error401 = 401
    case error403 = 403
    case error404 = 404
}

final class APPErrorResponse {
    struct Error400: Decodable, Error {
        let message: String
    }

    struct Error401: Decodable, Error {
        let message: String
    }

    struct Error403: Decodable, Error {
        let message: String
    }

    struct Error404: Decodable, Error {
        let message: String
    }

    struct OtherError: Decodable, Error {
        let message: String
    }
}

final class DecodableDataParser: APIKit.DataParser {
    var contentType: String?

    func parse(data: Data) throws -> Any {
        return data
    }
}

protocol AppRequestType: Request {
}

extension AppRequestType {

    var baseURL: URL {
        return URL(string: AppResource.Const.url)!
    }

    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {

        switch urlResponse.statusCode {
        case 200..<300:
            return object
        case 400:
            throw APPErrorResponse.Error400(message: "error 400")
        case 401:
            throw APPErrorResponse.Error401(message: "error 401")
        case 403:
            throw APPErrorResponse.Error403(message: "error 403")
        case 404:
            throw APPErrorResponse.Error404(message: "error 404")
        default:
            throw APPErrorResponse.OtherError(message: "network error")
        }
    }

    func intercept(urlRequest: URLRequest) throws -> URLRequest {
        
        var req = urlRequest
        req.timeoutInterval = 2.0

        return req
    }
}

extension AppRequestType where Response: Decodable {
    var dataParser: DataParser {
        return DecodableDataParser()
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
        return try JSONDecoder().decode(Response.self, from: data)
    }
}
