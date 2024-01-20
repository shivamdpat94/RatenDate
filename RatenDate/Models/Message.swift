//
//  Message.swift
//  RatenDate
//
//  Created by Mitchell Buff on 1/13/24.
//

import Foundation

struct Message: Identifiable, Equatable {
    var id: String
    var text: String
    var isCurrentUser: Bool
    var date: Date
}
