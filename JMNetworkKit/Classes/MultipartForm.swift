//
//  MultipartForm.swift
//  JMNetworkKit
//
//  Created by 최정민 on 2022/03/23.
//

import UIKit

enum MultipartForm {
    private static let lineBreak = "\r\n"
    
    static func setRequest(url: URL, httpMethod: HTTPMethod, accessToken: String? = nil, requestDictionary: [String: Any?]) -> URLRequest {
        var request = URLRequest(url: url)
        let boundary = generateBoundary()
        
        request.setValue(DataForm.converMultipart(boundary), forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        request.httpMethod = httpMethod.rawValue
        if let accessToken = accessToken {
            request.addValue(accessToken, forHTTPHeaderField: HTTPHeaderField.accessToken.rawValue)
        }
        request.httpBody = createDataBody(withParameters: requestDictionary, boundary: boundary)
        
        return request
    }
    
    private static func generateBoundary() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    private static func createDataBody(withParameters parameters: [String: Any?], boundary: String) -> Data {
        var body = Data()
        
        for (key, value) in parameters {
            if let image = value as? UIImage,
               let imageFile = setUpImageFile(images: [image], key: key) {
                appendImagesToBody(body: &body, images: imageFile, boundary: boundary)
            } else if let images = value as? [UIImage],
                      let imageFile = setUpImageFile(images: images, key: key) {
                appendImagesToBody(body: &body, images: imageFile, boundary: boundary)
            } else if let values = value as? [String] {
                appendArrayValueToBody(body: &body, key: key, values: values, boundary: boundary)
            } else if let value = value {
                appendValueToBody(body: &body, key: key, value: String(describing: value), boundary: boundary)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
    
    private static func appendArrayValueToBody(body: inout Data, key: String, values: [String], boundary: String) {
        var arrayIndex = 0
        for value in values {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(key)[\(arrayIndex)]\"\(lineBreak + lineBreak)")
            body.append("\(value + lineBreak)")
            arrayIndex += 1
        }
    }
    
    private static func appendValueToBody(body: inout Data, key: String, value: String, boundary: String) {
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
        body.append("\(value + lineBreak)")
    }
    
    private static func appendImagesToBody(body: inout Data, images: [ImageFile], boundary: String) {
        for image in images {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(image.key)\"; filename=\"\(image.fileName)\"\(lineBreak)")
            body.append("Content-Type: \(image.mimeType + lineBreak + lineBreak)")
            body.append(image.data)
            body.append(lineBreak)
        }
    }
    
    private static func setUpImageFile(images: [UIImage], key: String) -> [ImageFile]? {
        var imageFiles: [ImageFile] = []
        
        for image in images {
            guard let jpgData = image.jpegData(compressionQuality: 0.7),
                  let imageFile = ImageFile(data: jpgData, forKey: "\(key)", fileName: String(describing: image)) else { return nil }
            imageFiles.append(imageFile)
        }
        
        return imageFiles
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
