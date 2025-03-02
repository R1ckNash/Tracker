//
//  UIView+addGradientBorder.swift
//  Tracker
//
//  Created by Ilia Liasin on 27/02/2025.
//

import UIKit

extension UIView {
    
    func addGradientBorder() {
        layer.sublayers?.filter { $0.name == "gradientBorder" }.forEach { $0.removeFromSuperlayer() }
        
        let gradient = CAGradientLayer.gradientBorderLayer(in: self.bounds)
        gradient.name = "gradientBorder"
        
        let shape = CAShapeLayer()
        let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius)
        shape.path = path.cgPath
        shape.lineWidth = 1 
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.black.cgColor
        
        gradient.mask = shape
        layer.addSublayer(gradient)
    }
}
