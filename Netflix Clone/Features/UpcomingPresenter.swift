//
//  UpcomingPresenter.swift
//  Netflix Clone
//
//  Created by Нурбол Мухаметжан on 15.01.2025.
//

import Foundation

protocol UpcomingPresenterProtocol {
    func presentMovie(_ response: UpcomingModels.FetchMovie.Response)
    func didTapMovie(_ viewModel: TitlePreviewViewModel)
}

class UpcomingPresenter: UpcomingPresenterProtocol {
    weak var viewController: UpcomingViewProtocol?
    
    func presentMovie(_ response: UpcomingModels.FetchMovie.Response) {
        let movies = response.movies.map { title in
            return Movie(titleName: title.original_title ?? "", posterURL: title.poster_path ?? "")
        }
        let viewModel = UpcomingModels.FetchMovie.ViewModel(movies: movies)
        viewController?.showLoader()
        viewController?.displayUpcomingMovies(with: viewModel)
        viewController?.hideLoader()
        viewController?.reloadViews()
    }
    
    func didTapMovie(_ model: TitlePreviewViewModel) {
        viewController?.transitionToMovieDetails(with: model)
    }
}
