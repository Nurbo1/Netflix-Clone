//
//  Movie.swift
//  Netflix Clone
//
//  Created by Нурбол Мухаметжан on 17.06.2024.
//

import Foundation

struct Titles:Codable{
    let results: [Title]
}

struct Title:Codable{
    let id: Int
    let original_title: String?
    let overview: String?
    let poster_path: String?
    let media_type: String?
    let release_date: String?
    let vote_average: Double
    let vote_count: Int
}
