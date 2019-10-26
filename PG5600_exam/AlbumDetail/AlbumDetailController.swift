//
//  AlbumDetailController.swift
//  PG5600_exam
//
//  Created by Håvard on 17/10/2019.
//  Copyright © 2019 Håvard. All rights reserved.
//

import UIKit

class AlbumDetailController: UIViewController {
  
  var albumDetail: AlbumDetail?
  var tracks: [Track] = []
  @IBOutlet weak var albumCover: UIImageView!
  @IBOutlet weak var albumTitle: UILabel!
  @IBOutlet weak var releaseYear: UILabel!
  @IBOutlet weak var artistTitle: UILabel!
  @IBOutlet weak var tableView: UITableView!
  var fetchUrl: String = "";
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self;
    tableView.dataSource = self;
  
    if let album = albumDetail {
      self.title = "\(album.strArtist) - \(album.strAlbum)"
      albumCover.image = UIImage(data: album.imageData);
      releaseYear.text = album.intYearReleased;
      artistTitle.text = "By \(album.strArtist)";
      albumTitle.text = album.strAlbum;
      fetchUrl = "https://theaudiodb.com/api/v1/json/195223/track.php?m=\(album.idAlbum)"
    }
    getTrackInfo();
  }
  
  func getTrackInfo() {
    NetworkHandler().makeRequestWith(
      url: fetchUrl,
      completed: {(response: [String: [Track]]) in
        guard let trackArray = response["track"] else {
          return
        }
        self.tracks = trackArray;
        self.tableView.reloadData();
        
    },
    failed: {(failRes) in print("Something went terribly wrong")})
    }
  

}



extension AlbumDetailController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.tracks.count;
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let item = self.tracks[indexPath.row];
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "TrackItemCell") as! TrackCell;
    cell.trackTitle.text = item.strTrack
    if let duration = Int(item.intDuration) {
      cell.durationLabel.text = duration.msToFormattedMinSec;
    }
    return cell;
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
