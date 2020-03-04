//
//  FlightDetails.swift
//  KLM
//
//  Created by Goutham Devaraju on 04/03/20.
//  Copyright © 2020 Goutham. All rights reserved.
//

import Foundation

struct FlightDetails: Codable, Comparable {
    
    static func < (lhs: FlightDetails, rhs: FlightDetails) -> Bool {

        var isSorted = false
        if let first = lhs.city, let second = rhs.city {
            isSorted = first > second
        }
        return isSorted
    }

    var code: String?
    var lat: String?
    var long: String?
    var name: String?
    var city: String?
    var state: String?
    var country: String?
    var woeid: String?
    var tz: String?
    var phone: String?
    var type: String?
    var email: String?
    var url: String?
    var runway_length: String?
    var elev: String?
    var icao: String?
    var direct_flights: String?
    var carriers: String?
}

