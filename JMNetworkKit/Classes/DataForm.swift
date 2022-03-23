//
//  DataForm.swift
//  JMNetworkKit
//
//  Created by 최정민 on 2022/03/23.
//

import Foundation

public enum DataForm: String {
    static func converMultipart(_ boundary: String) -> String {
        return "multipart/form-data; boundary=\(boundary)"
    }
    case applicationJson = "application/json"
    case multipartForm
}
