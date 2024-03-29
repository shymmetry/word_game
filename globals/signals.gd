extends Node

# Flow
signal ResetGame
signal StartRound
signal GameOver
signal RoundOver
signal ShowShop
signal NextRound

# Game
signal WordGuess
signal WordFound
signal WordHandled
signal BoardChanged
signal ExplodeFinished
signal DropFinished
signal NotifyPlayer
signal ResetBoard

# Poem
signal StartWordScoring

# Shop
signal PurchaseItem
signal ItemPurchaseComplete
signal RefreshShop

# Tutorial
signal TutorialNext
signal TutorialSkipped
signal StartTutorial
