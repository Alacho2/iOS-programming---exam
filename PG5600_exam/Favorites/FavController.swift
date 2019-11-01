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
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var reorderButton: UIButton!
  var searchString = "";
  var suggestedArtists: [Result?] = [];
  
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
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated);
    getDbData();
  }
  
  func getSimilarArtists(){
    if searchString != "" {
    NetworkHandler().makeRequestWith(
      url: "https://tastedive.com/api/similar?k=348909-Examapp-5O0FDDN1&q=\(searchString)",
      completed: {(response: [String: Similar]) in
        guard let resultArray = response["Similar"] else {
          return;
        }
        self.suggestedArtists = resultArray.results;
        self.collectionView.reloadSections(IndexSet(integer: 0))
        
      }, failed: {(failRes) in print(failRes)})
    } else {
      self.suggestedArtists = [];
      self.collectionView.reloadSections(IndexSet(integer: 0))
    }
  }
  
  func getDbData(){
    do {
      try fetchedResultsController.performFetch();
      let sectionsOfController = fetchedResultsController.sections?[0].objects as? [Track]
      
      if sectionsOfController != nil {
        self.tableView.reloadData();
      }
      
      if let similarArtists = sectionsOfController {
        setSearchStringAndUpdateSuggestions(similarArtists)
      }
    } catch let err {
      print("Something went terribly wrong \(err)")
    }
  }
  
  func setSearchStringAndUpdateSuggestions(_ similarArtists: [Track]){
    // Let's make sure that we're only searching for the artist ONE time
    searchString = similarArtists.map{ artist in
      if let title = artist.strArtist {
        return title.replacingOccurrences(of: " ", with: "+")
      }
      return ""
    }.unique().joined(separator: ",")
    getSimilarArtists();
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
        suggestedArtists.count == 0 ?
      self.collectionView.setEmptyMessage(message: "Add some favorites to get suggestions") :
      self.collectionView.reset()
    
    return suggestedArtists.count;
  }
  
  @objc(collectionView:layout:insetForSectionAtIndex:)  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
    return UIEdgeInsets.init(top: 5, left: 7, bottom: 5, right: 7)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let item = suggestedArtists[indexPath.row];
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendedCell", for: indexPath) as! RecommendedCellItem;
    cell.recommendedTitle?.text = item?.Name
    return cell;
  }
  
}

extension FavController : NSFetchedResultsControllerDelegate {
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    
    //There are other types but since we're not adding content from this screen, we'll rely on that other places
    if type == .delete {
      tableView.reloadSections(IndexSet(integer: 0), with: .fade)
      if let similarArtists = fetchedResultsController.sections?[0].objects as? [Track] {
        setSearchStringAndUpdateSuggestions(similarArtists)
      }
    }
  }
}
