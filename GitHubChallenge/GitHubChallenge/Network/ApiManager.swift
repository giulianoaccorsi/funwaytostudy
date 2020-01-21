//
//  ApiManager.swift
//  GitHubChallenge
//
//  Created by Giuliano Accorsi on 05/08/19.
//  Copyright © 2019 Giuliano Accorsi. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - Network Manager
class APIManager {
    
    func loadInformation(page: Int,completion: @escaping ([Item]?, Bool) -> Void) {
        let url = API.baseURL + API.search + API.repositories
        let params: Parameters = ["q":"language:swift","sort":"stars","page":"\(page)"]
        
        Alamofire.request(url, method: .get, parameters: params).responseJSON { (response) in
            if response.response?.statusCode == 200 {
                print(" Deu Bom :) Page: \(page)")
//                print("Status 200 ! -- loadInformation() - APIManager \n \(response.result.value ?? "nil")")
                
                guard let data = response.data else {
                    completion(nil,false)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let result = try JSONDecoder().decode(GitHub.self, from: data)
                    completion(result.items,true)
                    print("Count: \(result.items.count)")
                    return
                }catch {
                    print("Deu Ruim :c -- loadInformation() - APIManager")
                }
                completion(nil,false)
            }else {
                completion(nil,false)
            }
        }
    }
    
    func updateInformation(completion: @escaping ([Item]?, Bool)-> Void) {
        let url = API.baseURL + API.search + API.repositories
        let params: Parameters = ["q":"language:swift","sort":"stars"]
        
        Alamofire.request(url, method: .get, parameters: params).responseJSON { (response) in
            if response.response?.statusCode == 200 {
//                 print("Status 200 ! -- updateInformation() - APIManager \n \(response.result.value ?? "nil")")
                guard let data = response.data else {
                    completion(nil,false)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(GitHub.self, from: data)
                    completion(result.items,true)
                    return
                }catch {
                    print("Deu Ruim :c -- loadInformation() - APIManager")
                }
                completion(nil,false)
            }
        }
        
    }
    
    
}
