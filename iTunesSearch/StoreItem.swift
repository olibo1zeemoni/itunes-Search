//
//  StoreItem.swift
//  iTunesSearch
//
//  Created by Olibo moni on 22/12/2021.
//

import Foundation

struct StoreItem: Codable{
    var artistName: String
    var trackName: String
    var kind: String
    var description: String
    var url: URL
    
    
    enum CodingKeys: String, CodingKey{
        case artistName
        case trackName
        case kind
        case description
        case url = "artworkUrl100"
        
        
    }
    
    enum AdditionalKeys: CodingKey{
        case longDescription
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        artistName = try values.decode(String.self, forKey: CodingKeys.artistName)
        trackName = try values.decode(String.self, forKey: CodingKeys.trackName)
        kind = try values.decode(String.self, forKey: CodingKeys.kind)
        url = try values.decode(URL.self, forKey: CodingKeys.url)


        if let description = try? values.decode(String.self, forKey: CodingKeys.description){
            self.description = description
        } else {
            let additionalValues = try decoder.container(keyedBy: AdditionalKeys.self)
            description = (try? additionalValues.decode(String.self, forKey: AdditionalKeys.longDescription)) ?? ""
        }

    }
}
