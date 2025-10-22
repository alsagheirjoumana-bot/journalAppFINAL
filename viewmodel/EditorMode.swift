//
//  Untitled 2.swift
//  journalApp88
//
//  Created by Joumana Alsagheir on 22/10/2025.
//

//import Foundation
//
///// Create or Edit mode (just for simple UI logic)
//enum EditorMode {
//    case create
//    case edit
//}
//
//final class EditorViewModel: ObservableObject {
//
//    // MARK: - Inputs bound to TextFields/TextEditor
//    @Published var title: String
//    @Published var body: String
//
//    // MARK: - Other state
//    let id: UUID
//    @Published var date: Date
//    @Published var isBookmarked: Bool
//    let mode: EditorMode
//
//    // MARK: - Init with an existing entry OR a new one
//    init(entry: JournalEntry?) {
//        if let e = entry {
//            id = e.id
//            title = e.title
//            body = e.body
//            date = e.date
//            isBookmarked = e.isBookmarked
//            mode = .edit
//        } else {
//            id = UUID()
//            title = ""
//            body = ""
//            date = Date()
//            isBookmarked = false
//            mode = .create
//        }
//    }
//
//    // MARK: - Output back to HomeVM
//    var composedEntry: JournalEntry {
//        JournalEntry(id: id, title: title, body: body, date: date, isBookmarked: isBookmarked)
//    }
//
//    // MARK: - Simple validation
//    var canSave: Bool {
//        !body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
//    }
//}
