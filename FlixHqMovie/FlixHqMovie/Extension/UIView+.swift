//
//  UIView+.swift
//  FlixHqMovie
//
//  Created by DuyThai on 08/03/2023.
//

import Foundation
import UIKit

extension UIView {
    func setGradientBackground(colorTop: CGColor, colorBottom: CGColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
        self.layer.addSublayer(gradientLayer)
    }

    func applyCircleView() {
        self.layer.cornerRadius = self.frame.height / 2
    }
}
