//
//  DataPersistenceManager.swift
//  Netflix Clone
//
//  Created by Нурбол Мухаметжан on 20.06.2024.
//

import Foundation
import CoreData
import UIKit

class DataPersistenceManager{
    
    enum DatabaseError: Error{
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    
    static let shared = DataPersistenceManager()
     
    func downloadTitleWith(model: Title, completion: @escaping ((Result<Void, Error>) -> Void) ){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItem(context: context)
        item.title = model.original_title
        item.id = Int64(model.id)
        item.overview = model.overview
        item.media_type = model.media_type
        item.original_title = model.original_title
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_average = model.vote_average
        item.vote_count = Int64(model.vote_count)
        
        do{
            try context.save()
            completion(.success(()))
        }catch{
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }
    
    func fetchTitlesFromDatabase(completion: @escaping(Result<[TitleItem], Error>) -> Void ){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleItem>
        request = TitleItem.fetchRequest()
        
        do{
            let titles = try context.fetch(request)
            completion(.success(titles))
        }catch{
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    
    func deleteTitlesFromDatabase(with model: TitleItem, completion: @escaping(Result<Void, Error>) -> Void ){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do{
            try context.save()
            completion(.success(()))
        }catch{
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
}
