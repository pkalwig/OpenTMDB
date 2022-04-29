//
//  OpenTmdbTests.swift
//  OpenTmdbTests
//
//  Created by ingenico on 23/04/2022.
//

import XCTest

@testable import OpenTmdb

class TheMovieDbApiClientTests: XCTestCase {
    private let movieDataStub = "{\"status_code\":7,\"status_message\":\"Invalid API key: You must be granted a valid key.\",\"success\":false}"
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetPopularMovies_emptyApiKey_unauthorized() {
        // arrange
        let apiKey = ""
        let url = TheMovieDbUrlBuilder(apiKey: apiKey).getPopularMoviesUrl().build()
        URLProtocolMock.data = [url: Data(movieDataStub.utf8) ]
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolMock.self]
        let urlSession = URLSession(configuration: sessionConfiguration)
        let apiClient = TheMovieDbApiClient(urlSession: urlSession, apiKey: apiKey)
        
        // act
        apiClient.getPopularMovies() { result in
                // expection
                // error
            
            // assert
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .unauthorized)
            default:
                break
            }
            
        }
    }
}
