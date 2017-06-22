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
    
    @IBOutlet weak var latitudeLabel: UILabel!
    
    @IBOutlet weak var longitudeLabel: UILabel!
    
    @IBOutlet weak var originCountryLabel: UILabel!
    
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
        self.addSubview(view)
    }

    func set(flight: Flight) {
        speedLabel.text = "\(flight.state.velocity!) km"
        altitudeLabel.text = "\(flight.state.altitude!) ft"
        latitudeLabel.text = "\(flight.state.latitude!) °"
        longitudeLabel.text = "\(flight.state.longitude!) °"
        originCountryLabel.text = "\(flight.state.originCountry) "


        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
