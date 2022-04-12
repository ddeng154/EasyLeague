//
//  UI.swift
//  EasyLeague
//
//  Created by Aly Hirani on 4/8/22.
//

import UIKit

extension UIColor {
    
    class var appBackground: UIColor { .systemBackground }
    
    class var appAccent: UIColor { .systemTeal }
    
}

extension UIImage {
    
    static func pixel(ofColor color: UIColor) -> UIImage {
        let pixel = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(pixel.size)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        context.setFillColor(color.cgColor)
        context.fill(pixel)
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
    
}

extension UIButton {
    
    func setBackgroundColor(_ backgroundColor: UIColor, for state: UIControl.State) {
        setBackgroundImage(UIImage.pixel(ofColor: backgroundColor), for: .normal)
    }
    
}
