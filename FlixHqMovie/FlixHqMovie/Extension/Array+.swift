//
//  Array+.swift
//  FlixHqMovie
//
//  Created by DuyThai on 25/04/2023.
//

import Foundation

extension Array {

    var randomElement: Element {
        return self[Int.random(max: count - 1)]
    }

}
