//
//  PagedResponse.swift
//  OpenTmdb
//
//  Created by ingenico on 01/04/2022.
//

import Foundation

struct PagedResponse<T> : Codable where T : Codable {
    let page: Int
    let results: [T]
    let totalResults: Int
    let totalPages: Int
}
