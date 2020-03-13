//
//  NetworkManager.swift
//  WebScrapper
//
//  Created by Giuliano Accorsi on 12/03/20.
//  Copyright © 2020 Giuliano Accorsi. All rights reserved.
//

import Foundation
import Alamofire
final class NetworkService {
    func fetchHtmlString(site: String, completion: @escaping (String?) -> Void){
        AF.request(site).responseString { (response) in
            if response.response?.statusCode == 200 {
                completion(response.value)
            }else {
                completion(nil)
            }
        }
    }
}
