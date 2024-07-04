//
//  APICaller.swift
//  Netflix Clone
//
//  Created by Нурбол Мухаметжан on 16.06.2024.
//

import Foundation

struct Constants{
    static let API_KEY = "f2f9a961f3cda3551bb42d3694d326c0"
    static let BASE_URL = "https://api.themoviedb.org"
    static let YoutubeAPI_KEY = "AIzaSyDsIftUvbCcr1-sjxriqQwy3oAmtVeZ4Jc"
    static let YoutubeBase_URL = "https://youtube.googleapis.com/youtube/v3/search?"
}
enum APIError:Error{
    case failedToGetData
}

class APICaller{
    
    static let shared = APICaller()
    
    var searchResultTitles: [String:[Title]] = [:]
    
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void){
        guard let url = URL(string: "\(Constants.BASE_URL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else{
            print("DEBUG: Problem in URL")
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                print("DEBUG: Problem in fetching data")
                return
            }
            do{
                let decodedData = try JSONDecoder().decode(Titles.self, from: data)
                completion(.success(decodedData.results))
            }catch{
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getPopular(completion: @escaping (Result<[Title], Error>) -> Void){
        guard let url = URL(string: "\(Constants.BASE_URL)/3/movie/popular?api_key=\(Constants.API_KEY)") else{
            print("DEBUG: Problem in URL")
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                print("DEBUG: Problem in fetching data")
                return
            }
            do{
                let decodedData = try JSONDecoder().decode(Titles.self, from: data)
                completion(.success(decodedData.results))
            }catch{
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getTrendingTv(completion: @escaping (Result<[Title], Error>) -> Void){
        guard let url = URL(string: "\(Constants.BASE_URL)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else{
            print("DEBUG: Problem in URL")
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                print("DEBUG: Problem in fetching data")
                return
            }
            do{
                let decodedData = try JSONDecoder().decode(Titles.self, from: data)
                completion(.success(decodedData.results))
            }catch{
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>) -> Void){
        guard let url = URL(string: "\(Constants.BASE_URL)/3/movie/upcoming?api_key=\(Constants.API_KEY)") else{
            print("DEBUG: Problem in URL")
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                print("DEBUG: Problem in fetching data")
                return
            }
            do{
                let decodedData = try JSONDecoder().decode(Titles.self, from: data)
                completion(.success(decodedData.results))
            }catch{
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getTopRated(completion: @escaping (Result<[Title], Error>) -> Void){
        guard let url = URL(string: "\(Constants.BASE_URL)/3/movie/top_rated?api_key=\(Constants.API_KEY)") else{
            print("DEBUG: Problem in URL")
            return
        }

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                print("DEBUG: Problem in fetching data")
                return
            }
            do{
                let decodedData = try JSONDecoder().decode(Titles.self, from: data)
                completion(.success(decodedData.results))
            }catch{
                completion(.failure(error))
            }
        }.resume()
    }
    
    func discoverMovies(completion: @escaping (Result<[Title], Error>) -> Void){
        guard let url = URL(string: "\(Constants.BASE_URL)/3/discover/movie?api_key=\(Constants.API_KEY)") else{
            print("DEBUG: Problem in URL")
            return
        }

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                print("DEBUG: Problem in fetching data")
                return
            }
            do{
                let decodedData = try JSONDecoder().decode(Titles.self, from: data)
                completion(.success(decodedData.results))
            }catch{
                completion(.failure(error))
            }
        }.resume()
    }
    
    func search(with query: String, completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        for key in searchResultTitles.keys{
            if key == query{
                print("From cache")
                completion(.success(searchResultTitles[key]!))
                return
            }
        }
            
        guard let url = URL(string: "\(Constants.BASE_URL)/3/search/movie?query=\(query)&api_key=\(Constants.API_KEY)") else{
            print("DEBUG: Problem in URL")
            return
        }

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                print("DEBUG: Problem in fetching data")
                return
            }
            do{
                print("real search")

                let decodedData = try JSONDecoder().decode(Titles.self, from: data)
                self.searchResultTitles[query] = decodedData.results
                completion(.success(decodedData.results))
            }catch{
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void){
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.YoutubeBase_URL)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else{
            print("DEBUG: Problem in URL")
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                print("DEBUG: Problem in fetching data")
                return
            }
            do{
                print(data)
                let decodedData = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                completion(.success(decodedData.items?[0] ?? VideoElement(id: idVideoElement(kind: "", videoId: ""))))
            }catch{
                completion(.failure(error))
                print(error)
            }        }.resume()
    }
}
