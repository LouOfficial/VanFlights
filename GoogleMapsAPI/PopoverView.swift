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

    func set(flight: Flight?) {
        if let f = flight {
            speedLabel.text = "\(f.state.velocity!) km"
            altitudeLabel.text = "\(f.state.altitude!) ft"
            latitudeLabel.text = "\(f.state.latitude!) °"
            longitudeLabel.text = "\(f.state.longitude!) °"
            originCountryLabel.text = "\(f.state.originCountry) "

            setFlagImage(for: f.state.originCountry)
        }
        else {
            speedLabel.text = "- km"
            altitudeLabel.text = "- ft"
            latitudeLabel.text = "- °"
            longitudeLabel.text = "- °"
            originCountryLabel.text = "(N/A)"
            
            setFlagImage(for: "")
        }
    }
    
    func setFlagImage(for countryName: String) {
        var flagFileName: String!
        
        switch countryName {
        case "Canada":
            flagFileName = "Canada"
        case "United States":
            flagFileName = "United States"
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
            
            // TODO add "Brazil"
            
        default:
            flagFileName = "default"
        }
        
        flagImageView.layer.borderWidth = 1
        flagImageView.layer.borderColor = UIColor.lightGray.cgColor
        flagImageView.image = UIImage(named: flagFileName)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
