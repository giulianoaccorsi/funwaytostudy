//
//  NetworkService.swift
//  Impacta
//
//  Created by Giuliano Accorsi on 02/02/21.
//  Copyright © 2021 Giuliano Accorsi. All rights reserved.
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
