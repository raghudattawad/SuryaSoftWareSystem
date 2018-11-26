//
//  SuryaSoftUserDetails.swift
//  Surya Software Systems
//
//  Created by Raghavendra Dattawad on 11/23/18.
//  Copyright © 2018 Raghavendra Dattawad. All rights reserved.
//

import Foundation


struct  UserDetails:Codable {
    
    let items: [GetUserDetails]?
    
}

struct GetUserDetails:Codable {
    
    let firstName:String?
    let lastName:String?
    let emailId:String?
    let imageUrl:String?
    
}
