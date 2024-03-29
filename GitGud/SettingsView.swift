import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var userModel: UserModel
    
    @State private var selectedTags: Set<String> = []
    @State private var searchText: String = ""
    @State var experience = ""
    var experienceLevels = ["beginner", "intermediate", "advanced"]
    @State var userName = ""
    @State var password = ""
    @State var email = ""
    @State var university = ""
    @State var major = ""
    @State var showSkillSheet = false
    @State var chosenSkills: [String] = []
    @State var moveToLogin = false

    var body: some View {
        NavigationStack {
            ZStack{
                Color.background
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    Spacer()
                    List {
                        Section(header: Text("Account Information")){
                            TextField(userModel.name, text: $userName)
                            TextField(userModel.email, text: $email)
                            TextField(userModel.university, text: $university)
                            TextField(userModel.major, text: $major)
                        }
                        .listRowBackground(Color.secondaryBackground)
                        .foregroundColor(Color.text)
                        
                        Section(header: Text("Experience Level")){
                            Picker("Select Major", selection: $experience) {
                                ForEach(experienceLevels, id: \.self) { item in
                                    Text(item)
                                        .foregroundColor(.blue) // Change the text color
                                        .font(.headline) // Set the font style
                                        .padding() // Add some padding around each text
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle()) // Apply MenuPickerStyle
                            .padding() // Add padding around the picker
                        }
                        .onAppear {
                            experience = userModel.experience
                        }
                        .listRowBackground(Color.secondaryBackground)
                        .foregroundColor(Color.text)
                        
                        HStack {
                            Spacer()
                            Button("Choose Skills") {
                                showSkillSheet.toggle()
                            }.sheet(isPresented: $showSkillSheet, content: {
                                SelectionView(selectedItems: $chosenSkills, allItems: allSkills, itemLabel: { skill in
                                    Text(skill)
                                }, filterPredicate: { skill, searchText in
                                    skill.lowercased().contains(searchText.lowercased())
                                })
                            })
                            .frame(width: 200, height: 50)
                            .background(Color.secondaryBackground)
                            .foregroundColor(.text)
                            .fontDesign(.monospaced)
                            .cornerRadius(10)
                            .fontWeight(.bold)
                            .padding(.bottom)
                            Spacer()
                        }
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                            ForEach(chosenSkills, id: \.self) { skill in
                                HStack {
                                    Text(skill)
                                        .padding()
                                        .background(Color.secondaryBackground)
                                        .foregroundColor(.text)
                                        .fontDesign(.monospaced)
                                        .clipShape(Capsule())
                                    
                                    Button(action: {
                                    }) {
                                        Image(systemName: "x.circle")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    .listStyle(InsetGroupedListStyle())
                    //.searchable(text: $searchText)
                    
                    .onAppear {
                        chosenSkills = userModel.techStack
                    }
                    //Spacer()
                    
                    Button("Logout") {
                        //TODO
                        moveToLogin = true
                    }
                    Spacer()
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $moveToLogin){
            LoginView()
        }
        
        
    }
}

#Preview {
        SettingsView()
}
