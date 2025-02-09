//
//  UpcomingModels.swift
//  Netflix Clone
//
//  Created by Нурбол Мухаметжан on 15.01.2025.
//

enum UpcomingModels {

  enum FetchMovie {

    struct Request {
    }

    struct Response {
        let movies: [Title]
    }

    struct ViewModel {
        let movies: [Movie]
    }
  }
}

struct Movie {
  let titleName: String
  let posterURL: String
}
