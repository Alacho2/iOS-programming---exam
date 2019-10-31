//
//  FavController.swift
//  PG5600_exam
//
//  Created by Håvard on 17/10/2019.
//  Copyright © 2019 Håvard. All rights reserved.
//

import UIKit
import CoreData

class FavController: UIViewController, NSFetchedResultsControllerDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  lazy var fetchedResultsController: NSFetchedResultsController<Track> = {
    let fetchReq = NSFetchRequest<Track>(entityName: "Track");
    fetchReq.sortDescriptors = [NSSortDescriptor(key: "sortId", ascending: false)];
    
    let context = PersistanceHandler.context
    
    let frc = NSFetchedResultsController(
      fetchRequest: fetchReq,
      managedObjectContext: context,
      sectionNameKeyPath: nil,
      cacheName: nil);
    frc.delegate = self;
    return frc
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("You are in fav");
    
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.isEditing = true;
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated);
    getDbData();
    //print("Back in business")
  }
  
  func getDbData(){
    do {
      try fetchedResultsController.performFetch()
      
      if fetchedResultsController.sections?[0].objects as? [Track] != nil {
        self.tableView.reloadData();
      }
      
      //print(type(of: fetchedResultsController.fetchedObjects))
      //print(fetchedResultsController.object(at: IndexPath(item: 0, section: 0)))
    } catch let err {
      print("Something went terribly wrong \(err)")
    }
  }
  
  func deleteItem(_ id: NSManagedObject) {
    do {
      PersistanceHandler.context.delete(id);
      try PersistanceHandler.context.save()
    } catch {
      print("Couldn't delete the item");
    }
  }
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates();
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates();
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
      print("\(type)");
    /*if type == .insert {
      tableView.insertRows(at: [newIndexPath!], with: .automatic)
    }
    
    if type == NSFetchedResultsChangeType.move {
      print("Moved \(indexPath?.row) to \(newIndexPath?.row)");
    } */
    
    switch type {
      case .insert:
        print("Looking for insert");
      case .delete:
        print("Looking for delete");
      case .move:
        print("Looking for move");
      case .update:
        
      print("Looking for update")
      @unknown default:
        print("Looking for default")
    }
    
    /*if type == .delete {
      tableView.deleteRows(at: [indexPath!], with: .automatic)
    } */
  }

}

extension FavController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let count = fetchedResultsController.sections?[0].numberOfObjects {
      return count;
    }
    
    return 0;
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80;
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let item = fetchedResultsController.object(at: indexPath);
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "FavItem") as! FavItemCell;
    cell.artistTitle?.text = item.strAlbum;
    cell.trackTitle?.text = item.strTrack;
    if let duration = item.intDuration {
      cell.duration?.text = Int(duration)?.msToFormattedMinSec
    }
    
    return cell;
  }
  
  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    let movedObject = fetchedResultsController.object(at: sourceIndexPath)
    
      //headlines.remove(at: sourceIndexPath.row)
      //headlines.insert(movedObject, at: destinationIndexPath.row)
    let context = PersistanceHandler.context;
    
    func switchRows(surceIndexPath: IndexPath, destinationIndexPath: IndexPath) {
      let fetchedSourceObject = fetchedResultsController.object(at: sourceIndexPath)
      let fetchedDestinationObject = fetchedResultsController.object(at: destinationIndexPath)
      let storedSourceObject = context.object(with: fetchedSourceObject.objectID) as! Track
      let storedDestinationObject = context.object(with: fetchedDestinationObject.objectID) as! Track
      let sourceSort = fetchedSourceObject.sortId
      let destinationSort = fetchedDestinationObject.sortId
      storedSourceObject.sortId = destinationSort
      storedDestinationObject.sortId = sourceSort
    }
    
    func incrementSortIndex(forOriginRow origin: Int, destinationRow destination: Int) {
        let mutableSourceIndex = IndexPath(row: origin, section: destinationIndexPath.section)
        let mutableDestinationIndex = IndexPath(row: destination, section: destinationIndexPath.section)
        let fetchedSourceObject = fetchedResultsController.object(at: mutableSourceIndex)
        let fetchedDestinationObject = fetchedResultsController.object(at: mutableDestinationIndex)
        let storedSourceObject = context.object(with: fetchedSourceObject.objectID) as! Track
        let destinationSort = fetchedDestinationObject.sortId
        storedSourceObject.sortId = destinationSort
    }
    
    if sourceIndexPath == destinationIndexPath {
        // Nothing to do here, drag-and-drop and both rows are the same.
        return
    } else if abs(sourceIndexPath.row - destinationIndexPath.row) == 1 {
        // If the rows were just switched
        switchRows(surceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
        return
    } else if sourceIndexPath.row < destinationIndexPath.row {
        // Move rows upwards
        let fetchedSourceObject = fetchedResultsController.object(at: sourceIndexPath)
        let fetchedDestinationObject = fetchedResultsController.object(at: destinationIndexPath)
        
        // iterate over the unmoved rows, which are pushed downwards
        for row in sourceIndexPath.row + 1 ..< destinationIndexPath.row {
            incrementSortIndex(forOriginRow: row, destinationRow: row - 1)
        }
        // drag Source-Object upwards
        let storedSourceObject = context.object(with: fetchedSourceObject.objectID) as! Track
        let destinationSort = fetchedDestinationObject.sortId
        storedSourceObject.sortId = destinationSort
    } else if sourceIndexPath.row > destinationIndexPath.row {
        // Move rows downwards
        let fetchedSourceObject = fetchedResultsController.object(at: sourceIndexPath)
        let fetchedDestinationObject = fetchedResultsController.object(at: destinationIndexPath)
        
        // iterate over the unmoved rows, which are pushed upwards
        for row in destinationIndexPath.row ..< sourceIndexPath.row {
            incrementSortIndex(forOriginRow: row, destinationRow: row + 1)
        }
        // Source-Object is moved downwards
        let storedSourceObject = context.object(with: fetchedSourceObject.objectID) as! Track
        let destinationSort = fetchedDestinationObject.sortId
        storedSourceObject.sortId = destinationSort
    }
    // Save the current Context
    PersistanceHandler.saveContext();
    
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if (editingStyle == .delete) {
      
      //deleteItem(tracks[indexPath.row]);
      tableView.deleteRows(at: [indexPath], with: .automatic)
      //tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
  }
  
  
}

/*extension FavController: NSFetchedResultsControllerDelegate {
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates();
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates();
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    
    switch type {

      case .insert:
        print("Trying to insert");
      case .delete:
        print("Trying to delete");
      case .move:
        print("Trying to move");
      case .update:
        print("Trying to updatee");
      @unknown default:
        print("Controller error in didChange");
    }
  }
  
} */
