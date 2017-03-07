//
//  LandMarkItem.swift
//  LandMarks
//
//  Created by Srini Motheram on 3/6/17.
//  Copyright © 2017 Srini Motheram. All rights reserved.
//

import UIKit

class LandMarkItem: NSObject {
    
    var landMarkItemName    :String!
    var streetAddress   :String!
    var city         :String!
    var state         :String!
    var zipCode         :String!
    var lat             :Double!
    var long            :Double!
    var desc     :String!
    
    var formattedQuantity :String {
        
        return "Quantity: \(lat)"
        
    }
    
    init(landMarkItemName: String, streetAddress: String, city: String, state: String, zipCode: String, lat: Double, long: Double, desc: String) {
        self.landMarkItemName = landMarkItemName
        self.streetAddress = streetAddress
        self.city      = city
        self.state = state
        self.zipCode = zipCode
        self.lat = lat
        self.long = long
        self.desc = desc
        
    }
}
