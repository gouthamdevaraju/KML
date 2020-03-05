//
//  CitySuggestionCell.swift
//  KLM
//
//  Created by Goutham Devaraju on 05/03/20.
//  Copyright © 2020 Goutham. All rights reserved.
//

import UIKit

class CitySuggestionCell: UITableViewCell {

    @IBOutlet var labelAirport: UILabel!
    @IBOutlet var labelCountry: UILabel!
    @IBOutlet var labelRunwayLength: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
