//
//  PopoverView.swift
//  GoogleMapsAPI
//
//  Created by Masato Miyazawa on 2017-06-21.
//  Copyright © 2017 Luis Alfredo Ramirez. All rights reserved.
//

import UIKit

class PopoverView: UIView {
    @IBOutlet weak var speedLabel: UILabel!
    
    @IBOutlet weak var altitudeLabel: UILabel!
    
    @IBOutlet weak var popoverView: PopoverView!
    
    @IBOutlet weak var latitudeLabel: UILabel!
    
    @IBOutlet weak var longitudeLabel: UILabel!
    
    @IBOutlet weak var originCountryLabel: UILabel!
    
    @IBOutlet weak var flagImageView: UIImageView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadXibView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadXibView() {
        let view = Bundle.main.loadNibNamed( "Popover", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        popoverView.layer.cornerRadius = 15
        popoverView.clipsToBounds = true
        popoverView.layer.borderWidth = 1
        popoverView.layer.borderColor = UIColor.lightGray.cgColor
        self.addSubview(view)
    }

    func set(flight: Flight) {
        speedLabel.text = "\(flight.state.velocity!) km"
        altitudeLabel.text = "\(flight.state.altitude!) ft"
        latitudeLabel.text = "\(flight.state.latitude!) °"
        longitudeLabel.text = "\(flight.state.longitude!) °"
        originCountryLabel.text = "\(flight.state.originCountry) "

        setFlagImage(for: flight.state.originCountry)
        print("\(flight.state.originCountry)")
    }
    
    func setFlagImage(for countryName: String) {
        var flagFileName: String!
        
        switch countryName {
        case "Canada":
            flagFileName = "Canada"
        case "United States":
            flagFileName = "United States"  // TODO replace
        case "Japan":
            flagFileName = "Japan"
        case "Germany":
            flagFileName = "Germany"
        case "United Kingdom":
            flagFileName = "United Kingdom"
        case "Taiwan":
            flagFileName = "Taiwan"
        case "Mexico":
            flagFileName = "Mexico"
        case "Philippines":
            flagFileName = "Philippines"
        case "Switzerland":
            flagFileName = "Switzerland"
        case "China":
            flagFileName = "China"
        case "South Korea":
            flagFileName = "South Korea"
        case "Italy":
            flagFileName = "Italy"
            
        default:
            flagFileName = "default" // TODO replace with default one
        }
        
        flagImageView.layer.borderWidth = 1
        flagImageView.layer.borderColor = UIColor.lightGray.cgColor
        flagImageView.image = UIImage(named: flagFileName)
        if flagImageView.image == nil {
            print("oooops")
        }
//        flagImageView.image = #imageLiteral(resourceName: "Canada")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}