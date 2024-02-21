//
//  Movie.swift
//  Ticketek
//
//  Created by Venkata Prabhu on 21/10/23.
//  Copyright © 2023 Venkata Prabhu. All rights reserved.
//


import Foundation

struct MoviesData: Decodable {
    var movies: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

struct Movie: Decodable {
    let title: String?
    let year: String?
    let posterImage: String?
    let backdropImage: String?
    let overview: String?
    
    private enum CodingKeys: String, CodingKey {
        case title, overview
        case year = "release_date"
        case posterImage = "poster_path"
        case backdropImage = "backdrop_path"
    }
}

