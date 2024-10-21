//
//  Card.swift
//  MemoryGame
//
//  Created by Ben Gmach on 10/21/24.
//
import SwiftUI

struct Card: Identifiable, Equatable {
    let id = UUID() // Unique identifier for each card
    var question: String
    var answer: String
    var isFaceUp: Bool = false // Tracks if the card is face-up
    var isMatched: Bool = false // Tracks if the card has been matched
}
