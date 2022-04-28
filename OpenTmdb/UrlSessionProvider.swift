//
//  UrlSessionProviderProtocol.swift
//  OpenTmdb
//
//  Created by ingenico on 28/04/2022.
//

import Foundation

protocol UrlSessionProviderProtocol {
    static var instance: UrlSessionProviderProtocol { get }
    func get() -> URLSession
}

class UrlSessionProvider : UrlSessionProviderProtocol {
    private init() {
    }
    
    static var instance: UrlSessionProviderProtocol = UrlSessionProvider()
    
    func get() -> URLSession {
        return URLSession.shared
    }
}
