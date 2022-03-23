//
//  RequestData.swift
//  JMNetworkKit
//
//  Created by 최정민 on 2022/03/23.
//

import Foundation

public struct RequestData<Request> {
    public let httpMethod: HTTPMethod
    public let dataForm: DataForm
    public let accessToken: String?
    public var request: Request?
    
    public init(
        httpMethod: HTTPMethod,
        dataForm: DataForm,
        accessToken: String? = nil,
        request: Request? = nil
    ) {
        self.httpMethod = httpMethod
        self.dataForm = dataForm
        self.accessToken = accessToken
        self.request = request
    }
}

public struct EmptyBody: Encodable {}
