//
//  GitHub.swift
//  GitHubChallenge
//
//  Created by Giuliano Accorsi on 05/08/19.
//  Copyright © 2019 Giuliano Accorsi. All rights reserved.
//

import Foundation

struct GitHub: Codable {
    let totalCount: Int?
    let incompleteResults: Bool?
    let items: [Item]
    
//    enum CodingKeys: String, CodingKey {
//        case totalCount = "total_count"
//        case incompleteResults = "incomplete_results"
//        case items
//    }
}
