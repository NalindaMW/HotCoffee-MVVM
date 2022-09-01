//
//  Webservice.swift
//  HotCoffee
//
//  Created by Nalinda Wickramarathna on 2022-08-30.
//

import Foundation

enum NetworkError: Error {
    case decodingError
    case domainError
    case urlError
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

struct Resource<T: Codable> {
    let url: URL?
    var httpMethod: HttpMethod = .get
    var body: Data? = nil
}

struct Webservice {
    
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        if let url = resource.url {
            
            var request = URLRequest(url: url)
            request.httpMethod = resource.httpMethod.rawValue
            request.httpBody = resource.body
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                guard let safeData = data, error == nil else {
                    completion(.failure(.domainError))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(T.self, from: safeData)
                    DispatchQueue.main.async {
                        completion(.success(result))
                    }
                } catch {
                    print(error)
                    completion(.failure(.decodingError))
                }
            }.resume()
        }
    }
    
}
