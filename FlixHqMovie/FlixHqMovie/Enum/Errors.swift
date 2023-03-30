//
//  Errors.swift
//  FlixHqMovie
//
//  Created by DuyThai on 27/03/2023.
//

import Foundation

enum DatabaseError: Error {
    case addFailed
    case deleteFailed
    case checkExistFailed
    case getAllMediaFailed
}

enum MovieStreamError: Error {
    case notFoundUrl
}
