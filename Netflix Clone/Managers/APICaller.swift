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
}
enum APIError:Error{
    case failedToGetData
}

class APICaller{
    static let shared = APICaller()
    
    
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
        print(url)
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
        print(url)
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
    
    func search(with query: String, completion: @escaping (Result<[Title], Error>) -> Void){
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
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
                let decodedData = try JSONDecoder().decode(Titles.self, from: data)
                completion(.success(decodedData.results))
            }catch{
                completion(.failure(error))
            }
        }.resume()
    }
}
