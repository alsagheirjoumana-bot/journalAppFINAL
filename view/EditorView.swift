//
//  SwiftUIView.swift
//  journalApp88
//
//  Created by Joumana Alsagheir on 22/10/2025.
//

import SwiftUI

struct EditorView: View {
    @State var title: String
    @State private var showDiscardConfirm = false

    @State var content: String            // <- renamed from `body`
    var onSave: (String, String) -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // Top actions
            HStack {
                Button { onCancel() } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button { onSave(title, content) } label: {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(canSave ? Color.accentColor : .gray)
                }
                .disabled(!canSave)
            }
            .padding(.horizontal)
            .padding(.top, 8)

            // Title
            TextField("Title", text: $title)
                .font(.title.weight(.semibold))
                .padding(.horizontal)

            // Date
            Text(Date().formatted(date: .abbreviated, time: .omitted))
                .foregroundColor(.secondary)
                .padding(.horizontal)

            // Content
            ZStack(alignment: .topLeading) {
                if content.isEmpty {
                    Text("Type your Journal...")
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 6)
                        .padding(.top, 8)
                }
                TextEditor(text: $content)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal)
            }

            Spacer(minLength: 0)
        }
        .padding(.bottom)
        .background(Color(.systemBackground).ignoresSafeArea())
    }

    private var canSave: Bool {
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

#Preview {
    EditorView(title: "", content: "") { _, _ in } onCancel: { }
        .preferredColorScheme(.dark)
}
