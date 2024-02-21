//
//  CoreData.swift
//  Ticketek
//
//  Created by Venkata Prabhu on 21/10/23.
//  Copyright © 2023 Venkata Prabhu. All rights reserved.
//

import UIKit
import CoreData

class CoreData {
    
    static let sharedInstance = CoreData()
    private init(){}
    let context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext

    func getAllItems() -> [MovieList]{
        
        var items = [MovieList]()
        do {
            
            items = try context.fetch(MovieList.fetchRequest())
        } catch {
            // error
        }
        return items
    }
    
    func createItem(data: Movie) {
        
        let newItem = MovieList(context: context)
        newItem.title = data.title
        newItem.year = data.year
        newItem.posterImage = data.posterImage
        newItem.backdropImage = data.backdropImage
        newItem.overview = data.overview
        
        do {
            try context.save()
        } catch {
            // error
        }
    }
    
    func deleteItem(item: MovieList) {
        context.delete(item)
        
        do {
            try context.save()
        } catch {
            // error
        }
    }
}
