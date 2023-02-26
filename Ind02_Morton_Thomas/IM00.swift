//
//  IM00.swift
//  Ind02_Morton_Thomas
//
//  Created by user on 2/26/23.
//

import UIKit

class IM00: UIView {
    var tile00: UIImage? = UIImage(named: "00.png")
    
    func draw00() {
        guard let tile00 = self.tile00
                
        else {
            print("tile00 not found")
            return
        }
        
        let p = CGPoint(
            x: (self.bounds.size.width - tile00.size.width) / 2,
            y: (self.bounds.size.height - tile00.size.height / 2))
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
