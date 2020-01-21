//
//  News.swift
//  DigitalNews
//
//  Created by Giuliano Accorsi on 23/07/19.
//  Copyright © 2019 Giuliano Accorsi. All rights reserved.
//

import Foundation

struct NewsAPI: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article] 
}
