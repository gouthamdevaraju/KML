//
//  SearchCityPresenter.swift
//  KLM
//
//  Created by Goutham Devaraju on 04/03/20.
//  Copyright © 2020 Goutham. All rights reserved.
//

import Foundation


class SearchCityPresenter: SearchCityPresenterProtocol{
    
    //MARK: - Properties
    var search_city_viewController : SearchCityViewController? = nil
    
    var airport_data: [FlightDetails]?
    var airport_data_filtered_results: [FlightDetails]?
    
    //MARK: - Methods
    required init(view: SearchCityViewController) {
        self.search_city_viewController = view
    }
    
    
    func fetchFlightDetails() {
        
        //Fetch profile
        
        let headers = [ACCEPT : APPLICATION_JSON]
        
        _ = NetworkInterface.getRequest(.get_flight_details, headers: headers as NSDictionary, params: nil, requestCompletionHander: { (success, data, response, error, header) -> (Void)in
            
            if success{
                
                do
                {
                    let decoder = JSONDecoder()
                    let flightData = try decoder.decode([FlightDetails].self, from: data!)
                    self.processFlightDetailsAndPassToViews(flight_data: flightData)
                }
                catch{
                    print("AirPort model codable error: \(error)")
                    self.handleErrorFromFlightDetails()
                }
            }
            else{
                //Handle API fetching failure case
                self.handleErrorFromFlightDetails()
            }
        })
        
    }
    
    func processFlightDetailsAndPassToViews(flight_data: [FlightDetails]) {
        
        //Paass data to the views
        airport_data = flight_data

        DispatchQueue.main.async {
            self.search_city_viewController?.handleAirportDataResponse()
        }
    }
    
    func handleErrorFromFlightDetails(){
        
        //Stop loader
        DispatchQueue.main.async {
            self.search_city_viewController?.loader_view.removeFromSuperview()
        }
    }
    
    func filterArrayData(city_charaters: String){
        
        if let data_airport = airport_data{
            
            let arr = data_airport.filter{
                if let city_name = $0.city{
                    return city_name.lowercased().contains(city_charaters.lowercased())
                }
                else{
                    return false
                }
            }
            
            if arr.count > 0
            {
                airport_data_filtered_results = []
                airport_data_filtered_results = arr
            }
            else
            {
                airport_data_filtered_results = []
            }
        }
    }
}
