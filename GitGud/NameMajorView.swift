//
//  NameMajorView.swift
//  GitGud
//
//  Created by Aariz Iqbal on 2/26/24.
//

import SwiftUI

struct NameMajorView: View {
    
    @EnvironmentObject var userModel: UserModel
    
    @State var move_to_techStackView = false
    @State var name = ""
    @State var Major = ""
    @State var email = ""
    
    
    @FocusState var isKeyBoard: Bool
    @State var chosenMajor = "Select Major"
    @State var chosenSchool = "Select College"
    @State var showMajorSheet = false
    @State var showCollegeSheet = false
    
    var Colleges = [
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
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.background)
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    Text("Create Profile")
                        .font(.system(size: 24))
                        .foregroundColor(.text)
                        .fontDesign(.monospaced)
                        .padding(.bottom)
                        .fontWeight(.bold)
                    HStack {
                        TextField("Name", text: $name)
                            .frame(width: 200)
                            .foregroundColor(.text)
                            .fontDesign(.monospaced)
                            .focused($isKeyBoard)
                    }
                    Rectangle()
                        .frame(width: 200, height: 2)
                        .foregroundColor(.text)
                        .padding(.bottom)
                    Button(chosenMajor) {
                        showMajorSheet.toggle()
                    }.sheet(isPresented: $showMajorSheet, content: {
                        SelectionViewSingleItem(allItems: dropDownItem, itemLabel: {
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
                    .background(Color.secondaryBackground)
                    .foregroundColor(.text)
                    .fontDesign(.monospaced)
                    .cornerRadius(10)
                    .fontWeight(.bold)
                    .padding(.bottom)
                    
                    Button(chosenSchool) {
                        showCollegeSheet.toggle()
                    }.sheet(isPresented: $showCollegeSheet, content: {
                        SelectionViewSingleItem(allItems: Colleges, itemLabel: {
                            school in Text(school).onTapGesture {
                                showMajorSheet = false
                                print(school)
                                chosenSchool = school
                            }
                        }, filterPredicate: { school, searchText in
                            school.lowercased().contains(searchText.lowercased())
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
                    HStack {
                        Spacer()
                        Button("Next") {
                            if chosenMajor != "Select Major" && name != "" && chosenSchool != "Select College" {
                                userModel.name = name
                                userModel.major = chosenMajor
                                userModel.university = chosenSchool
                                move_to_techStackView = true
                            }
                        }
                        .padding(.trailing, 35)
                        .padding(.top, 25)
                        .foregroundColor(.text)
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

#Preview {
    NameMajorView()
}
