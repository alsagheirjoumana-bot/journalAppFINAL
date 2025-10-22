//
//  SwiftUIView.swift
//  journalApp88
//
//  Created by Joumana Alsagheir on 22/10/2025.
//

//
//  HomeView.swift
//  journalApp88
//
//  Created by Joumana Alsagheir on 22/10/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var vm = HomeViewModel(seedWithSamples: true)

    @State private var showEditor = false
    @State private var editingEntry: JournalEntry? = nil

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                header

                if vm.filteredEntries.isEmpty {
                    EmptyStateView()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(vm.filteredEntries) { entry in
                                EntryRow(entry: entry) {
                                    vm.toggleBookmark(id: entry.id)
                                }
                                .padding(.horizontal, 16)
                                .onTapGesture {
                                    editingEntry = entry
                                    showEditor = true
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        vm.requestDelete(entry)
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                    .tint(.red)
                                }
                            }

                            Color.clear.frame(height: 40)
                        }
                        .padding(.top, 8)
                    }
                }
            }
        }
        // bottom glass search
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                TextField("Search", text: $vm.searchText)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                Image(systemName: "mic.fill").foregroundStyle(.secondary)
            }
            .glassCapsuleField()
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }

        // delete confirmation
        .confirmationDialog(
            "Delete Journal?",
            isPresented: .constant(vm.showingDeleteConfirmFor != nil),
            titleVisibility: .visible,
            presenting: vm.showingDeleteConfirmFor
        ) { _ in
            Button("Delete", role: .destructive) { vm.confirmDelete() }
            Button("Cancel", role: .cancel) { vm.showingDeleteConfirmFor = nil }
        } message: { _ in
            Text("Are you sure you want to delete this journal?")
        }

        // editor sheet
        .sheet(isPresented: $showEditor) {
            EditorView(
                title: editingEntry?.title ?? "",
                content: editingEntry?.body ?? "",
                onSave: { title, content in
                    var updated = editingEntry ?? JournalEntry()
                    updated.title = title
                    updated.body  = content
                    updated.date  = Date()
                    vm.save(updated)
                    showEditor = false
                },
                onCancel: {
                    if let e = editingEntry, e.title.isEmpty && e.body.isEmpty {
                        vm.requestDelete(e)
                        vm.confirmDelete()
                    }
                    showEditor = false
                }
            )
            .presentationDetents([.large])
            .preferredColorScheme(.dark)
        }
    }

    // MARK: - Header (title + glass pill with sort & plus)
    private var header: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text("Journal")
                .font(.system(.largeTitle, design: .rounded).bold())
                .foregroundStyle(.primary)

            Spacer(minLength: 0)

            HStack(spacing: 12) {
                // sort menu
                Menu {
                    Button("Sort by Bookmark") { vm.sort = .byBookmark }
                    Button("Sort by Entry Date") { vm.sort = .byDate }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.primary)
                }
                .buttonStyle(.plain)

                // add new entry
                Button {
                    let new = vm.createEmptyEntry()
                    editingEntry = new
                    showEditor = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .bold))
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.primary)
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .background(.ultraThickMaterial)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(.white.opacity(0.07), lineWidth: 1))
            .shadow(color: .black.opacity(0.5), radius: 22, x: 0, y: 10)
            .overlay(
                Capsule()
                    .fill(
                        LinearGradient(colors: [.white.opacity(0.10), .clear],
                                       startPoint: .top,
                                       endPoint: .center)
                    )
                    .blendMode(.plusLighter)
            )
        }
        .padding(.top, 2)
        .padding(.horizontal, 16)
    }
}

#Preview {
    HomeView().preferredColorScheme(.dark)
}
