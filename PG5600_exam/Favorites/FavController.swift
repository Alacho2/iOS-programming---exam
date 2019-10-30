//
//  FavController.swift
//  PG5600_exam
//
//  Created by Håvard on 17/10/2019.
//  Copyright © 2019 Håvard. All rights reserved.
//

import UIKit
import CoreData

class FavController: UIViewController {
  
  var tracks = [Track]();
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("You are in fav");
    
    tableView.dataSource = self;
    tableView.delegate = self;
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated);
    getDbData();
    //print("Back in business")
  }
  
  func getDbData(){
    let fetchReq: NSFetchRequest<Track> = Track.fetchRequest();
    
    do {
      let tracks = try PersistanceHandler.context.fetch(fetchReq)
      self.tracks = tracks;
      self.tableView.reloadData();
    } catch {
      print("Didn't manage to grab the data");
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

}

extension FavController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tracks.count;
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80;
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let item = tracks[indexPath.row];
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "FavItem") as! FavItemCell;
    cell.artistTitle?.text = item.strAlbum;
    cell.trackTitle?.text = item.strTrack;
    if let duration = item.intDuration {
      cell.duration?.text = Int(duration)?.msToFormattedMinSec
    }
    
    return cell;
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if (editingStyle == .delete) {
      deleteItem(tracks[indexPath.row]);
      tracks.remove(at: indexPath.row);
      tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
  }
}

extension FavController: NSFetchedResultsControllerDelegate {
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates();
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates();
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    
  }
  
}
