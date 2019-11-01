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
    
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.isEditing = true;
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated);
    getDbData();
  }
  
  func getDbData(){
    do {
      try fetchedResultsController.performFetch();
      
      if fetchedResultsController.sections?[0].objects as? [Track] != nil {
        self.tableView.reloadData();
      }

    } catch let err {
      print("Something went terribly wrong \(err)")
    }
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
      
      case .insert:
        print("Insert");
        if let newIndexPath  = newIndexPath {
          self.tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
      case .delete:
        print("Looking for delete");
      case .move:
        print("Move");
      case .update:
        print("Update");
      @unknown default:
        print("Default");
    }
    tableView.reloadSections(IndexSet(integer: 0), with: .fade)
  }
  
  func displayAlertBeforeDelete(error: String, at: IndexPath){
    let alert = UIAlertController(title: "You sure?", message: error, preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
        UIAlertAction in}
    let confirmAction = UIAlertAction(title: "Confirm", style: .destructive, handler: {
      UIAlertAction in
      let fetchedResult = self.fetchedResultsController.object(at: at);
      self.fetchedResultsController.managedObjectContext.delete(fetchedResult);
      PersistanceHandler.saveContext();
      
    });
    alert.addAction(confirmAction)
    alert.addAction(cancelAction)
    
    self.present(alert, animated: true);
  }

}

extension FavController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let resultCount = fetchedResultsController.sections?[0].numberOfObjects {
      resultCount == 0 ?
        self.tableView.setEmptyMessage(message: "There was no responses") :
        self.tableView.reset()
    
      return resultCount;
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
    
    func changeSortIndex(for origin: Int, by: Int, up: Bool) {
      let fetchedSourceObject = fetchedResultsController.object(at: IndexPath(row: origin, section: 0));
      let storedSourceObject = context.object(with: fetchedSourceObject.objectID) as! Track;
      storedSourceObject.sortId = Int16(destinationIndexPath.row)
      
      for index in stride(from: destinationIndexPath.row, to: sourceIndexPath.row, by: by) {
        let fetchedObjectToMove = fetchedResultsController.object(at: IndexPath(row: index, section: 0))
        let storedObjectToMove = context.object(with: fetchedObjectToMove.objectID) as! Track;
        if up { storedObjectToMove.sortId = Int16(index + 1) }
        else { storedObjectToMove.sortId = Int16(index - 1) }
      }
    }
    
    if sourceIndexPath == destinationIndexPath {
        return
    } else if abs(sourceIndexPath.row - destinationIndexPath.row) == 1 {
      // From one row to over/below
      switchRows(surceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
      
    } else if sourceIndexPath.row < destinationIndexPath.row {
      // Move rows up
      changeSortIndex(for: sourceIndexPath.row, by: -1, up: false);
    } else if sourceIndexPath.row > destinationIndexPath.row {
      // Move rows down
      changeSortIndex(for: sourceIndexPath.row, by: +1, up: true);
    }
    // Save to the database
    PersistanceHandler.saveContext();
    
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if (editingStyle == .delete) {
      
      displayAlertBeforeDelete(error: "Delete this?", at: indexPath)
  
    }
  }
  
}
