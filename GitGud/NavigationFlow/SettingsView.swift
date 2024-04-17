import SwiftUI

/*
 - Allows user to adjust his current info
    such as name, major,...skills, etc
 - Logout functionality 
 */
struct SettingsView: View {
    
    // @Objects
    @EnvironmentObject var userModel: UserModel
    
    
    // User info fields
    @State private var searchText: String = ""
    @State var experience = ""
    var experienceLevels = ["Beginner", "Medium" ," Experienced"]
    @State var userName = ""
    @State var password = ""
    @State var university = ""
    @State var major = ""
    @State var showSkillSheet = false
    @State var chosenSkills: [String] = []
    @State var moveToLogin = false
    @State var isError: Bool = false
    
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
                            TextField("Enter University", text: $university)
                                .onAppear {
                                    university = userModel.university
                                }
                            TextField("Enter Major", text: $major)
                                .onAppear {
                                    major = userModel.major
                                }
                        }
                        .listRowBackground(Color.white)
                        .foregroundColor(Color(hex: "#543C86"))
                        
                        //Segmented picker for expereicen Level
                        Section(header: Text("Experience Level")){
                            Picker("Select Experience", selection: $experience) {
                                ForEach(experienceLevels, id: \.self) { item in
                                    Text(item)
                                        .foregroundColor(.blue)
                                        .font(.headline)
                                        .padding()
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding()
                        }
                        .onAppear {
                            experience = userModel.experience
                        }
                        .listRowBackground(Color.white)
                        .foregroundColor(Color(hex: "#543C86"))
                        
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
                            .foregroundColor(Color(hex: "#543C86"))
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
                                        .background(Color.white)
                                        .foregroundColor(Color(hex: "#543C86"))
                                        .fontDesign(.monospaced)
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        .padding()
                        .alert(isPresented: $isError, content: {
                            Alert(title: Text("Update Failed"), message: Text("Try Updating User Again"), dismissButton: .cancel())
                        })
                        HStack{
                            Spacer()
                            Button("Clear Skill Selection"){
                                chosenSkills = []
                            }
                            Spacer()
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                   
                    
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
                            var update = UserModel()
                            update.name = userName
                            update.university = university
                            update.major = major
                            update.techStack = chosenSkills
                            update.experience = experience

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
