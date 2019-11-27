//
//  MainController.swift
//  PG5600_exam
//
//  Created by Håvard on 13/10/2019.
//  Copyright © 2019 Håvard. All rights reserved.
//

import UIKit
import Kingfisher

class TopController: UIViewController, UIScrollViewDelegate {
  
  @IBOutlet weak var topListCollView: UICollectionView!
  var lovedMusicItems: [AlbumDetail] = []
  
  @IBOutlet weak var switcher: UISegmentedControl!
  
  var refreshController: UIRefreshControl = UIRefreshControl();
  
  override func viewDidLoad() {
    super.viewDidLoad();
    self.topListCollView.delegate = self;
    self.topListCollView.dataSource = self;
    self.topListCollView!.alwaysBounceVertical = true;
    refreshController.attributedTitle = NSAttributedString(string: "Pull to refresh");
    refreshController.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    topListCollView.addSubview(refreshController);

    makeRequest();
  }
  
  func makeRequest() {
    NetworkHandler().makeRequestWith(
      url: "https://theaudiodb.com/api/v1/json/1/mostloved.php?format=album",
      completed: {(response: [String: [AlbumDetail]]) in
        guard let lovedArray = response["loved"] else {
          return;
        }
        self.lovedMusicItems = lovedArray;
        self.topListCollView.reloadData();
        print("finished");
      },
      failed: {(failRes) in self.displayError(error: failRes)
    })
  }
  
  @objc func pullToRefresh() {
    self.topListCollView.refreshControl?.beginRefreshing();
    makeRequest();
    self.topListCollView.reloadData();
    refreshController.endRefreshing();
  }
  
  func makeTransition(identifier: String, data: AlbumDetail){
    if let vc = self.storyboard?.instantiateViewController(identifier: identifier) as AlbumDetailController? {
      vc.albumDetail = data
    self.navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  @IBAction func switched(_ sender: UISegmentedControl) {
    topListCollView.reloadData();
  }
  
  func displayError(error: String){
    let alert = UIAlertController(title: "Failed", message: error, preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
        UIAlertAction in}
    alert.addAction(cancelAction)
    self.present(alert, animated: true);
  }
}

extension TopController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1;
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = view.frame.width;
    
    if(self.switcher.selectedSegmentIndex == 0) {
      return CGSize(width: (width - 15) / 2, height: 150)
    } else {
      return CGSize(width: width, height: 45);
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.lovedMusicItems.count;
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let topItem = self.lovedMusicItems[indexPath.item];
    
    if (self.switcher.selectedSegmentIndex == 0) {
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopItemCell", for: indexPath) as! TopItemCell
      cell.albumTitle?.text = topItem.strAlbum;
      cell.albumArtist?.text = topItem.strArtist;
      
      if let imageUrl = topItem.strAlbumThumb {
        cell.albumImage?.kf.setImage(with: URL(string: imageUrl), placeholder: UIImage(named: "placeholder_art"));
      }
      
      return cell;
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompactCell", for: indexPath) as! CompactItemCell;
      cell.albumTitle?.text = topItem.strAlbum;
      cell.artistTitle?.text = topItem.strArtist;
      if let imageUrl = topItem.strAlbumThumb {
        cell.albumImage?.kf.setImage(with: URL(string: imageUrl), placeholder: UIImage(named: "placeholder_art"));
      }
      return cell;
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let topItem = self.lovedMusicItems[indexPath.row];
    makeTransition(identifier: "albumdetail", data: topItem);
    collectionView.deselectItem(at: indexPath, animated: true);
  }
  
}
