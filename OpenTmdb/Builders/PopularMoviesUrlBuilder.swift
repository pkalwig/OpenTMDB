//
//  PopularMoviesUrlBuilder.swift
//  OpenTmdb
//
//  Created by ingenico on 07/04/2022.
//

import Foundation

class PopularMoviesUrlBuilder : UrlBuilderProtocol {
    private var apiKey: String
    private var baseUrl: String
    private let popularMoviesUrl = "/movie/popular"
    private var language: String?
    private var page: Int?
    private var region: String?
    
    init(baseUrl: String, apiKey: String) {
        self.baseUrl = baseUrl
        self.apiKey = apiKey
    }
    
    func build() -> URL {
        var url : URLComponents = URLComponents(string: baseUrl + popularMoviesUrl)!
        url.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        if language != nil && language != "" {
            url.queryItems?.append(URLQueryItem(name: "language", value: language))
        }
        
        if page != nil && page! > 0 {
            url.queryItems?.append(URLQueryItem(name: "page", value: String(page!)))
        }
        
        if region != nil && region! != "" {
            url.queryItems?.append(URLQueryItem(name: "region", value: region))
        }
        
        return url.url!
    }
    
    func setLanguage(_ language: String) -> Void {
        self.language = language
    }
    
    func setPage(_ page: Int) -> Void {
        self.page = page
    }
    
    func setRegion(_ region: String) -> Void {
        self.region = region
    }
}
