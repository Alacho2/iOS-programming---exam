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
  // There is a type value, for now we won't care about that.
}

struct Similar: Codable {
  let info, results: [Result]
  
  enum CodingKeys: String, CodingKey {
    // Cuz big letter variables look stupid in code
    case info = "Info"
    case results = "Results"
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self);
    self.info = try container.decode([Result].self, forKey: .info);
    self.results = try container.decode([Result].self, forKey: .results)
  }
}

