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
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .shadow(radius: 5)
                        }
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
    }
    
}

#Preview {
    ContentView()
}
