//
//  Track+CoreDataProperties.swift
//  PG5600_exam
//
//  Created by Håvard on 29/10/2019.
//  Copyright © 2019 Håvard. All rights reserved.
//
//

import Foundation
import CoreData


extension Track {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Track> {
        return NSFetchRequest<Track>(entityName: "Track")
    }

    @NSManaged public var idArtist: String?
    @NSManaged public var idTrack: String?
    @NSManaged public var intDuration: String?
    @NSManaged public var strArtist: String?
    @NSManaged public var strAlbum: String?
    @NSManaged public var strTrack: String?
    @NSManaged public var idAlbum: String?
    @NSManaged public var strGenre: String?

}
