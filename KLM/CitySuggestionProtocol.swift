//
//  CitySuggestionProtocol.swift
//  KLM
//
//  Created by Goutham Devaraju on 05/03/20.
//  Copyright © 2020 Goutham. All rights reserved.
//

import Foundation


protocol CitySuggestionPresenterProtocol: class {
    
    //For fetching EOS profile data
    func fetchFlightDetails()
    
    func processFlightDetailsAndPassToViews(flight_data: [FlightDetails])
    func handleErrorFromFlightDetails()
}

protocol CitySuggestionViewProtocol: class {
    
    //For fetching EOS profile data
    func fetchFlightDetailsAPI()
    func handleAirportDataResponse()
    
    func showLoaderAnimation()
    
    func initialTextFieldAnimation()

}
