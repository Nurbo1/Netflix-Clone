//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Нурбол Мухаметжан on 16.06.2024.
//

import UIKit

class SearchViewController: UIViewController {
    
    var searchTimer: Timer?
    var titles: [Title] = [Title]()
    
    private let discoverTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    private let searchBarController: UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultsViewController())
        searchController.searchBar.placeholder = "Search for a Movie or a TV Show"
        searchController.searchBar.searchBarStyle = .minimal
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchBarController
        
        discoverTable.delegate = self
        discoverTable.dataSource = self
        discoverMovies()
        view.addSubview(discoverTable)
        searchBarController.searchResultsUpdater = self
    }
    
    func discoverMovies(){
        APICaller.shared.discoverMovies { results in
            switch results{
            case .success(let titles):
                self.titles = titles
                DispatchQueue.main.async{
                    self.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    override func viewDidLayoutSubviews() {
        discoverTable.frame = view.bounds
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else{
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: title.original_title ?? "unknown", posterUrl: title.poster_path ?? ""))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        discoverTable.deselectRow(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_title ?? title.title else {
            return
        }
        
        APICaller.shared.getMovie(with: titleName) { [weak self] results in
            switch results{
                
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.delegate = self
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate{
    
    func updateSearchResults(for searchController: UISearchController) {
        print("search")
        
        if(searchTimer?.isValid == true){
            return
        }
        
         searchTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] _ in
                     
            guard let self = self else { return }
               
               let searchBar = searchController.searchBar
               
               guard let query = searchBar.text,
                     !query.trimmingCharacters(in: .whitespaces).isEmpty,
                     query.trimmingCharacters(in: .whitespaces).count >= 3,
                     let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
                   print("problems with query")
                   return
               }
              
               
               
               resultsController.delegate = self
            
             print("request")
               APICaller.shared.search(with: query) { results in
                   DispatchQueue.main.async {
                       switch results {
                       case .success(let titles):
                           resultsController.titles = titles
                           resultsController.searchResultsCollectionView.reloadData()
                       case .failure(let error):
                           print(error.localizedDescription)
                       }
                   }
               }
            
            searchTimer?.invalidate()
           }
       }
    
    
    
//    func updateSearchResults(for searchController: UISearchController)  {
//        
//        searchTimer?.invalidate()
//        
//      
//            
//            guard let query = searchBar.text,
//                  !query.trimmingCharacters(in: .whitespaces).isEmpty,
//                  query.trimmingCharacters(in: .whitespaces).count >= 3,
//                  let resultsController = searchController.searchResultsController as? SearchResultsViewController else{
//                return
//            }
//            resultsController.delegate = self
//            
//            APICaller.shared.search(with: query) { results in
//                DispatchQueue.main.async {
//                    switch results{
//                    case .success(let titles):
//                        resultsController.titles = titles
//                        resultsController.searchResultsCollectionView.reloadData()
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                    }
//                }
//            }
//        
//    }
    
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SearchViewController: TitlePreviewViewControllerDelegate {
    func titlePreviewViewControllerDidTapDownload(_ viewController: TitlePreviewViewController, titleName: String) {
        guard let model = titles.first(where: { $0.original_title == titleName }) else {
            print("Model not found for title: \(titleName)")
            return
        }
        
        DataPersistenceManager.shared.downloadTitleWith(model: model) { result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
                    print("Download successful!")
                case .failure(let error):
                    print("Failed to download: \(error.localizedDescription)")
                }
            }
        }
    }
}
