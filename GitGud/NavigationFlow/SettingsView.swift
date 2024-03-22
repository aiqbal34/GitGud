import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var userModel: UserModel
    
    //@State private var removeTags: Set<String> = []
    @State private var searchText: String = ""
    @State var experience = ""
    var experienceLevels = ["Beginner", "Medium", "Experienced"]
    @State var userName = ""
    @State var password = ""
    //@State var email = ""
    @State var university = ""
    @State var major = ""
    @State var showSkillSheet = false
    @State var chosenSkills: [String] = []
    @State var moveToLogin = false
    
    @State var removeTags: [String] = []
    
    var body: some View {
        NavigationStack {
            ZStack{
                GradientStyles.backgroundGradient.ignoresSafeArea()
                VStack{
                    Spacer()
                    List {
                        
                        Section(header: Text("Account Information")){
                            TextField("Enter Name", text: $userName)
                                .onAppear {
                                    userName = userModel.name
                                }
                            //TextField(userModel.email, text: $email)
                            TextField("Enter University", text: $university)
                                .onAppear {
                                    university = userModel.university
                                }
                            TextField("Enter Major", text: $major)
                                .onAppear {
                                    major = userModel.major
                                }
                        }
                        .listRowBackground(Color.secondaryBackground)
                        .foregroundColor(Color.text)
                        
                        Section(header: Text("Experience Level")){
                            Picker("Select Experience", selection: $experience) {
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
                                SearchViewModel(selectedItems: $chosenSkills, allItems: allSkills, itemLabel: { skill in
                                    Text(skill)
                                }, filterPredicate: { skill, searchText in
                                    skill.lowercased().contains(searchText.lowercased())
                                })
                            })
                            .frame(width: 200, height: 50)

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
                                    
//                                    Button(action: {
//                                        //let chosen = skill
//                                        print(skill)
////                                        chosenSkills.removeAll(where:{
////                                            //let shorthand = $0
////                                            $0 == "React"
////                                            
////                                        })
//                                        
//                                        //chosenSkills.removeLast()
//
//                                    }) {
//                                        Image(systemName: "x.circle")
//                                            .foregroundColor(.red)
//                                    }
                                }
                            }
                        }
                        .padding()
                        
                        HStack{
                            Spacer()
                            Button("Clear Skill Selection"){
                                chosenSkills = []
                            }
                            Spacer()
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    //.searchable(text: $searchText)
                    
                    .onAppear {
                        chosenSkills = userModel.techStack
                    }
                    //Spacer()
                    HStack{
                        Spacer()
                        Button("Logout") {
                            moveToLogin = true
                            UserDefaults.standard.removeObject(forKey: "userID")
                        }
                        Spacer()
                        Button("Save"){
                            
                        }
                        Spacer()
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
            .environmentObject(UserModel())
}
