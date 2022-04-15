//
//  TheMovieDbApiClient.swift
//  OpenTmdb
//
//  Created by ingenico on 01/04/2022.
//

import Foundation

typealias MoviesCallback = (Result<Array<Movie>, NetworkRequestError>) -> Void

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
        let dataTask = urlSession.dataTask(with: url) {data, response, error in
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
                let popularMovies = try decoder.decode(PagedResponse<Movie>.self, from: data)
                return completionHandler(.success(popularMovies.results))
                
            }
            catch {
                print("Decoding JSON failed \(error)")
                completionHandler(.failure(.decoding))
            }
        }
        
        dataTask.resume()
    }
}
