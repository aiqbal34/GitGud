import Foundation
import SwiftUI

// Updated to be generic
struct SelectionView<Item, ItemLabel>: View where Item: Hashable, ItemLabel: View {
    @Binding var selectedItems: [Item] // Bind to the selected items array
    let allItems: [Item] // All available items
    let itemLabel: (Item) -> ItemLabel // Closure to provide a label for each item
    let filterPredicate: (Item, String) -> Bool // Closure to filter items based on the search text

    @State private var searchText = ""

    var filteredItems: [Item] {
        if searchText.isEmpty {
            return allItems // Return all items if no search text
        } else {
            return allItems.filter { filterPredicate($0, searchText) }
        }
    }

    var body: some View {
        VStack {
            TextField("Search...", text: $searchText)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)

            List {
                ForEach(filteredItems, id: \.self) { item in
                    Button(action: {
                        if !selectedItems.contains(item) {
                            selectedItems.append(item)
                        }
                        searchText = "" // Clear search field after selection
                    }) {
                        itemLabel(item)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
}

