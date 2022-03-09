//
//  APICaller.swift
//  demo
//
//  Created by MAC OS on 07/03/22.
//

import Foundation

final class APICaller{
    static let shared = APICaller()
    
    struct constants {
        static let topHeadlineURL = URL(string: "https://newsapi.org/v2/everything?domains=wsj.com&apiKey=593f5a82de084c33afe3c1955d829e8d")
    }
    private init() {}
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = constants.topHeadlineURL else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("Articles: \(result.articles.count)")
                    
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
        
        
    }
}
struct APIResponse: Codable{
    let articles: [Article]
}
struct Article: Codable {
    let title: String
    let description: String
    let url: String
    let urlToImage: String
}

struct Source: Codable {
    let name: String
}
