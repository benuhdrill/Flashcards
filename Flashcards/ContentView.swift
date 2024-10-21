//
//  ContentView.swift
//  Flashcards
//
//  Created by Ben Gmach on 10/15/24.
//
import SwiftUI

struct ContentView: View {

    @State private var cards: [Card] = [] // Store the cards
    @State private var selectedCards: [Card] = [] // Store flipped cards for comparison
    @State private var selectedPairs = 3 // Default selected value
    let pairsOptions = [3, 6, 10] // Options for the number of pairs
    @State private var showResetAnimation = false // Track game reset animation

    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    let emojiOptions = ["🐶", "🐱", "🦊", "🐻", "🐸", "🐵", "🐔", "🐼", "🦁", "🐮"]

    var body: some View {
        ZStack {
            // Simple gray background
            Color.white
                .edgesIgnoringSafeArea(.all)

            VStack {
                // Top bar with "Choose Size" and "Reset Game" buttons
                HStack {
                    // Button with scale animation on press
                    Picker("Choose Size", selection: $selectedPairs) {
                        ForEach(pairsOptions, id: \.self) { pair in
                            Text("\(pair) Pairs").tag(pair)
                        }
                    }
                    .pickerStyle(MenuPickerStyle()) // Make it look like a menu
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                    .scaleEffect(showResetAnimation ? 1.1 : 1.0) // Animation on button
                    .animation(.spring(), value: showResetAnimation)
                    .onChange(of: selectedPairs) { _ in
                        withAnimation {
                            resetGame() // Reset the game when a new size is selected
                        }
                    }

                    Spacer()

                    Button(action: {
                        withAnimation {
                            resetGame() // Reset the game when the reset button is clicked
                        }
                    }) {
                        Text("Reset Game")
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                    }
                    .scaleEffect(showResetAnimation ? 1.1 : 1.0) // Animation on press
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showResetAnimation = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showResetAnimation = false
                        }
                    }
                }
                .padding()

                // Display the cards grid
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(cards) { card in
                            CardView(card: card)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.6)) {
                                        handleCardTap(card)
                                    }
                                }
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            resetGame() // Shuffle the cards when the view first appears
        }
        .transition(.opacity) // Add fade transition when game resets
    }

    // Reset game logic, shuffle cards ONCE, and reset state
    func resetGame() {
        var allCards: [Card] = []

        for pairIndex in 0..<selectedPairs {
            let emoji = emojiOptions[pairIndex % emojiOptions.count] // Pick an emoji for the pair
            allCards.append(Card(question: "Q\(pairIndex)", answer: emoji))
            allCards.append(Card(question: "Q\(pairIndex)", answer: emoji))
        }
        
        cards = allCards.shuffled() // Shuffle once at the start
        selectedCards = [] // Clear selected cards
    }

    // Handle card tap logic
    func handleCardTap(_ tappedCard: Card) {
        guard let index = cards.firstIndex(of: tappedCard), !cards[index].isFaceUp else { return }

        // If two cards are already flipped and another card is tapped, flip them back
        if selectedCards.count == 2 {
            flipBackSelectedCards()
        }

        // Flip the current card face-up
        cards[index].isFaceUp.toggle()

        // Add the card to selected cards for comparison
        selectedCards.append(cards[index])

        // If two cards are selected, check for a match
        if selectedCards.count == 2 {
            checkForMatch()
        }
    }

    // Flip back selected cards if they are not a match
    func flipBackSelectedCards() {
        for card in selectedCards {
            if let index = cards.firstIndex(of: card) {
                cards[index].isFaceUp = false
            }
        }
        selectedCards = []
    }

    // Check if the selected cards are a match
    func checkForMatch() {
        let firstCard = selectedCards[0]
        let secondCard = selectedCards[1]

        if firstCard.answer == secondCard.answer {
            // Mark both cards as matched, but keep them in place with opacity 0
            if let firstIndex = cards.firstIndex(of: firstCard),
               let secondIndex = cards.firstIndex(of: secondCard) {
                cards[firstIndex].isMatched = true
                cards[secondIndex].isMatched = true
            }
            selectedCards = [] // Clear selected cards if matched
        }
    }
}

#Preview {
    ContentView()
}
