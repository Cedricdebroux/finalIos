//
//  Latest.swift
//  finalIos
//
//  Created by Cédric Debroux on 10/11/2022.
//


import Foundation

// MARK: - MovieModel
struct MovieModel: Codable {
    
    let results: [Movie]
    let page: Int
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case results
        case page
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
}

// MARK: - Results
struct Movie: Codable , Hashable, Identifiable{
    let voteAverage: CGFloat
    let posterPath: String?
    let id: Int
    let genreIDS: [Int]?
    let overview: String
    let title: String?
    let backdropPath: String?
    let releaseDate: String?
    enum CodingKeys: String, CodingKey {
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case id
        case genreIDS = "genre_ids"
        case overview
        case title
        case backdropPath = "backdrop_path"
    }
    
}
