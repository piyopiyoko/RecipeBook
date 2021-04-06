//
//  Coredata.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2020/08/05.
//  Copyright © 2020 Aimi Itagaki. All rights reserved.
//

import UIKit
import CoreData

class CoreDataRepository {
    
    func insert(entityName: String, params: (key: String, value: Any)...) -> Bool {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: viewContext)
        let newRecord = NSManagedObject(entity: entity!, insertInto: viewContext)
        
        for param in params {
            newRecord.setValue(param.value, forKey: param.key)
        }
        newRecord.setValue(getLastOrder(entityName: entityName), forKey: "order")
        
        do {
            try viewContext.save()
        } catch {
            return false
        }
        
        return true
    }
    
    func load<T: AnyObjectModel>(entityName: String) -> [T] {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let query = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        query.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        
        var dictionary = [T]()
        do {
            let t = try viewContext.fetch(query)
            dictionary = t.map { T(obj: $0 as AnyObject) }
        } catch {
        }
        
        return dictionary
    }
    
    
    func delete(entityName: String, queryValue: [String: String]) -> Bool {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let query = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        queryValue.forEach {
            query.predicate = NSPredicate(format: $0.key, $0.value)
        }
        
        do {
            let t = try viewContext.fetch(query)
            guard let obj = t.first as? NSManagedObject else { return false }
            viewContext.delete(obj)
            try viewContext.save()
        } catch {
            return false
        }
        
        return true
    }
    
    private func getLastOrder(entityName: String) -> Int {
        let query = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        
        var lastId: Int = 0
        do {
            let sortDesc = NSSortDescriptor(key: "order", ascending: false)
            query.sortDescriptors = [sortDesc]
            
            let fetchResults = try viewContext.fetch(query)
            if let id: Int = (fetchResults[0] as AnyObject).value(forKey: "order") as? Int {
                lastId = id
            }
        } catch {
        }
        
        return lastId + 1
    }
}
