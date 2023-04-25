//
//  Int+.swift
//  FlixHqMovie
//
//  Created by DuyThai on 25/04/2023.
//

import Foundation

extension Int {

    static func random(min: Int = 0, max: Int) -> Int {
        assert(min >= 0)
        assert(min < max)

        return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
    }

}
