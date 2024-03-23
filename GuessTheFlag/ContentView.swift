//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Masoud Safari on 2024-02-21.
//

import SwiftUI

struct ContentView: View {
    
    let totalNumberOfRounds = 8
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var totalScore = 0
    @State private var round = 0
    @State private var endOfGmae = false
    
    @State private var flagAngle = [0.0, 0.0, 0.0]
    @State private var flagOpacity = [1.0, 1.0, 1.0]
    
    let labels: [String: String] = [
        "Estonia": "Flag with three horizontal stripes. Top stripe blue, middle stripe black, bottom stripe white.",
        "France": "Flag with three vertical stripes. Left stripe blue, middle stripe white, right stripe red.",
        "Germany": "Flag with three horizontal stripes. Top stripe black, middle stripe red, bottom stripe gold.",
        "Ireland": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe orange.",
        "Italy": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe red.",
        "Monaco": "Flag with two horizontal stripes. Top stripe red, bottom stripe white.",
        "Nigeria": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe green.",
        "Poland": "Flag with two horizontal stripes. Top stripe white, bottom stripe red.",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red.",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background.",
        "Ukraine": "Flag with two horizontal stripes. Top stripe blue, bottom stripe yellow.",
        "US": "Flag with many red and white stripes, with white stars on a blue background in the top-left corner."
    ]
    
    var body: some View {
        
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .foregroundStyle(.secondary)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                            withAnimation(.easeInOut(duration: 1)) {
                                flagAngle[number] = 360
                            }
                            for i in 0..<3 {
                                if i != number {
                                    flagOpacity[i] = 0.25
                                }
                            }
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .shadow(radius: 5)
                        }
                        .accessibilityLabel(labels[countries[number], default: "Unknown"])
                        .opacity(flagOpacity[number])
                        .animation(.easeInOut(duration: 1), value: flagOpacity)
                        .rotation3DEffect(
                            .degrees(flagAngle[number]),
                            axis: (x: 0.0, y: 1.0, z: 0.0),
                            perspective: 0.7
                        )
                        
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 50))
                
                Spacer()
                
                Text("Round \(round + 1)")
                    .foregroundStyle(.white)
                    .font(.title2)
                
                Spacer()
                
                Text("Score \(totalScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding(30)
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(scoreMessage)
        }
        .alert("Done", isPresented: $endOfGmae) {
            Button("Start a new game") {
                totalScore = 0
                round = 0
                countries.shuffle()
                correctAnswer = Int.random(in: 0...2)
                flagAngle = [0.0, 0.0, 0.0]
                flagOpacity = [1.0, 1.0, 1.0]
            }
        } message: {
            Text("You guessed \(totalScore) \(totalScore == 1 ? "flag" : "flags") correctly out of \(totalNumberOfRounds).")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            scoreMessage = "You chose the correct flag."
            totalScore += 1
        } else {
            scoreTitle = "Wrong"
            scoreMessage = "You chose the \(countries[number]) flag."
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        if round + 1 == totalNumberOfRounds {
            endOfGmae = true
        } else {
            round += 1
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        }
        flagAngle = [0.0, 0.0, 0.0]
        flagOpacity = [1.0, 1.0, 1.0]
    }
    
}

#Preview {
    ContentView()
}
