//
//  PopoverView.swift
//  GoogleMapsAPI
//
//  Created by Masato Miyazawa on 2017-06-21.
//  Copyright © 2017 Luis Alfredo Ramirez. All rights reserved.
//

import UIKit

class PopoverView: UIView {
    
    @IBOutlet weak var label: UILabel!
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

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
