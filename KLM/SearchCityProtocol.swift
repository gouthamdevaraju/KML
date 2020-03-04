//
//  SearchCityProtocol.swift
//  KLM
//
//  Created by Goutham Devaraju on 04/03/20.
//  Copyright © 2020 Goutham. All rights reserved.
//

import Foundation

protocol SearchCityPresenterProtocol: class {
    
    //For fetching EOS profile data
    func fetchFlightDetails()
    
    func processFlightDetailsAndPassToViews(flight_data: [FlightDetails])
    func handleErrorFromFlightDetails()
}

protocol SearchCityViewProtocol: class {
    
    //For fetching EOS profile data
    func fetchFlightDetailsAPI()
    func handleAirportDataResponse()
    
    func showLoaderAnimation()
    
    func initialTextFieldAnimation()
    
//    func setNavigationTitle(stringAccountName: String)
//
//    //Setting net details
//    func setNetStake(stringNetValue: String, stringNetUsed: String, stringNetTotal: String, percentage: Int)
//    
//    //Setting CPU details
//    func setCPUStake(stringCPUValue: String, stringCPUUsed: String, stringCPUTotal: String, percentage: Int)
//    
//    //Setting RAM details
//    func setRAMUsed(stringRAMUsed: String, stringRAMTotal: String, percentage: Int)
//    
//    //Setting converted dollar value
//    func setConvertedDollarValue(stringDollarValue: String)
}
