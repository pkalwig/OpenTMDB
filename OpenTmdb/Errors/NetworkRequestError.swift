//
//  NetworkRequestError.swift
//  OpenTmdb
//
//  Created by ingenico on 15/04/2022.
//

import Foundation

enum NetworkRequestError : Error {
    case connection
    case notfound
    case unauthorized
    case unexpectedData
}
