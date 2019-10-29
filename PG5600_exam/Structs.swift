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
