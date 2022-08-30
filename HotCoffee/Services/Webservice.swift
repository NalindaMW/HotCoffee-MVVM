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

struct Resource<T: Codable> {
    let url: URL?
}

struct Webservice {
    
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        if let url = resource.url {
            URLSession.shared.dataTask(with: url) { data, response, error in
                
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
