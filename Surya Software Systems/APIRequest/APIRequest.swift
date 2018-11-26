//
//  APIRequest.swift
//  Surya Software Systems
//
//  Created by Raghavendra Dattawad on 11/23/18.
//  Copyright © 2018 Raghavendra Dattawad. All rights reserved.
//

import Foundation

enum Method: String {
     case POST = "POST"
}

class ServiceManager{

   
    
    static let sharedInstance  = ServiceManager()
    var itemOfUserDetails:UserDetails?

    func postValues(urlRequest:String,postData: [String: String],callBack:@escaping (_ data:Data?,_ error:Error?)->(Void)){
       print(postData)
        
        var request = URLRequest(url: URL(string: urlRequest)!)
      print(urlRequest)
        
        let postData = try! JSONSerialization.data(withJSONObject: postData, options: .prettyPrinted)
        request.httpBody = postData
        request.httpMethod = Method.POST.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      let dataTask =  URLSession.shared.dataTask(with: request) { (data, response, error) in
            callBack(data,error)
        }
        dataTask.resume()
    }
    
    
    
}
