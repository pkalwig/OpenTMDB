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
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                error == nil
            else {
                print("Request failed.")
                if let error = error {
                    onError(error)
                }
                
                if let response = response as? HTTPURLResponse{
                    print(response.statusCode)
                    print(response.description)
                }
                
                return onError(NetworkRequestError.connection)
            }
            
            print("Request successfull.")
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(type, from: data)
                return onSuccess(response)
            }
            catch {
                print("Decoding JSON failed \(error)")
                onError(error)
            }
        }
        dataTask.resume()
    }
}
