//
//  TheMovieDbApiClient.swift
//  OpenTmdb
//
//  Created by ingenico on 01/04/2022.
//

import Foundation

class TheMovieDbApiClient {
    var urlSession: URLSession
    var apiKey: String
    
    init(urlSession: URLSession, apiKey: String) {
        self.urlSession = urlSession
        self.apiKey = apiKey
    }
    
    // nest Movies.getPopular(_:_:)
    // build completionHandler here, pass basic handlers from VM
    
    func getPopularMovies(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void,
                          language: String? = nil,
                          page: Int? = nil,
                          region: String? = nil) -> URLSessionDataTask {
        let url = TheMovieDbUrlBuilder(apiKey: self.apiKey)
            .getPopularMoviesUrl()
            .setLanguage(language)
            .setPage(page)
            .setRegion(region)
            .build()
        return urlSession.dataTask(with: url, completionHandler: completionHandler)
    }
}
