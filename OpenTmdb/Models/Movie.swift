//
//  Movie.swift
//  OpenTmdb
//
//  Created by ingenico on 01/04/2022.
//

import Foundation

struct Movie : Codable {
    let posterPath: String
    let adult: Bool
    let overview: String
    let releaseDate: String
    let genreIds: [Int]
    let id: Int
    let originalTitle: String
    let originalLanguage: String
    let title: String
    let backdropPath: String
    let popularity: Double
    let voteCount: Int
    let video: Bool
    let voteAverage: Double
}
