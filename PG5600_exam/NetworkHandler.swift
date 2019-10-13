//
//  NetworkHandler.swift
//  PG5600_exam
//
//  Created by Håvard on 13/10/2019.
//  Copyright © 2019 Håvard. All rights reserved.
//

import Foundation
import Alamofire

class NetworkHandler {
  
  func makeRequestWith<T: Codable>(
    url: String,
    completed:@escaping (_ response: T) -> Void,
    failed:@escaping (_ response: String) -> Void
  ) {
    AF.request(url)
      .validate(contentType: ["application/json"])
      .responseJSON(queue: DispatchQueue.init(label: "Background"))
      { response in
        guard let data = response.data else {return};
        guard let value = response.value else {return};
        
        if let statusCode = response.error?.responseCode {
          failed("Error with status code: \(statusCode)");
        }
        
        do {
          let fetchRes = try JSONDecoder().decode(T.self, from: data)
          DispatchQueue.main.async {
            completed(fetchRes);
          }
        } catch let error {
          print(error)
        }
    }
  }
}


