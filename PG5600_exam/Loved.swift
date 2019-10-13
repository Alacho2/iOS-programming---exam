//
//  Loved.swift
//  PG5600_exam
//
//  Created by Håvard on 13/10/2019.
//  Copyright © 2019 Håvard. All rights reserved.
//

import Foundation

struct Loved: Codable {
  let loved: [LovedItem?];
}

struct LovedItem: Codable {
  let idAlbum, idArtist, strArtist, strAlbumThumb, strAlbum: String;
  let idLabel: String?;

}
