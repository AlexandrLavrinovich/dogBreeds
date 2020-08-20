//
//  BreedModel.swift
//  DogBreeds
//
//  Created by Alexandr Lavrinovich on 19.08.2020,
//  Copyright © 2020 MacBook Pro. All rights reserved.
//


import Foundation

struct BreedModel: Decodable {
    
    var message: [String]
    var status: String
    
}

private extension BreedModel {
    enum CodingKeys: String, CodingKey {
        case message
        case status
    }
}

extension BreedModel {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decode(forKey: .message)
        status = try values.decode(forKey: .status)
    }
}

