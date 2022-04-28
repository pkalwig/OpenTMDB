//
//  TheMovieDbApiClient.swift
//  OpenTmdb
//
//  Created by ingenico on 01/04/2022.
//

import Foundation

typealias ApiCallback<T> = (Result<T, NetworkRequestError>) -> Void
typealias MoviesCallback = (Result<Array<Movie>, NetworkRequestError>) -> Void

class TheMovieDbApiClient {
    private static let applicationJsonMimeType : String = "application/json"
    
    private var urlSession: URLSession
    private var apiKey: String
    
    init(urlSessionProvider: UrlSessionProviderProtocol, apiKey: String) {
        self.urlSession = urlSessionProvider.get()
        self.apiKey = apiKey
    }
    
    func getPopularMovies(completionHandler: @escaping MoviesCallback,
                          language: String? = nil,
                          page: Int? = nil,
                          region: String? = nil) {
        let url = TheMovieDbUrlBuilder(apiKey: self.apiKey)
            .getPopularMoviesUrl()
            .setLanguage(language)
            .setPage(page)
            .setRegion(region)
            .build()
        get(PagedResponse<Movie>.self, with: url) { pagedResponse in
            completionHandler(.success(pagedResponse.results))
        } onError: { error in
            print(error.localizedDescription)
        }
    }
    
    private func get<T : Decodable>(_ type: T.Type, with url: URL, onSuccess: @escaping (T) -> Void, onError: @escaping (Error) -> Void) {
        let dataTask = urlSession.dataTask(with: url) { data, response, error in
            if let error = error {
                onError(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse
            else {
                onError(NetworkRequestError.connection)
                return
            }
            
            if httpResponse.statusCode == 401 {
                onError(NetworkRequestError.unauthorized)
                return
            }
            
            if httpResponse.statusCode == 404 {
                onError(NetworkRequestError.notfound)
                return
            }
            
            guard
                httpResponse.statusCode == 200,
                let mimeType = httpResponse.mimeType, mimeType == TheMovieDbApiClient.applicationJsonMimeType,
                let data = data
            else {
                onError(NetworkRequestError.unexpectedData)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let dataDecoded = try decoder.decode(type, from: data)
                return onSuccess(dataDecoded)
            }
            catch {
                onError(error)
                return
            }
        }
        dataTask.resume()
    }
}
