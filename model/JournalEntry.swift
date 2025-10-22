//
//  Untitled.swift
//  journalApp88
//
//  Created by Joumana Alsagheir on 22/10/2025.
//

import Foundation

/// Your basic note model (in-memory for now)
struct JournalEntry: Identifiable, Equatable, Codable {
    let id: UUID
    var title: String
    var body: String
    var date: Date
    var isBookmarked: Bool

    init(
        id: UUID = UUID(),
        title: String = "",
        body: String = "",
        date: Date = Date(),
        isBookmarked: Bool = false
    ) {
        self.id = id
        self.title = title
        self.body = body
        self.date = date
        self.isBookmarked = isBookmarked
    }
}

extension Date {
    var shortDayString: String {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .none
        return f.string(from: self)
    }
}
