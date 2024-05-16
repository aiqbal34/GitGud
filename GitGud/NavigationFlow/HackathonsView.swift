import SwiftUI

struct HackathonCardView: View {
    var hackathon: Hackathon
    
    var body: some View {
        VStack {
            HStack {
                if let imageUrl = hackathon.image_url, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .clipped()
                            .cornerRadius(12)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 120, height: 120)
                    }
                } else {
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 120, height: 120)
                        .cornerRadius(12)
                }
                
                Spacer()
    
                Text(hackathon.title ?? "N/A")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .foregroundColor(.black)
            }
            VStack {
                HStack {
                    Text(hackathon.host ?? "N/A")
                        .font(.subheadline)
                    Spacer()
                    Text("\(hackathon.participants ?? "0") participants")
                        .font(.subheadline)
                }
                .foregroundColor(.secondary)
                HStack {
                    Text(hackathon.submission_period ?? "N/A")
                        .font(.caption)
                    Spacer()
                    Text(hackathon.prize_amount ?? "N/A")
                        .font(.caption)
                }
                HStack {
                    if let themes = hackathon.themes {
                        ForEach(themes, id: \.self) { theme in
                            Text(theme)
                                .font(.caption)
                                .padding(5)
                                .background(Color.blue)
                                .cornerRadius(5)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 5)
    }
}

struct HackathonsView: View {
    @State private var hackathons: [Hackathon] = []
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            GradientStyles.backgroundGradient.ignoresSafeArea()
            VStack {
                Text("Hackathons")
                    .fontWeight(.bold)
                    .font(.title)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.white)
                
                if hackathons.isEmpty && errorMessage == nil {
                    ProgressView()
                        .onAppear {
                            Task {
                                await fetchHackathonsData()
                            }
                        }
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    List(hackathons) { hackathon in
                        HackathonCardView(hackathon: hackathon)
                            .listRowBackground(Color.clear)
                    }
                    .background(Color.clear)
                    .listStyle(PlainListStyle())
                }
            }
        }
    }

    private func fetchHackathonsData() async {
        do {
            hackathons = try await fetchHackathons()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    HackathonsView()
}
