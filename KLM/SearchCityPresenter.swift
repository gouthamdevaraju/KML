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
        
//        airport_data = flight_data.sorted()
        
        //Sorting array alphabatically
//        airport_data = flight_data.sorted(by: { (Obj1, Obj2) -> Bool in
//           let Obj1_Name = Obj1.city
//           let Obj2_Name = Obj2.city
//            return (Obj1_Name!.localizedCaseInsensitiveCompare(Obj2_Name!) == .orderedAscending)
//        })
        
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
}
