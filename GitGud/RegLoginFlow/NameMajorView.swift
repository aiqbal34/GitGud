//
//  NameMajorView.swift
//  GitGud
//
//  Created by Aariz Iqbal on 2/26/24.
//

import SwiftUI
/*
  - Displays and prompts: name and major
 */
struct NameMajorView: View {
    
    // @Objects
    @EnvironmentObject var userModel: UserModel
    
    @FocusState var isKeyBoard: Bool
    @State var name = ""
    @State var chosenMajor = "Select Major"
    @State var chosenSchool = "Select College"
    @State var showMajorSheet = false
    @State var showCollegeSheet = false
    @State var move_to_techStackView = false
    
    // List of Universities in California
    let Colleges = [
        "University of California, Berkeley",
        "University of California, Los Angeles",
        "University of California, San Diego",
        "University of California, San Francisco",
        "University of California, Davis",
        "University of California, Irvine",
        "University of California, Santa Barbara",
        "University of California, Riverside",
        "University of California, Santa Cruz",
        "California State University, Los Angeles",
        "California State University, Fullerton",
        "California State University, Long Beach",
        "California State University, Northridge",
        "California State University, San Bernardino",
        "California State University, San Marcos",
        "California State University, Chico",
        "California State University, Sacramento",
        "California State University, Fresno",
        "California State University, Bakersfield",
        "California State University, East Bay",
        "California State University, San Francisco",
        "California State University, Stanislaus",
        "California Polytechnic State University, San Luis Obispo",
        "California Polytechnic State University, Pomona",
        "San Diego State University",
        "San Jose State University",
        "Santa Clara University",
        "Stanford University",
        "Pepperdine University",
        "University of Southern California",
        "Pomona College",
        "Claremont McKenna College",
        "Harvey Mudd College",
        "Scripps College",
        "Pitzer College",
        "Occidental College",
        "Loyola Marymount University",
        "University of San Francisco",
        "University of San Diego",
        "California Institute of Technology",
        "California Institute of the Arts",
      "Princess Sumaya University for Technology"
      ]
    
    // List of majors
    var dropDownItem = [
        "Accounting",
        "Aerospace Engineering",
        "Agricultural Business",
        "Agricultural Economics",
        "Agricultural Education",
        "Agricultural Engineering",
        "Agricultural Science",
        "Agriculture",
        "American Studies",
        "Animal Science",
        "Anthropology",
        "Applied Mathematics",
        "Applied Physics",
        "Archaeology",
        "Architecture",
        "Art",
        "Art History",
        "Asian Studies",
        "Astronomy",
        "Astrophysics",
        "Biochemistry",
        "Bioengineering",
        "Biology",
        "Biomedical Engineering",
        "Biotechnology",
        "Business Administration",
        "Chemical Engineering",
        "Chemistry",
        "Child Development",
        "Civil Engineering",
        "Classics",
        "Communication",
        "Computer Engineering",
        "Computer Science",
        "Construction Management",
        "Criminal Justice",
        "Culinary Arts",
        "Dance",
        "Dental Hygiene",
        "Drama",
        "Earth Science",
        "Ecology",
        "Economics",
        "Education",
        "Electrical Engineering",
        "Engineering",
        "English",
        "Environmental Engineering",
        "Environmental Science",
        "Fashion Design",
        "Film Studies",
        "Finance",
        "Fine Arts",
        "Food Science",
        "Foreign Languages",
        "Forensic Science",
        "Forestry",
        "Gender Studies",
        "Genetics",
        "Geography",
        "Geology",
        "Graphic Design",
        "Health Education",
        "Health Sciences",
        "History",
        "Horticulture",
        "Hospitality Management",
        "Human Resources",
        "Human Services",
        "Industrial Design",
        "Information Technology",
        "Interior Design",
        "International Business",
        "International Relations",
        "Journalism",
        "Kinesiology",
        "Landscape Architecture",
        "Law",
        "Linguistics",
        "Management",
        "Marine Biology",
        "Marketing",
        "Mathematics",
        "Mechanical Engineering",
        "Media Studies",
        "Medical Technology",
        "Meteorology",
        "Microbiology",
        "Music",
        "Nursing",
        "Nutrition",
        "Occupational Therapy",
        "Oceanography",
        "Operations Management",
        "Optometry",
        "Pharmacy",
        "Philosophy",
        "Photography",
        "Physical Education",
        "Physical Therapy",
        "Physics",
        "Physiology",
        "Political Science",
        "Psychology",
        "Public Administration",
        "Public Health",
        "Public Relations",
        "Radiologic Technology",
        "Real Estate",
        "Recreation Management",
        "Religious Studies",
        "Social Work",
        "Sociology",
        "Software Engineering",
        "Spanish",
        "Speech Pathology",
        "Sports Management",
        "Statistics",
        "Supply Chain Management",
        "Sustainability",
        "Theater",
        "Theology",
        "Tourism Management",
        "Urban Planning",
        "Veterinary Science",
        "Visual Arts",
        "Wildlife Biology",
        "Women's Studies",
        "Zoology"
    ]

