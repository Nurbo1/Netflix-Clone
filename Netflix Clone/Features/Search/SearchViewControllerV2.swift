//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Нурбол Мухаметжан on 10.01.2025.
//

import UIKit

protocol SearchViewProtocol: AnyObject {
    func openMovieDetails(with model: TitlePreviewViewModel)
    func showSearchResults(with models: [Title])
    func reloadViews()
    func showLoader()
    func hideLoader()
}

final class SearchViewControllerV2: UIViewController {
    
    private let presenter: SearchPresenterProtocol

    init(presenter: SearchPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        (presenter as? SearchPresenter)?.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var loader = UIActivityIndicatorView()
    
    private lazy var discoverTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    private lazy var searchBarController: UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultsViewController())
        searchController.searchBar.placeholder = "Search for a Movie or a TV Show"
        searchController.searchBar.searchBarStyle = .minimal
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        discoverTable.frame = view.bounds
    }
    
}

extension SearchViewControllerV2: SearchViewProtocol {
    func showSearchResults(with models: [Title]) {
        if let resultsVC = searchBarController.searchResultsController as? SearchResultsViewController {
            resultsVC.titles = models
            resultsVC.delegate = self
            resultsVC.searchResultsCollectionView.reloadData()
        }
    }
    
    func openMovieDetails(with model: TitlePreviewViewModel) {
        let vc = TitlePreviewViewController()
        vc.delegate = self as? any TitlePreviewViewControllerDelegate
        vc.configure(with: model)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func reloadViews() {
        discoverTable.reloadData()
    }
    
    func showLoader() {
        loader.startAnimating()
    }
    
    func hideLoader() {
        loader.stopAnimating()
    }
    
}

private extension SearchViewControllerV2 {
    func setup(){
        view.backgroundColor = .systemBackground
        
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchBarController
        
        
        discoverTable.delegate = self
        discoverTable.dataSource = self
        view.addSubview(discoverTable)
        searchBarController.searchResultsUpdater = self
    }
}

extension SearchViewControllerV2:  UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else{
            fatalError()
        }
        cell.configure(with: presenter.viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension SearchViewControllerV2: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        discoverTable.deselectRow(at: indexPath, animated: true)
        presenter.didTapMovie(at: indexPath.row)
    }
}

extension SearchViewControllerV2: UISearchResultsUpdating, SearchResultsViewControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
            print("problems with query")
            return
        }
        presenter.didChangeSearchQuery(newValue: query)
    }
    

    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel) {
        presenter.didTapSearchResultMovie(with: viewModel)
    }
}
