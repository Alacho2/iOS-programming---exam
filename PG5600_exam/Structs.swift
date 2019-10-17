//
//  Loved.swift
//  PG5600_exam
//
//  Created by Håvard on 13/10/2019.
//  Copyright © 2019 Håvard. All rights reserved.
//

import Foundation

struct AlbumDetail: Codable {
  let idAlbum, idArtist, strArtist, strAlbum: String;
  let idLabel: String?;
  let strAlbumThumb: String;
  let imageData: Data;
  
  enum AlbumKeys: String, CodingKey {
    case imageData
    case idAlbum
    case idArtist
    case strArtist
    case strAlbumThumb
    case strAlbum
    case idLabel
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: AlbumKeys.self);
    idAlbum = try values.decode(String.self, forKey: .idAlbum);
    idArtist = try values.decode(String.self, forKey: .idArtist);
    strArtist = try values.decode(String.self, forKey: .strArtist);
    strAlbumThumb = try values.decode(String.self, forKey: .strAlbumThumb);
    imageData = try! Data(contentsOf: URL(string: strAlbumThumb)!)
    strAlbum = try values.decode(String.self, forKey: .strAlbum);
    idLabel = try values.decode(String?.self, forKey: .idLabel);
  }
  
  //      let data = try! Data(contentsOf: URL(string: topItem.strAlbumThumb)!) */
}