    @State var selectedMajor = []
    @State var searchtext = ""
    @State var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                GradientStyles.backgroundGradient.ignoresSafeArea()
                VStack {
                    Spacer()
                    Text("Create Profile")
                        .font(.system(size: 24))
                        .foregroundColor(Color(hex: "#543C86"))
                        .fontDesign(.monospaced)
                        .padding(.bottom)
                        .fontWeight(.bold)
                    HStack {
                        TextField("Name", text: $name)
                            .frame(width: 200)
                            .foregroundColor(Color(hex: "#543C86"))
                            .fontDesign(.monospaced)
                            .focused($isKeyBoard)
                    }
                    Rectangle()
                        .frame(width: 200, height: 2)
                        .foregroundColor(Color(hex: "#543C86"))
                        .padding(.bottom)
                    Button(chosenMajor) {
                        showMajorSheet.toggle()
                    }.sheet(isPresented: $showMajorSheet, content: {
                        // Pop-up search menu
                        SearchSingleViewModel(allItems: dropDownItem, itemLabel: {
                            major in Text(major).onTapGesture {
                                showMajorSheet = false
                                print(major)
                                chosenMajor = major
                            }
                        }, filterPredicate: { major, searchText in
                            major.lowercased().contains(searchText.lowercased())
                        })
                    })
                    .frame(width: 200, height: 50)
                    .background(Color.white)
                    .foregroundColor(Color(hex: "#543C86"))
                    .fontDesign(.monospaced)
                    .cornerRadius(10)
                    .fontWeight(.bold)
                    .padding(.bottom)
                    
                    Button(chosenSchool) {
                        showCollegeSheet.toggle()
                    }.sheet(isPresented: $showCollegeSheet, content: {
                        // Pop-up search menu 
                        SearchSingleViewModel(allItems: Colleges, itemLabel: {
                            school in Text(school).onTapGesture {
                                showCollegeSheet = false
                                print(school)
                                chosenSchool = school
                            }
                        }, filterPredicate: { school, searchText in
                            school.lowercased().contains(searchText.lowercased())
                        })
                    })
                    .frame(width: 200, height: 50)
                    .background(Color.white)
                    .foregroundColor(Color(hex: "#543C86"))
                    .fontDesign(.monospaced)
                    .cornerRadius(10)
                    .fontWeight(.bold)
                    .padding(.bottom)
                    
                    Text(errorMessage)
                        .fontDesign(.monospaced)
                        .foregroundColor(.red)
                    
                    Spacer()
                    HStack {
                        Spacer()
                        Button("Next") {
                            if chosenMajor != "Select Major" && name != "" && chosenSchool != "Select College" {
                                userModel.name = name
                                userModel.major = chosenMajor
                                userModel.university = chosenSchool
                                move_to_techStackView = true
                                errorMessage = ""
                            }else{
                                errorMessage = "Please Enter All Fields"
                            }
                        }
                        .padding(.trailing, 35)
                        .padding(.top, 25)
                        .foregroundColor(Color(hex: "#543C86"))
                        .fontWeight(.bold)
                        
                    }
                }
            }
            .navigationDestination(isPresented: $move_to_techStackView) {
                TechStackView()
                    .environmentObject(userModel)
            }
        }
        
    }
}
