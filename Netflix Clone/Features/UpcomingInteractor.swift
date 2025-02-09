//
//  UpcomingInteractor.swift
//  Netflix Clone
//
//  Created by Нурбол Мухаметжан on 15.01.2025.
//

import Foundation

protocol UpcomingInteractorProtocol {
    func fetchMovies()
    func didTapMovie(at index: Int)
}

final class UpcomingInteractor: UpcomingInteractorProtocol {

    var presenter: UpcomingPresenterProtocol?
    private let apiCaller: APICaller
    private var titles: [Title] = []
    
    init(apiCaller: APICaller) {
        self.apiCaller = apiCaller
    }
    
    func fetchMovies() {
        apiCaller.getUpcomingMovies() { [weak self] result in
            switch result {
            case .success(let movies):
                self?.presenter?.presentMovie(UpcomingModels.FetchMovie.Response(movies: movies))
                self?.titles = movies
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func didTapMovie(at index: Int) {
        apiCaller.getMovie(with: titles[index].original_title ?? "") { [weak self] results in
            switch results{
            case .success(let videoElement):
                let titlePreviewViewModel = TitlePreviewViewModel(title: self?.titles[index].original_title ?? "",
                                                                  youtubeView: videoElement,
                                                                  titleOverview: self?.titles[index].overview ?? "")
                DispatchQueue.main.async {
                    self?.presenter?.didTapMovie(titlePreviewViewModel)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
