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
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var reorderButton: UIButton!
  var searchString = "";
  
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
  
  @IBAction func changeEditing(_ sender: UIButton) {
    if tableView.isEditing {
      reorderButton.setTitle("Reorder", for: .normal)
      tableView.isEditing = false;
    } else {
      reorderButton.setTitle("Finish", for: .normal)
      tableView.isEditing = true;
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self;
    tableView.delegate = self;
    collectionView.dataSource = self;
    collectionView.delegate = self;
  }
  
  func getSimilarArtists(url: String){
    NetworkHandler().makeRequestWith(
      url: url,
      completed: {(response: [String: Similar]) in
      guard let resultArray = response["Similar"] else {
        return;
      }
        
      print(resultArray.Results)
  
    }, failed: {(failRes) in print(failRes)})
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated);
    getDbData();
    
    getSimilarArtists(url: "https://tastedive.com/api/similar?q=\(searchString)");
  }
  
  func getDbData(){
    do {
      try fetchedResultsController.performFetch();
      
      if fetchedResultsController.sections?[0].objects as? [Track] != nil {
        self.tableView.reloadData();
      }
      
      if let similarArtists = fetchedResultsController.sections?[0].objects as? [Track] {
      
        searchString = similarArtists.map{ artist in
          if let title = artist.strArtist {
            return title.replacingOccurrences(of: " ", with: "+")
          }
          return ""
        }.unique().joined(separator: ",")
        
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

extension FavController : UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = UICollectionViewCell()
    return cell;
  }
  
  
}
