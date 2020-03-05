//
//  CitySuggestionViewController.swift
//  KLM
//
//  Created by Goutham Devaraju on 05/03/20.
//  Copyright © 2020 Goutham. All rights reserved.
//

import UIKit

class CitySuggestionViewController: UIViewController {

    //MARK: - Properties
    var citySuggestionPresenter : CitySuggestionPresenter?
    
    //MARK: - ViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Initialising presenter objects
        self.citySuggestionPresenter = CitySuggestionPresenter(view: self)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CitySuggestionViewController: CitySuggestionViewProtocol{
    
    func fetchFlightDetailsAPI() {
        
    }
    
    func handleAirportDataResponse() {
        
    }
    
    func showLoaderAnimation() {
        
    }
    
    func initialTextFieldAnimation() {
        
    }
    
    
}

extension CitySuggestionViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CitySuggestionCellID", for: indexPath) as! CitySuggestionCell
        
        cell.selectionStyle = .none
        cell.labelAirport.text = "Just an Airport"
        cell.labelCountry.text = "Country: Africa"
        cell.labelRunwayLength.text = "Runway Length: 1938"
        
        return cell
        
    }
    
    
    
}

@IBDesignable
class ShadowView: UIView {
    //Shadow
    @IBInspectable var shadowColor: UIColor = UIColor.black {
        didSet {
            self.updateView()
        }
    }
    @IBInspectable var shadowOpacity: Float = 0.5 {
        didSet {
            self.updateView()
        }
    }
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 3, height: 3) {
        didSet {
            self.updateView()
        }
    }
    @IBInspectable var shadowRadius: CGFloat = 15.0 {
        didSet {
            self.updateView()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 15.0 {
        didSet {
            self.updateView()
        }
    }

    //Apply params
    func updateView() {
        self.layer.shadowColor = self.shadowColor.cgColor
        self.layer.shadowOpacity = self.shadowOpacity
        self.layer.shadowOffset = self.shadowOffset
        self.layer.shadowRadius = self.shadowRadius
        self.layer.cornerRadius = self.cornerRadius
    }
}
