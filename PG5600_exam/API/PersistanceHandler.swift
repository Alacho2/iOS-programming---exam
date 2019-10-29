//
//  PersistanceHandler.swift
//  PG5600_exam
//
//  Created by Håvard on 29/10/2019.
//  Copyright © 2019 Håvard. All rights reserved.
//

import Foundation
import CoreData

class PersistanceHandler {
  // MARK: - Core Data stack
  
  private init() {}
  
  static var context: NSManagedObjectContext {
    return persistentContainer.viewContext
  }

  static var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "PG5600_exam")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()

  // MARK: - Core Data Saving support

  static func saveContext () {
    let context = persistentContainer.viewContext;
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
}
