//
//  YoutubeSearchResponse.swift
//  Netflix Clone
//
//  Created by Нурбол Мухаметжан on 18.06.2024.
//

import Foundation


struct YoutubeSearchResponse:Codable{
    let items: [VideoElement]?
}

struct VideoElement:Codable{
    let id: idVideoElement
}

struct idVideoElement:Codable{
    let kind: String
    let videoId: String
}
