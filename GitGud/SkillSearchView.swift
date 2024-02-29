//
//  SkillSearchView.swift
//  GitGud
//
//  Created by Sajed Hussein on 2/27/24.
//

import Foundation
import SwiftUI

struct SkillsSelectionView: View {
    @Binding var selectedSkills: [String] // Bind to the selected skills array
    let allSkills: [String] // All available skills

    @State private var searchText = ""

    var filteredSkills: [String] {
        if searchText.isEmpty {
            return []
        } else {
            return allSkills.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        VStack {
            TextField("Search Skills...", text: $searchText)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)

            List {
                ForEach(filteredSkills, id: \.self) { skill in
                    Button(skill) {
                        if !selectedSkills.contains(skill) {
                            selectedSkills.append(skill)
                        }
                        searchText = "" // Clear search field
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
}



//#Preview {
//    //SkillsSelectionView(selectedSkills: "hello", allSkills: ["metoo"])
//}

