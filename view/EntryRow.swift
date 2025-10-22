//
//  SwiftUIView.swift
//  journalApp88
//
//  Created by Joumana Alsagheir on 22/10/2025.
//

import SwiftUI

struct EntryRow: View {
    let entry: JournalEntry
    let onBookmark: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Card
            VStack(alignment: .leading, spacing: 8) {
                Text(entry.title.isEmpty ? "Untitled" : entry.title)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.lavender) // lavender

                Text(entry.date.shortDayString)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(entry.body)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                    .padding(.top, 2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .glassCard()

            // Bookmark top-right
            Button(action: onBookmark) {
                Image(systemName: entry.isBookmarked ? "bookmark.fill" : "bookmark")
                    .font(.system(size: 18, weight: .semibold))
                    .padding(10)
            }
            .buttonStyle(.plain)
            .padding(6)
        }
    }
}

#Preview {
    EntryRow(
        entry: JournalEntry(title: "My Birthday", body: "Preview body…", isBookmarked: true)
    ) { }
    .padding()
    .preferredColorScheme(.dark)
}

