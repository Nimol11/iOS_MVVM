//
//  Service.swift
//  MVVM
//
//  Created by Nimol on 20/11/23.
//

import UIKit
class Service {
    enum NetworkError: Error {
        case urlError
        case cannotParseData
    }
   static func getProduct(completion: @escaping(_ result: Result<[Model], NetworkError>) -> Void) {
       let url: String = "https://raw.githubusercontent.com/Nimol11/api/main/coffee.json"
        guard let url = URL(string: url) else {
            completion(.failure(.urlError))
            return
        }
        URLSession.shared.dataTask(with: url) { dataRespone, urlResponse, error in
            if  error == nil,
                let data = dataRespone,
                let resultData = try? JSONDecoder().decode([Model].self, from: data) {
                completion(.success(resultData))
            } else {
                completion(.failure(.cannotParseData))
            }            
        }.resume()
    }
}
