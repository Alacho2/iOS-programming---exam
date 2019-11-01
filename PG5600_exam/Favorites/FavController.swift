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
    fetchReq.sortDescriptors = [NSSortDescriptor(key: "sortId", ascending: true)];
    
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
      
      //fetchedResultsController.fetchedObjects?.forEach{item in print(item.sortId)}
      
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
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    
    switch type {
      case .insert:
        print("Looking for insert");
      case .delete:
        print("Looking for delete");
      case .move:
        print("Looking for move");
        //tableView.insertRows(at: [newIndexPath!], with: .fade);
      //tableView.deleteRows(at: [newIndexPath!], with: .fade)
      case .update:
        print("Looking for update");
        //let cell = tableView.dequeueReusableCell(withIdentifier: "FavItem") as! FavItemCell;
      
        //configureCell(cell, at: indexPath!)
      @unknown default:
        print("Looking for default")
    }
  }
  
  func configureCell(_ cell: FavItemCell, at indexPath: IndexPath) {
    let item = fetchedResultsController.object(at: indexPath)

    cell.artistTitle?.text = item.strAlbum;
    cell.trackTitle?.text = item.strTrack;
    
    if let duration = item.intDuration {
      cell.duration?.text = Int(duration)?.msToFormattedMinSec
    }
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
    let context = PersistanceHandler.context;
    
    func switchRows(surceIndexPath: IndexPath, destinationIndexPath: IndexPath) {
      let fetchedSourceObject = fetchedResultsController.object(at: sourceIndexPath)
      let fetchedDestinationObject = fetchedResultsController.object(at: destinationIndexPath)
      let storedSourceObject = context.object(with: fetchedSourceObject.objectID) as! Track
      let storedDestinationObject = context.object(with: fetchedDestinationObject.objectID) as! Track
      storedSourceObject.sortId = Int16(destinationIndexPath.row)
      storedDestinationObject.sortId = Int16(surceIndexPath.row)
    }
    
    func incrementSortIndex(forOriginRow origin: Int) {
      let fetchedSourceObject = fetchedResultsController.object(at: IndexPath(row: origin, section: 0));
      let storedSourceObject = context.object(with: fetchedSourceObject.objectID) as! Track;
      storedSourceObject.sortId = Int16(destinationIndexPath.row)
      
      for index in stride(from: destinationIndexPath.row, to: sourceIndexPath.row, by: -1) {
        let fetchedObjectToMove = fetchedResultsController.object(at: IndexPath(row: index, section: 0))
        //print(fetchedObjectToMove.strTrack);
        let storedObjectToMove = context.object(with: fetchedObjectToMove.objectID) as! Track;
        storedObjectToMove.sortId = Int16(index - 1);
      }
    }
    
    func decrementSortIndex(forOriginRow destination: Int) {
      let fetchedSourceObject = fetchedResultsController.object(at: IndexPath(row: destination, section: 0));
      let storedSourceObject = context.object(with: fetchedSourceObject.objectID) as! Track;
      storedSourceObject.sortId = Int16(destinationIndexPath.row)
      
      for index in stride(from: destinationIndexPath.row, to: sourceIndexPath.row, by: +1) {
        let fetchedObjectToMove = fetchedResultsController.object(at: IndexPath(row: index, section: 0))
        //print(fetchedObjectToMove.strTrack);
        let storedObjectToMove = context.object(with: fetchedObjectToMove.objectID) as! Track;
        storedObjectToMove.sortId = Int16(index + 1);
      }
    }
    
    if sourceIndexPath == destinationIndexPath {
        // Nothing to do here, drag-and-drop and both rows are the same.
        return
    } else if abs(sourceIndexPath.row - destinationIndexPath.row) == 1 {
      // If the rows were just switched
      switchRows(surceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
      
    } else if sourceIndexPath.row < destinationIndexPath.row {
      // Move rows upwards
      
      incrementSortIndex(forOriginRow: sourceIndexPath.row);
      
      
    } else if sourceIndexPath.row > destinationIndexPath.row {
        // Move rows downwards
      decrementSortIndex(forOriginRow: sourceIndexPath.row);
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
