//
//  SearchController.swift
//  PG5600_exam
//
//  Created by Håvard on 17/10/2019.
//  Copyright © 2019 Håvard. All rights reserved.
//

import UIKit

class SearchController: UIViewController, UISearchBarDelegate {

  @IBOutlet weak var searchField: UISearchBar!
  @IBOutlet weak var collectionView: UICollectionView!;
  var searchResult: [AlbumDetail] = [];
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchField.delegate = self;
    collectionView.delegate = self;
    collectionView.dataSource = self;
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.count > 4 {
      print(searchText)
      searchTheApi(query: searchText);
    }
  }
  
  
  func searchTheApi(query: String){
    NetworkHandler().makeRequestWith(url: "https://theaudiodb.com/api/v1/json/195223/searchalbum.php?a=\(query)",
      completed: {(response: [String: [AlbumDetail]?]) in
        guard let searchRes = response["album"] else {
          return;
        }
        
        guard searchRes != nil else {
          return;
        }
        
        if let albumArr = searchRes {
          self.searchResult = albumArr
        }
        
        print(self.searchResult);
        
        self.collectionView.reloadData();
        },
      failed: {(failRes) in print("Something terrible went wrong")}
  )}
  
  func makeTransition(identifier: String, data: AlbumDetail){
    if let vc = self.storyboard?.instantiateViewController(identifier: identifier) as AlbumDetailController? {
      vc.albumDetail = data
    self.navigationController?.pushViewController(vc, animated: true)
    }
  }
  
}


extension SearchController: UICollectionViewDelegate, UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1;
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return searchResult.count;
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let item = self.searchResult[indexPath.item];
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchItemCell
    cell.searchAlbum?.text = item.strAlbum;
    cell.searchArtist?.text = item.strArtist;
    
    if let imageUrl = item.strAlbumThumb {
      cell.searchCover?.kf.setImage(with: URL(string: imageUrl), placeholder: UIImage(named: "placeholder_art"));
    } else {
      cell.searchCover?.image = UIImage(named: "placeholder_art");
    }
    
    return cell;
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let searchItem = self.searchResult[indexPath.row];
    makeTransition(identifier: "albumdetail", data: searchItem);
    collectionView.deselectItem(at: indexPath, animated: true);
  }

}
