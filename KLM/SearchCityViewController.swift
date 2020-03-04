//
//  SearchCityViewController.swift
//  KLM
//
//  Created by Goutham Devaraju on 04/03/20.
//  Copyright © 2020 Goutham. All rights reserved.
//

import UIKit

class SearchCityViewController: UIViewController {

    //MARK: - Properties
    var searchCityPresenter : SearchCityPresenter?
    var loader_view = VDSCircleAnimation()
    
    @IBOutlet var textFieldSearch: UITextField!
    @IBOutlet var tableViewSearchResult: UITableView!
    
    @IBOutlet var constraint_textField_centerY: NSLayoutConstraint!
    @IBOutlet var constraint_textField_top: NSLayoutConstraint!
    
    //MARK: - ViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Initialising presenter objects
        self.searchCityPresenter = SearchCityPresenter(view: self)
        
        //Fetch fligt
        fetchFlightDetailsAPI()
        registerTableViewCell()
    }

}

extension SearchCityViewController: SearchCityViewProtocol{
    
    func fetchFlightDetailsAPI() {
        
        showLoaderAnimation()
        searchCityPresenter?.fetchFlightDetails()
    }
    
    func handleAirportDataResponse() {
        
        //Stop loader
        loader_view.removeFromSuperview()
        
        //Unhide textField after loading data
        textFieldSearch.isHidden = false
        tableViewSearchResult.reloadData()
    }
    
    func showLoaderAnimation(){

        loader_view = VDSCircleAnimation(frame: CGRect(x: view.frame.width/2-(view.frame.width/5)/2, y: view.frame.height/2-(view.frame.height/5)/2, width: view.frame.width/5, height: view.frame.height/5))
        view.addSubview(loader_view)
    }
    
    func initialTextFieldAnimation(){
        
        constraint_textField_centerY.isActive = false
        constraint_textField_top.isActive = true
        constraint_textField_top.constant = 60
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func registerTableViewCell(){
        self.tableViewSearchResult.register(UITableViewCell.self, forCellReuseIdentifier: "SearchCell")

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textFieldSearch.resignFirstResponder()
    }
}

extension SearchCityViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        initialTextFieldAnimation()
    }
}

extension SearchCityViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let data_airport = searchCityPresenter?.airport_data{
            return data_airport.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)

        if let data_airport = searchCityPresenter?.airport_data{
            
            let data_im = data_airport[indexPath.row]

            if let city = data_im.city{
                cell.textLabel?.text = city
            }
        }
        
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        cell.textLabel?.textColor = UIColor(red: 0/255.0, green: 161/255.0, blue: 229/255.0, alpha: 1.0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let data_airport = searchCityPresenter?.airport_data{
            
            let data_im = data_airport[indexPath.row]

            if let city = data_im.city{
                print("Selected city: \(city)")
            }
        }
    }
}
