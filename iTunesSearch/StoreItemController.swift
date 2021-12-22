//
//  StoreItemControllerClassViewController.swift
//  iTunesSearch
//
//  Created by Olibo moni on 22/12/2021.
//

import UIKit

class StoreItemController: UIViewController {
    
    func fetchItems(matching query: [String: String]) async throws ->[StoreItem]{
        var urlComponents = URLComponents(string: "https://itunes.apple.com/search")!
        urlComponents.queryItems = query.map{ URLQueryItem(name: $0.key, value: $0.value) }
        
        let jsonDecoder = JSONDecoder()
        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else{throw SearchError.itemNotFound}
        let searchResponse = try jsonDecoder.decode(SearchResponse.self, from: data)
        
        
        
        
        return searchResponse.results
    }
    
    enum SearchError: Error, LocalizedError{
        case itemNotFound
        case failedToLoadImage
    }
    
    func fetchPhoto(from url: URL) async throws -> UIImage{
        
        let (data,response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else{throw SearchError.failedToLoadImage }
        
        guard let image = UIImage(data: data) else {
            throw SearchError.failedToLoadImage
        }
                return image
    }
    
    
    
    
}
