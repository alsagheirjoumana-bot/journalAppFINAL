//
//  SwiftUIView.swift
//  journalApp88
//
//  Created by Joumana Alsagheir on 22/10/2025.
//

import SwiftUI

struct EntryRow: View {
    let entry: JournalEntry
    var onBookmark: () -> Void

    private enum UI {
        static let corner: CGFloat = 22
        static let pad: CGFloat = 18
        static let titleSize: CGFloat = 22
        static let bodySize: CGFloat = 16
        static let glyphSize: CGFloat = 20
        static let bookmarkReserve: CGFloat = 200   // ⬅️ new: space to keep text away from bookmark
    }
    private let lavender = Color(red: 0.74, green: 0.67, blue: 0.98)
    private let dateGray = Color.white.opacity(0.60)
    private let cardFill = Color.black.opacity(0.82)

    var body: some View {
        ZStack(alignment: .topTrailing) {

            // CONTENT
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(entry.title.isEmpty ? "Title" : entry.title)
                        .font(.system(size: UI.titleSize, weight: .bold, design: .rounded))
                        .foregroundStyle(lavender)

                    Text(dateString(entry.date))
                        .font(.system(.caption2, design: .rounded))
                        .foregroundStyle(dateGray)
                }

                Text(preview(entry.body))
                    .font(.system(size: UI.bodySize, weight: .regular))
                    .foregroundStyle(.white)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(UI.pad)
            .padding(.trailing, UI.bookmarkReserve)   // ⬅️ reserve space so title/body never sit under the bookmark

            // BOOKMARK
            Button(action: onBookmark) {
                Image(systemName: entry.isBookmarked ? "bookmark.fill" : "bookmark")
                    .font(.system(size: UI.glyphSize, weight: .semibold))
                    .foregroundStyle(lavender)
            }
            .padding(.top, 14)
            .padding(.trailing, 14)
            .buttonStyle(.plain)
        }
        // CARD
        .background(
            RoundedRectangle(cornerRadius: UI.corner, style: .continuous)
                .fill(cardFill)
        )
        .overlay(
            RoundedRectangle(cornerRadius: UI.corner, style: .continuous)
                .stroke(.white.opacity(0.08), lineWidth: 1)
                .allowsHitTesting(false)
        )
        .shadow(color: .black.opacity(0.55), radius: 24, x: 0, y: 12)
        .overlay(
            RoundedRectangle(cornerRadius: UI.corner, style: .continuous)
                .fill(LinearGradient(colors: [.white.opacity(0.08), .clear],
                                     startPoint: .top, endPoint: .center))
                .blendMode(.plusLighter)
                .allowsHitTesting(false)
        )
        .frame(maxWidth: .infinity, alignment: .leading)   // ⬅️ let the card fill the row width
        .contentShape(Rectangle())
    }

    private func dateString(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yyyy"
        return f.string(from: date)
    }

    private func preview(_ text: String) -> String {
        text.isEmpty ? "Type your Journal…" : text
    }
}

#Preview {
    ZStack { Color.black.ignoresSafeArea()
        EntryRow(
            entry: JournalEntry(title: "My Birthday", body: "Preview body do od dood od do od odd o dododd o do ddod od o …", isBookmarked: true)
        ) { }
        .padding(.horizontal, 20)                    // ⬅️ mirrors in-app side padding
    }
    .preferredColorScheme(.dark)
}
