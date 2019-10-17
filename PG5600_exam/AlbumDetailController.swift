//
//  AlbumDetailController.swift
//  PG5600_exam
//
//  Created by Håvard on 17/10/2019.
//  Copyright © 2019 Håvard. All rights reserved.
//

import UIKit

class AlbumDetailController: UIViewController {
  
  
  //Initializing with some fallback data
  var albumDetail: AlbumDetail? /* AlbumDetail(
    idAlbum: "0",
    idArtist: "0",
    strArtist: "Håvard",
    strAlbumThumb: "https://fakepicture.com/data.jpg",
    strAlbum: "Nordlie",
    idLabel: "Queen"
  );*/
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    self.title = "\(albumDetail!.strArtist) - \(albumDetail!.strAlbum)"
  }
}
