//
//  TheMovieDbApiClient.swift
//  OpenTmdb
//
//  Created by ingenico on 01/04/2022.
//

import Foundation

typealias ApiCallback<T> = (Result<T, NetworkRequestError>) -> Void
typealias MoviesCallback = (ApiCallback<Array<Movie>>) -> Void

class TheMovieDbApiClient {
    private var urlSession: URLSession
    private var apiKey: String
    
    init(urlSession: URLSession, apiKey: String) {
        self.urlSession = urlSession
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
        let dataTask = urlSession.dataTask(with: url) {	data, response, error in
            handleResponse(data: data, response: response, error: error, completionHandler: completionHandler, responseType: Array<Movie>.self)
        }
        dataTask.resume()
    }
    
    private func handleResponse<T>(data: Data?, response: URLResponse?, error: Error?, completionHandler: MoviesCallback, responseType: T.Type = T.self) {
        guard
            let data = data,
            let response = response as? HTTPURLResponse,
            response.statusCode == 200,
            error == nil
        else {
            print("Request failed.")
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let response = response as? HTTPURLResponse{
                print(response.statusCode)
                print(response.description)
            }
            
            return completionHandler(.failure(.connection))
        }
        
        print("Request successfull.")
        let decoder = JSONDecoder()
        do {
            let popularMovies = try decoder.decode(T.self, from: data)
            return completionHandler(.success(popularMovies.results))
            
        }
        catch {
            print("Decoding JSON failed \(error)")
            completionHandler(.failure(.decoding))
        }
    }
}
