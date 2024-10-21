//
//  CardView.swift
//  Flashcards
//
//  Created by Ben Gmach on 10/15/24.
//
import SwiftUI

struct CardView: View {

    let card: Card

    var body: some View {
        ZStack {
            if card.isFaceUp || card.isMatched {
                // Front of the card with emoji
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(radius: 5)

                Text(card.answer)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .scaleEffect(card.isFaceUp ? 1.2 : 1.0)
                    .opacity(card.isMatched ? 0.0 : 1.0) // Hide when matched
                    .animation(.easeInOut(duration: 0.6))
            } else {
                // Back of the card with a simple design
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.green)
                    .shadow(radius: 5)

                
            }
        }
        .frame(maxWidth: .infinity, minHeight: 170)
        .rotation3DEffect(
            .degrees(card.isFaceUp ? 0 : 180),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
        .animation(.easeInOut(duration: 0.6)) // Flip animation
        .opacity(card.isMatched ? 0.0 : 1.0) // Keep card in place but invisible when matched
    }
}


