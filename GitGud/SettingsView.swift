import SwiftUI

struct SettingsView: View {
    @State private var selectedTags: Set<String> = []
    @State private var searchText: String = ""
    let tags = ["Swift", "Java", "Python", "C++", "Rust"]
    @State var userName = ""
    @State var password = ""
    @State var email = ""
    @State var university = ""
    @State var major = ""

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Account Information")){
                    TextField("Username", text: $userName)
                    TextField("Password", text: $password)
                    TextField("Email", text: $email)
                    TextField("University", text: $university)
                    TextField("Major", text: $major)
                }
                .listRowBackground(Color.secondaryBackground)
                .foregroundColor(Color.text)
                
                
                Section(header: Text("Skill tags")){
                    ForEach(tags, id: \.self) { tag in
                        Toggle(tag, isOn: Binding(
                            get: { self.selectedTags.contains(tag) },
                            set: { isSelected in
                                if isSelected {
                                    self.selectedTags.insert(tag)
                                } else {
                                    self.selectedTags.remove(tag)
                                }
                            }
                        ))
                        
                    }
                }
                .listRowBackground(Color.secondaryBackground)
                .foregroundColor(Color.text)
            }
            .listStyle(InsetGroupedListStyle())
            .searchable(text: $searchText)
            .navigationTitle("Settings")
        }
    }
}

#Preview {
        SettingsView()
}
