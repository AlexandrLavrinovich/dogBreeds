//
//  KeyedDecodingContainer.swift
//  DogBreeds
//
//  Created by Alexandr Lavrinovich on 17.08.2020,
//  Copyright © 2020 MacBook Pro. All rights reserved.
//


import Foundation

extension KeyedDecodingContainer {
    
    func decodeUrl(forKey key: KeyedDecodingContainer<K>.Key) throws -> String {
        let url = try decode(String.self, forKey: key)
        if url.hasPrefix("//") {
            let clearedUrl = String(url.suffix(from: url.index(url.startIndex, offsetBy: 2)))
            return "https://".appending(clearedUrl)
        }
        return url
    }
    
    func decodeUrl(forKey key: KeyedDecodingContainer<K>.Key) throws -> String? {
        if let url = try decodeIfPresent(String.self, forKey: key),
            url.hasPrefix("//") {
            let clearedUrl = String(url.suffix(from: url.index(url.startIndex, offsetBy: 2)))
            return "https://".appending(clearedUrl)
        }
        return nil
    }
    
    func decode<T: Decodable>(forKey key: KeyedDecodingContainer<K>.Key) throws -> T {
        return try decode(T.self, forKey: key)
    }
    
}
