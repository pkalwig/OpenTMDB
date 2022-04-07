//
//  TheMovieDbUrlBuilder.swift
//  OpenTmdb
//
//  Created by ingenico on 01/04/2022.
//

import Foundation

class TheMovieDbUrlBuilder {
    private var apiKey: String
    private var baseUrl: String
    
    init(apiKey: String) {
        self.baseUrl = AppSettings.apiBaseUrl
        self.apiKey = apiKey
    }
    
    func getPopularMoviesUrl() -> PopularMoviesUrlBuilder {
        return PopularMoviesUrlBuilder(baseUrl: baseUrl, apiKey: apiKey)
    }
}
