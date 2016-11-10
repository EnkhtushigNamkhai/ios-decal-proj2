//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    @IBOutlet weak var status_report: UILabel!
    @IBOutlet weak var placeholder: UILabel!
    @IBOutlet weak var TextFieldEntry: UITextField!
    @IBOutlet weak var missedLetters: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    
    
    var word = String()
    var correctlyGuessed = Array<String>()
    var missedGuessed = Array<String>()
    var num_missed = 0
    
    func containsOnlyLetters(input: String) -> Bool {
        for chr in input.characters {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                return false
            }
        }
        return true
    }
    
    func pop_up(str: String) {
        var msg = String()
        if (str == "You won!") {
            msg = ""
        } else {
             msg = "The word was " + word + "."
        }
       
        let alertController = UIAlertController(title: str, message: msg, preferredStyle: .alert)
        
        let StartOver = UIAlertAction(title: "New Game", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.viewDidLoad()
        }
        //let Cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        print("lost")
        ImageView.image = UIImage(named: "hangman7.gif")
        alertController.addAction(StartOver)
//      alertController.addAction(Cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func Guess(_ sender: Any) {
        let input = TextFieldEntry.text!
        TextFieldEntry.text = ""
        if (input.characters.count == 1 && containsOnlyLetters(input: input) && !correctlyGuessed.contains(input.lowercased()) && !missedGuessed.contains(input.lowercased())) { //also make sure input is only letters and has not guessed before
            print(word)
            //loses when 6 fail
            //wins when the fail is less than 6 and got all the blanks right.
            
            if hasCharacter(word: word, char: input) {
                replace(word: word, char: input)
                if hasCharacter(word: placeholder.text!, char: "_") {
                    status_report.text = "YOU GOT IT!"
                    //if has it, set the index of placeholder to be corresponding
                    print("has it!!!")
                } else {
                    //won pop up
                    pop_up(str: "You won!")
                    print("won")
                }
                
            } else {
                //if lost 6 times, game over and pop up should appear
                num_missed += 1
                if (num_missed < 6) {
                    var pic_string = "hangman" + String(num_missed + 1) + ".gif"
                    ImageView.image = UIImage(named: pic_string)
                    //update picture
                    missedGuessed.append(input.lowercased())
                    
                    missedLetters.text! += input.lowercased() + " "
                    status_report.text = "YOU GOT IT WRONG!"
                    print("doesn't have it!!!")
                } else {
                    //lost pop up
                    pop_up(str: "You lost!")                }
            }
        }
        //do nothing when
        //more than 1 character,repeating letter once inputed, if non letter,
    }
    
    func hasCharacter(word: String, char: String)-> Bool {
        var count = 0
        while (count < word.characters.count) {
            let index = word.index(word.startIndex, offsetBy:count)
            if (String(word[index]) == char.lowercased() || String(word[index]) == char.uppercased()) {
                correctlyGuessed.append(char.lowercased())
                return true
            }
            count += 1
        }
        return false
    }
    
    func replace(word: String, char: String) {
        print(correctlyGuessed)
        var newString = String()
        var count = 0
        while (count < word.characters.count) {
            let index = word.index(word.startIndex, offsetBy:count)
            if (String(word[index]) == char.lowercased() || String(word[index]) == char.uppercased()) {
                newString += char.lowercased() + " "
            } else if (String(word[index]) == " "){
                newString += "  "
            } else if (correctlyGuessed.contains(String(word[index]).lowercased())) {
                // if i guessed it before, I want to keep the value
                newString += String(word[index]).lowercased() + " "
            } else {
                newString += "_ "
            }
            count += 1
        }
        placeholder.text = newString
    }
    
    @IBAction func NewGameButton(_ sender: Any) {
        //reload the whole thing over again.
        self.viewDidLoad()
    }
    
    override func viewDidLoad() {
        word = String()
        correctlyGuessed = Array<String>()
        missedGuessed = Array<String>()
        num_missed = 0
        missedLetters.text! = ""
        super.viewDidLoad()
        print("GAME VIEW DID LOAD")
        ImageView.image = UIImage(named: "hangman1.gif")
        // Do any additional setup after loading the view.
        let hangmanPhrases = HangmanPhrases()
        let phrase = hangmanPhrases.getRandomPhrase()
        print(phrase!)
        word = phrase!
        //word = "hello"
        let length = word.characters.count
        print(length)
        //go through the string and place _ if space, do space
        var newtext = String()
        for i in word.characters {
            // i is each character
            if (i == " ") {
                newtext += "  "
                 print("space")
                //make placeholder of this index be space
            } else {
                //make the rest of the placeholder _
                newtext += "_ "
            }
        }
        print(newtext)
        placeholder.text = newtext
        //load initial image

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
