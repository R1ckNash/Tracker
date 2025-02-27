//
//  CAGradientLayer+gradientBorderLayer.swift
//  Tracker
//
//  Created by Ilia Liasin on 27/02/2025.
//

import UIKit

extension CAGradientLayer {
    
    static func gradientBorderLayer(in frame: CGRect) -> Self {
        
        let layer = Self()
        layer.frame = frame
        layer.colors = [
            UIColor(red: 253/255, green: 76/255, blue: 73/255, alpha: 1).cgColor,
            UIColor(red: 70/255, green: 230/255, blue: 157/255, alpha: 1).cgColor,
            UIColor(red: 0/255, green: 123/255, blue: 250/255, alpha: 1).cgColor
        ]
        
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        return layer
    }
}
