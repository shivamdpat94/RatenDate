//
//  Match.swift
//  RatenDate
//
//  Created by Mitchell Buff on 1/13/24.
//

import Foundation

struct Match: Identifiable {
    var id: String // Unique identifier for each match
    var name: String
    var image: String // This would be the name of the image in the asset catalog
    var lastMessage: String
    var messageDate: Date
}
