//
//  UILabel+.swift
//  FlixHqMovie
//
//  Created by DuyThai on 15/03/2023.
//

import Foundation
import UIKit

extension UILabel {
    func makeCornerRadius(radious: CGFloat) {
        self.layer.cornerRadius = radious
        self.layer.masksToBounds = true
    }

    func setMargins(margin: CGFloat = 10) {
           if let textString = self.text {
               var paragraphStyle = NSMutableParagraphStyle()
               paragraphStyle.firstLineHeadIndent = margin
               paragraphStyle.headIndent = margin
               paragraphStyle.tailIndent = -margin
               let attributedString = NSMutableAttributedString(string: textString)
               attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
               attributedText = attributedString
           }
       }
}
