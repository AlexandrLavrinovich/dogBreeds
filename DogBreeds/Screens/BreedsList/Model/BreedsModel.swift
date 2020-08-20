//
//  BreedsListModel.swift
//  DogBreeds
//
//  Created by Alexandr Lavrinovich on 17.08.2020,
//  Copyright © 2020 MacBook Pro. All rights reserved.
//


import Foundation

struct BreedsModel: Decodable {

    var message: [String : [String]]
    var status: String
    
    func getNames() -> [String] {
        var names = Array(message.keys)
        names = names.sorted()
        return names
    }
    
    func getDict() -> [String : [String]] {
        let names: [String : [String]] = message
        return names
    }
}

private extension BreedsModel {
    enum CodingKeys: String, CodingKey {
        case message
        case status
    }
}

extension BreedsModel {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decode(forKey: .message)
        status = try values.decode(forKey: .status)
    }
}
