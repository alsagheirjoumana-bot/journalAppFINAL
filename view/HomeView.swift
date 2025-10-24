import SwiftUI

struct HomeView: View {

    @StateObject private var vm = HomeViewModel(seedWithSamples: true)
    @State private var showEditor = false
    @State private var editingEntry: JournalEntry? = nil
    @State private var showDeleteAlert = false

    private enum UI {
        static let headerTop: CGFloat   = 6
        static let headerSide: CGFloat  = 20
        static let rowSide: CGFloat     = 20
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
                    List {
                        Section {
                            ForEach(vm.filteredEntries) { entry in
                                EntryRow(entry: entry) {
                                    vm.toggleBookmark(id: entry.id)
                                }
                                .onTapGesture {
                                    editingEntry = entry
                                    showEditor = true
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        vm.requestDelete(entry)
                                        showDeleteAlert = true
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                    .tint(.red)
                                }
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .padding(.horizontal, UI.rowSide)
                                .padding(.top, UI.firstRowTop)
                            }

                            Color.clear
                                .frame(height: 40)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
        }

        // Bottom glass search
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.secondary)

                TextField("Search", text: $vm.searchText)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .textFieldStyle(.plain)
                    .foregroundStyle(.primary)
                    .tint(Color("lightLavender")) // cursor

                Image(systemName: "mic.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 14)
            .glassCapsuleField()           // ← use helper
            .saturation(0.98)              // tiny tone tweak to match your mock
            .brightness(-0.02)
            .padding(.horizontal, UI.headerSide)
            .padding(.bottom, 8)
        }

        // iOS alert
        .alert("Delete Journal?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) { vm.confirmDelete() }
        } message: {
            Text("Are you sure you want to delete this journal?")
        }

        // Editor sheet
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

    // MARK: - Header with working Sort + Plus
    private var header: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text("Journal")
                .font(.system(.largeTitle, design: .rounded).bold())
                .foregroundStyle(.primary)

            Spacer(minLength: 0)

            
            // Glass pill
            HStack(spacing: 14) {
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
                        .accessibilityLabel("Sort")
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
                        .accessibilityLabel("Add Entry")
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, UI.pillVPad)
            .padding(.horizontal, UI.pillHPad)
            .glassPill()                       // ← just this
            .offset(y: UI.pillYOffset)

            // IMPORTANT: make overlays non-hit-testable so taps reach buttons
            .overlay(
                Capsule()
                    .stroke(.white.opacity(0.08), lineWidth: 1)
                    .allowsHitTesting(false)
            )
            .shadow(color: .black.opacity(0.55), radius: 22, x: 0, y: 10)
            .overlay(
                Capsule()
                    .fill(
                        LinearGradient(colors: [.white.opacity(0.10), .clear],
                                       startPoint: .top, endPoint: .center)
                    )
                    .blendMode(.plusLighter)
                    .allowsHitTesting(false)     // ← this was blocking taps
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
