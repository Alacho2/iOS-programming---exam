//
//  MainController.swift
//  PG5600_exam
//
//  Created by Håvard on 13/10/2019.
//  Copyright © 2019 Håvard. All rights reserved.
//

import UIKit


//Reminder to ask Markus or Henrik about scrollViewDidScollToTop

class TopController: UIViewController, UIScrollViewDelegate {
  
  var lovedMusicItems: [AlbumDetail] = []
  @IBOutlet weak var topListTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad();
    topListTableView.delegate = self;
    topListTableView.dataSource = self;
    makeRequest();
  }
  
  func makeRequest() {
    NetworkHandler().makeRequestWith(
      url: "https://theaudiodb.com/api/v1/json/1/mostloved.php?format=album",
      completed: {(response: [String: [AlbumDetail]]) in
        guard let lovedArray = response["loved"] else {
          return;
        }
        //print(lovedArray)
        self.lovedMusicItems = lovedArray;
        self.topListTableView.reloadData();
      },
      failed: {(failRes) in self.displayError(error: failRes)
    })
  }
  
  
   //Spørre Markus / Henrik
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if(scrollView.contentOffset.y > -4) {
      makeRequest();
    }
  }
  
  
  func displayError(error: String){
    let alert = UIAlertController(title: "Failed", message: error, preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
        UIAlertAction in}
    alert.addAction(cancelAction)
    self.present(alert, animated: true);
  }
}

extension TopController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.lovedMusicItems.count;
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let topItem = self.lovedMusicItems[indexPath.row];
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "TopItemCell") as! TopItemCell;
    cell.albumTitle?.text = topItem.strAlbum;
    cell.albumArtist?.text = topItem.strArtist;
  
    DispatchQueue.init(label: "background").async {
      let data = try! Data(contentsOf: URL(string: topItem.strAlbumThumb)!)
      
      DispatchQueue.main.async {
        cell.albumArt.image = UIImage(data: data);
      }
    }
    
    return cell;
  }

  //Storyboard is 100% retarded, so we force the height here.
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 110;
  }

}
