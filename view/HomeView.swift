//
//  SwiftUIView.swift
//  journalApp88
//
//  Created by Joumana Alsagheir on 22/10/2025 .
//

import SwiftUI

struct HomeView: View {
    @StateObject private var vm = HomeViewModel(seedWithSamples: true)

    @State private var showEditor = false
    @State private var editingEntry: JournalEntry? = nil

    // Use boolean dialog + keep selected item separately
    @State private var showDeleteDialog = false
    @State private var deleteTarget: JournalEntry? = nil

    // Layout tokens
    private enum UI {
        static let headerTop: CGFloat   = 6
        static let headerSide: CGFloat  = 20
        static let rowSide: CGFloat     = 20
        static let rowSpacing: CGFloat  = 22
        static let firstRowTop: CGFloat = 12
        static let pillHPad: CGFloat    = 16
        static let pillVPad: CGFloat    = 10
        static let pillYOffset: CGFloat = -2
    }

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                header

                if vm.filteredEntries.isEmpty {
                    EmptyStateView()
                } else {
                    ScrollView {
                        VStack(spacing: UI.rowSpacing) {
                            ForEach(vm.filteredEntries) { entry in
                                EntryRow(entry: entry) {
                                    vm.toggleBookmark(id: entry.id)
                                }
                                .padding(.horizontal, UI.rowSide)
                                .onTapGesture {
                                    editingEntry = entry
                                    showEditor = true
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        deleteTarget = entry
                                        showDeleteDialog = true
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                    .tint(.red) // round red bubble
                                }
                            }
                            .padding(.top, UI.firstRowTop)
                            Color.clear.frame(height: 40) // space for bottom search
                        }
                    }
                }
            }
        }
        // Bottom liquid-glass search
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                TextField("Search", text: $vm.searchText)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .foregroundStyle(.primary)
                Image(systemName: "mic.fill").foregroundStyle(.secondary)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 14)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(.white.opacity(0.06), lineWidth: 1).allowsHitTesting(false))
            .shadow(color: .black.opacity(0.35), radius: 18, x: 0, y: 8)
            .padding(.horizontal, UI.headerSide)
            .padding(.bottom, 8)
        }

        // Delete confirmation (boolean overload — very stable)
        .confirmationDialog(
            "Delete Journal?",
            isPresented: $showDeleteDialog,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                if let item = deleteTarget {
                    vm.requestDelete(item)
                    vm.confirmDelete()
                }
                deleteTarget = nil
            }
            Button("Cancel", role: .cancel) {
                deleteTarget = nil
            }
        } message: {
            Text("Are you sure you want to delete this journal?")
        }

        // Editor sheet (new or edit)
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
                        vm.requestDelete(e); vm.confirmDelete()
                    }
                    showEditor = false
                }
            )
            .presentationDetents([.large])
            .preferredColorScheme(.dark)
        }
    }

    // Header with glass pill (Sort + Plus)
    private var header: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text("Journal")
                .font(.system(.largeTitle, design: .rounded).bold())
                .foregroundStyle(.primary)

            Spacer(minLength: 0)

            HStack(spacing: 14) {
                // Popover picker (system checkmark style)
                Menu {
                    Picker("Sort", selection: $vm.sort) {
                        Text("Sort by Bookmark").tag(HomeSort.byBookmark)
                        Text("Sort by Entry Date").tag(HomeSort.byDate)
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.primary)
                }
                .buttonStyle(.plain)

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
            .padding(.vertical, UI.pillVPad)
            .padding(.horizontal, UI.pillHPad)
            .background(.ultraThickMaterial)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(.white.opacity(0.08), lineWidth: 1).allowsHitTesting(false))
            .shadow(color: .black.opacity(0.55), radius: 22, x: 0, y: 10)
            .overlay(
                Capsule()
                    .fill(LinearGradient(colors: [.white.opacity(0.10), .clear],
                                         startPoint: .top, endPoint: .center))
                    .blendMode(.plusLighter)
                    .allowsHitTesting(false)
            )
            .background(
                Capsule()
                    .fill(Color.black.opacity(0.35))
                    .blur(radius: 18)
                    .offset(y: 2)
                    .allowsHitTesting(false)
            )
            .compositingGroup()
            .offset(y: UI.pillYOffset)
        }
        .padding(.top, UI.headerTop)
        .padding(.horizontal, UI.headerSide)
    }
}

#Preview {
    HomeView().preferredColorScheme(.dark)
}
