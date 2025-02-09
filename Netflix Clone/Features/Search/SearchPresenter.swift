//
//  SearchPresenter.swift
//  Netflix Clone
//
//  Created by Нурбол Мухаметжан on 10.01.2025.
//

import Foundation

protocol SearchPresenterProtocol {
    var viewModels: [SearchViewModel] { get }
    func didTapMovie(at index: Int)
    func didChangeSearchQuery(newValue: String)
    func didTapSearchResultMovie(with model: TitlePreviewViewModel)
    func viewDidLoad()
}

class SearchPresenter {
    weak var view: SearchViewProtocol?
    private let apiCaller: APICaller
    private var titles: [Title] = []
    
    init(view: SearchViewProtocol? = nil, apiCaller: APICaller) {
        self.view = view
        self.apiCaller = apiCaller
    }
}

extension SearchPresenter: SearchPresenterProtocol {
    func didTapSearchResultMovie(with model: TitlePreviewViewModel) {
        DispatchQueue.main.async {
            self.view?.openMovieDetails(with: model)
        }
    }
    
    var viewModels: [SearchViewModel] {
        return titles.map { title in
            return SearchViewModel(imageURL: title.poster_path ?? "", title: title.original_title ?? "Heyyp")
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
                    self?.view?.openMovieDetails(with: titlePreviewViewModel)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func didChangeSearchQuery(newValue: String) {
        apiCaller.search(with: newValue) { [weak self] results in
            DispatchQueue.main.async {
                switch results {
                case .success(let titles):
                    self?.view?.showSearchResults(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func viewDidLoad() {
        view?.showLoader()
        apiCaller.discoverMovies { [weak self] results in
            switch results{
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async{
                    self?.view?.hideLoader()
                    self?.view?.reloadViews()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
