//
//  FavControllerTableExtension.swift
//  PG5600_exam
//
//  Created by Håvard on 01/11/2019.
//  Copyright © 2019 Håvard. All rights reserved.
//

import Foundation
import UIKit

extension FavController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let resultCount = fetchedResultsController.sections?[0].numberOfObjects {
      resultCount == 0 ?
        self.tableView.setEmptyMessage(message: "You don't have any favorites :("):
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
