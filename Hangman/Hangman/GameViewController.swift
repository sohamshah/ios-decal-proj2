//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var guessButton: UIButton!
    @IBOutlet weak var incorrectGuessList: UILabel!
    @IBOutlet weak var letterToGuess: UITextField!
    @IBOutlet weak var wordToGuess: UILabel!
    @IBOutlet weak var hangman: UIImageView!
    var phrase : String?
    var arrPhrase : [Character]?
    var length_phrase : Int?
    var arrayOfBools : [Bool]?
    var setOfWordCharacters = Set<String>()
    var wrongGuesses = Set<String>()
    var death = 1
    override func viewDidLoad() {
        super.viewDidLoad()

        let hangmanPhrases = HangmanPhrases()
        phrase = hangmanPhrases.getRandomPhrase()
        arrPhrase = [Character](phrase!.characters)
        length_phrase = phrase!.characters.count
        arrayOfBools = [Bool](repeating: false, count: length_phrase!)
        for c in arrPhrase! {
            setOfWordCharacters.insert(String(c))

        }
        for index in 0...length_phrase!-1 {
            if (String(arrPhrase![index]) == " ") {
                arrayOfBools![index] = true
            }
        }
        displayWord()
    }

    @IBAction func typingInText(_ sender: AnyObject) {
        if letterToGuess.text!.characters.count > 2 {
            letterToGuess.text = ""
        }
    }
    func displayWord() {
        wordToGuess.text = ""
        for index in 0...length_phrase!-1 {
            if arrayOfBools![index] {
                wordToGuess.text = wordToGuess.text! + String(arrPhrase![index]) + " "
            } else {
                wordToGuess.text = wordToGuess.text! + "- "
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func isCorrectGuess(_ guess: String) {

    }
    @IBAction func newGameRequested(_ sender: AnyObject) {
        reset()
    }
    @IBAction func guessMade(_ sender: AnyObject) {
        let guess = letterToGuess.text

        if guess!.characters.count == 1 {
            if (setOfWordCharacters.contains(guess!)) {
                for index in 0...length_phrase!-1 {
                    if guess == String(arrPhrase![index]) {
                        arrayOfBools![index] = true
                    }
                }
                if (testIfWon()) {
                    let alertController = UIAlertController(
                        title: "Ayyye good shit you won!",
                        message: "Starting a new game!!",
                        preferredStyle: .alert)
                    let newGameAction = UIAlertAction(title: "OK", style: .default) {
                        action in self.reset()
                    }
                    alertController.addAction(newGameAction)
                    self.present(alertController, animated: true, completion: nil)
                }

            }
            else {
                if !wrongGuesses.contains(String(guess!)) {
                    wrongGuesses.insert(String(guess!))
                    if death < 7 {
                        death += 1
                        let imageName = "hangman" + String(death) + ".gif"
                        hangman.image = UIImage(named: imageName)
                    }
                    if death > 6{
                        let alertController = UIAlertController(
                            title: "You suck.",
                            message: "Try again young padawan warrior",
                            preferredStyle: .alert)
                        let newGameAction = UIAlertAction(title: "OK", style: .default) {
                            action in self.reset()
                        }
                        alertController.addAction(newGameAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    incorrectGuessList.text = String(describing: wrongGuesses)
                }
            }
        }
        letterToGuess.text = ""
        displayWord()
    }

    func reset() {
        self.wordToGuess.text = ""
        self.setOfWordCharacters = Set<String>()
        self.wrongGuesses = Set<String>()
        self.death = 1
        let hangmanPhrases = HangmanPhrases()
        self.phrase = hangmanPhrases.getRandomPhrase()
        self.arrPhrase = [Character](self.phrase!.characters)
        self.length_phrase = self.phrase!.characters.count
        self.arrayOfBools = [Bool](repeating: false, count: self.length_phrase!)
        for c in self.arrPhrase! {
            self.setOfWordCharacters.insert(String(c))

        }
        let imageName = "hangman" + String(death) + ".gif"
        hangman.image = UIImage(named: imageName)
        incorrectGuessList.text = ""
        self.displayWord()
    }
    func testIfWon() -> Bool{
        for x in arrayOfBools! {
            if (x == false) {
                return false
            }
        }
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


    /*

     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     }
     */

}
