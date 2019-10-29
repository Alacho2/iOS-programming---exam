//
//  Loved.swift
//  PG5600_exam
//
//  Created by Håvard on 13/10/2019.
//  Copyright © 2019 Håvard. All rights reserved.
//

import Foundation

struct AlbumDetail: Codable {
  let idAlbum, idArtist, strArtist, strAlbum, intYearReleased: String;
  let idLabel, strAlbumThumb: String?;
  let imageData: Data?;
  
  enum AlbumKeys: String, CodingKey {
    case imageData
    case idAlbum
    case idArtist
    case intYearReleased
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
    strAlbumThumb = try? values.decode(String.self, forKey: .strAlbumThumb);
    //Let's handle image processing here, so it doesn't happen on the fly for every scroll
    if let strAlbumThumb = strAlbumThumb, strAlbumThumb != "" {
      imageData = try! Data(contentsOf: URL(string: strAlbumThumb)!)
    } else { imageData = nil; }
    intYearReleased = try values.decode(String.self, forKey: .intYearReleased)
    strAlbum = try values.decode(String.self, forKey: .strAlbum);
    idLabel = try values.decode(String?.self, forKey: .idLabel);
  }
}

struct Track: Codable {
  let idArtist, idTrack, intDuration, strArtist, strAlbum, strTrack: String;
  let idAlbum, strGenre: String?;
  //362000 / 1000 / 60 = minutes seconds
}

struct SearchAlbum: Codable {
  let idArtist, idAlbum, strAlbum, intYearReleased, strArtist: String;
  let strAlbumThumb: String?;
}
