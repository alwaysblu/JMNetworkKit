//
//  NetworkManager.swift
//  JMNetworkKit
//
//  Created by 최정민 on 2022/03/23.
//

import Foundation

final public class NetworkManager {
    public static let shared = NetworkManager(networkLoader: NetworkLoader())
    private var networkLoader: NetworkLoader
    
    init(networkLoader: NetworkLoader) {
        self.networkLoader = networkLoader
    }
    
    // MARK: Interface functions
    
    public func sendRequest<Response>(url: URL,
                               response: Response.Type,
                               completion: @escaping (Result<Response, Error>) -> Void) where Response: Decodable {
        
        networkLoader.loadData(with: url) { [weak self] result in
            self?.handleResponseData(result: result, completion: completion)
        }
    }
    
    /// application/json
    public func sendRequest<Request, Response>(url: URL,
                                        request: RequestData<Request>,
                                        response: Response.Type,
                                        completion: @escaping (Result<Response, Error>) -> Void) where Request: Encodable, Response: Decodable {
        
        guard let request = setRequest(url: url,
                                       httpMethod: request.httpMethod,
                                       accessToken: request.accessToken,
                                       requestObject: request.request) else { return }
        
        networkLoader.loadData(with: request) { [weak self] result in
            self?.handleResponseData(result: result, completion: completion)
        }
        
        return
    }
    
    /// multipartform
    public func sendRequest<Request, Response>(url: URL,
                                        request: RequestData<Request>,
                                        response: Response.Type,
                                        completion: @escaping (Result<Response, Error>) -> Void) where Request: DictionaryGettable, Response: Decodable {
        
        guard let dictionary = request.request?.dictionary,
              let multipartformRequest = setRequest(url: url,
                                       httpMethod: request.httpMethod,
                                       accessToken: request.accessToken,
                                       requestDictionary: dictionary) else { return }
        
        networkLoader.loadData(with: multipartformRequest) { [weak self] result in
            self?.handleResponseData(result: result, completion: completion)
        }
        
        return
    }
    
    // MARK: Private functions
    
    private func encodedData<T>(data: T) -> Data? where T: Encodable {
        let encoder = JSONEncoder()
        
        return try? encoder.encode(data)
    }
    
    private func setRequest<Request>(url: URL,
                                     httpMethod: HTTPMethod,
                                     accessToken: String? = nil,
                                     requestObject: Request?) -> URLRequest? where Request: Encodable {
        var request = URLRequest(url: url)
        
        request.setValue(DataForm.applicationJson.rawValue,
                         forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        request.httpMethod = httpMethod.rawValue
        if let accessToken = accessToken {
            request.addValue(accessToken, forHTTPHeaderField: HTTPHeaderField.accessToken.rawValue)
        }
        if let requestObject = requestObject {
            request.httpBody = encodedData(data: requestObject)
        }
        
        return request
    }
    
    private func setRequest(url: URL,
                            httpMethod: HTTPMethod,
                            accessToken: String? = nil,
                            requestDictionary: [String: Any?]) -> URLRequest? {
        return MultipartForm.setRequest(url: url,
                                        httpMethod: httpMethod,
                                        accessToken: accessToken,
                                        requestDictionary: requestDictionary)
    }
    
    private func handleResponseData<Response>(result: Result<Data, Error>,
                                              completion: @escaping (Result<Response, Error>) -> Void) where Response: Decodable {
        switch result {
        case .success(let data):
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
