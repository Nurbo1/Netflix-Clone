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
    case invalidURL
    case decodingFailed
}

class APICaller{
    
    static let shared = APICaller()
    
    var searchResultTitles: [String:[Title]] = [:]
    
    private func createURL(for endpoint: String, additionalParameters: String? = nil) throws -> URL {
        let urlString = "\(endpoint)?api_key=\(Constants.API_KEY)\(additionalParameters ?? "")"
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        return url
    }
    
    private func handleResponse<T: Decodable>(_ data: Data) throws -> T {
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw APIError.decodingFailed
        }
    }
    
    private func fetchData(from url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.failedToGetData
        }
        return data
    }
    
    func getTrendingMovies() async throws -> [Title] {
        let url = try createURL(for: "\(Constants.BASE_URL)/3/movie/popular")
        let data = try await fetchData(from: url)
        let response: Titles = try handleResponse(data)
        return response.results
    }
    
    func getPopularMovies() async throws -> [Title] {
        let url = try createURL(for: "\(Constants.BASE_URL)/3/movie/popular")
        let data = try await fetchData(from: url)
        let response: Titles = try handleResponse(data)
        return response.results
    }
    
    func getTrendingTV() async throws -> [Title] {
        let url = try createURL(for: "\(Constants.BASE_URL)/3/trending/tv/day")
        let data = try await fetchData(from: url)
        let response: Titles = try handleResponse(data)
        return response.results
    }
    
    func getUpcomingMovies() async throws -> [Title] {
        let url = try createURL(for: "\(Constants.BASE_URL)/3/movie/upcoming")
        let data = try await fetchData(from: url)
        let response: Titles = try handleResponse(data)
        return response.results
    }
    
    func getTopRatedMovies() async throws -> [Title] {
        let url = try createURL(for: "\(Constants.BASE_URL)/3/movie/top_rated")
        let data = try await fetchData(from: url)
        let response: Titles = try handleResponse(data)
        return response.results
    }
    
    func discoverMovies() async throws -> [Title] {
        let url = try createURL(for: "\(Constants.BASE_URL)/3/discover/movie")
        let data = try await fetchData(from: url)
        let response: Titles = try handleResponse(data)
        return response.results
    }
    
    func searchMovies(with query: String) async throws -> [Title] {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw APIError.invalidURL
        }
        let url = try createURL(for: "\(Constants.BASE_URL)/3/search/movie?query=\(encodedQuery)&api_key=\(Constants.API_KEY)")
        let data = try await fetchData(from: url)
        let response: Titles = try handleResponse(data)
        return response.results
    }
    
    func getMovieFromYouTube(with query: String) async throws -> VideoElement {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw APIError.invalidURL
        }
        let url = try createURL(for: "\(Constants.YoutubeBase_URL)q=\(encodedQuery)&key=\(Constants.YoutubeAPI_KEY)")
        let data = try await fetchData(from: url)
        let response: YoutubeSearchResponse = try handleResponse(data)
        return response.items?.first ?? VideoElement(id: idVideoElement(kind: "", videoId: ""))
    }
    
    
    // MARK: - OLD IMPLEMENTATION
    
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
//                print(data)
                let decodedData = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                completion(.success(decodedData.items?[0] ?? VideoElement(id: idVideoElement(kind: "", videoId: ""))))
            }catch{
                completion(.failure(error))
                print(error)
            }        }.resume()
    }
}
