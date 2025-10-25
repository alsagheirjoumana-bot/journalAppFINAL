//
//  EntryRow.swift
//  journalApp88
//
//  Created by Joumana Alsagheir on 22/10/2025.
//

import SwiftUI

struct EntryRow: View {
    let entry: JournalEntry
    var onBookmark: () -> Void

    private enum UI {
        static let corner: CGFloat = 26
        static let padH: CGFloat = 22
        static let padV: CGFloat = 20
        static let titleSize: CGFloat = 23
        static let bodySize: CGFloat = 17
        static let glyphSize: CGFloat = 20
        static let minHeight: CGFloat = 150
        static let bookmarkPad: CGFloat = 54
    }

    // Use your asset colors
    private let lavender = Color("lavender")
    private let cardBase = Color("entryRow")
    private let dateGray = Color.white.opacity(0.60)

    var body: some View {
        ZStack(alignment: .topTrailing) {

            // ===== CONTENT =====
            VStack(alignment: .leading, spacing: 14) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(entry.title.isEmpty ? "My Journal" : entry.title)
                        .font(.system(size: UI.titleSize, weight: .bold, design: .rounded))
                        .foregroundStyle(lavender)

                    Text(dateString(entry.date))
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(dateGray)
                }

                Text(preview(entry.body))
                    .font(.system(size: UI.bodySize, weight: .regular))
                    .foregroundStyle(.white)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, UI.padH)
            .padding(.vertical, UI.padV)
            .padding(.trailing, UI.bookmarkPad)

            // ===== BOOKMARK =====
            Button(action: onBookmark) {
                Image(systemName: entry.isBookmarked ? "bookmark.fill" : "bookmark")
                    .font(.system(size: UI.glyphSize, weight: .semibold))
                    .foregroundStyle(lavender)
                    .frame(width: 44, height: 44, alignment: .topTrailing)
            }
            .padding(.top, 10)
            .padding(.trailing, 12)
            .buttonStyle(.plain)
        }

        // ===== CARD STYLE =====
        .frame(maxWidth: .infinity, minHeight: UI.minHeight, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: UI.corner, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            cardBase.opacity(0.95),
                            cardBase.opacity(0.82)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: UI.corner, style: .continuous)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: UI.corner, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [.white.opacity(0.10), .clear],
                        startPoint: .top,
                        endPoint: .center
                    )
                )
                .blendMode(.plusLighter)
                .allowsHitTesting(false)
        )
        .shadow(color: .black.opacity(0.55), radius: 24, x: 0, y: 12)
        .contentShape(Rectangle())
    }

    // MARK: - Helpers

    private func dateString(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yyyy"
        return f.string(from: date)
    }

    private func preview(_ text: String) -> String {
        text.isEmpty
        ? "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec odio."
        : text
    }
}

#Preview {
    EntryRow(
        entry: JournalEntry(
            title: "My Birthday",
            body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec odio. Quisque volutpat mattis eros.",
            isBookmarked: true
        )
    ) { }
    .padding(.horizontal, 20)
    .preferredColorScheme(.dark)
}
