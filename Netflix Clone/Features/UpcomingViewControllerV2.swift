//
//  UpcomingViewControllerV2.swift
//  Netflix Clone
//
//  Created by Нурбол Мухаметжан on 15.01.2025.
//

import Foundation
import UIKit

protocol UpcomingViewProtocol: AnyObject {
    func displayUpcomingMovies(with viewModel: UpcomingModels.FetchMovie.ViewModel)
    func transitionToMovieDetails(with movie: TitlePreviewViewModel)
    func reloadViews()
    func showLoader()
    func hideLoader()
}

class UpcomingViewControllerV2: UIViewController {
    var interactor: UpcomingInteractorProtocol?
    var movies: [Movie] = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        return activityIndicator
    }()
    
    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
}

extension UpcomingViewControllerV2 {
    private func setup() {
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
        view.addSubview(upcomingTable)
        
        let interactor = UpcomingInteractor(apiCaller: APICaller())
        let presenter = UpcomingPresenter()
        
        interactor.presenter = presenter
        presenter.viewController = self
        
        self.interactor = interactor
        interactor.fetchMovies()
    }
}

extension UpcomingViewControllerV2: UpcomingViewProtocol {
    func showLoader() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    
    func reloadViews() {
        DispatchQueue.main.async {
            self.upcomingTable.reloadData()
        }
    }
    
    func transitionToMovieDetails(with movie: TitlePreviewViewModel) {
        let vc = TitlePreviewViewController()
        vc.delegate = self as? any TitlePreviewViewControllerDelegate
        vc.configure(with: movie)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func displayUpcomingMovies(with viewModel: UpcomingModels.FetchMovie.ViewModel) {
        movies = viewModel.movies
    }
}

extension UpcomingViewControllerV2: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else{
            fatalError()
        }
        cell.configure(with: SearchViewModel(imageURL: movies[indexPath.row].posterURL, title: movies[indexPath.row].titleName))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension UpcomingViewControllerV2: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        upcomingTable.deselectRow(at: indexPath, animated: true)
        interactor?.didTapMovie(at: indexPath.row)
    }
}
