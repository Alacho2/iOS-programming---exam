//
//  MainController.swift
//  PG5600_exam
//
//  Created by Håvard on 13/10/2019.
//  Copyright © 2019 Håvard. All rights reserved.
//

import UIKit

class TopController: UIViewController {
  
  var lovedMusicItems: [AlbumDetail] = []
  @IBOutlet weak var topListTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad();
    
    topListTableView.delegate = self;
    topListTableView.dataSource = self;
    
    
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
      failed: {(failRes) in print(failRes)
    })
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
  
    DispatchQueue.init(label: "background").async {
      let data = try! Data(contentsOf: URL(string: topItem.strAlbumThumb)!)
      
      DispatchQueue.main.async {
        cell.albumArt.image = UIImage(data: data);
      }
    }
    
    //print(topItem.strArtist);
    
    return cell;
  }
  
  
}
