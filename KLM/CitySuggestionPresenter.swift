//
//  CitySuggestionPresenter.swift
//  KLM
//
//  Created by Goutham Devaraju on 05/03/20.
//  Copyright © 2020 Goutham. All rights reserved.
//

import Foundation

class CitySuggestionPresenter: CitySuggestionPresenterProtocol {
    
    //MARK: - Properties
    var city_suggestion_viewController : CitySuggestionViewController? = nil
    
    var airport_data_filtered_results: [FlightDetails]?
    
    //MARK: - Methods
    required init(view: CitySuggestionViewController) {
        self.city_suggestion_viewController = view
    }
    
    func fetchFlightDetails() {
        
    }
    
    func processFlightDetailsAndPassToViews(flight_data: [FlightDetails]) {
        
    }
    
    func handleErrorFromFlightDetails() {
        
    }
    
    
    
}
