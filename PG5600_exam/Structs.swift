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

struct TempTrack: Codable {
  let idArtist, idTrack, intDuration, strArtist, strAlbum, strTrack: String;
  let idAlbum, strGenre: String?;
}

struct SearchAlbum: Codable {
  let idArtist, idAlbum, strAlbum, intYearReleased, strArtist: String;
  let strAlbumThumb: String?;
}

struct Result: Codable {
  let Name: String;
}

struct Similar: Codable {
  let Info, Results: [Result]
}

