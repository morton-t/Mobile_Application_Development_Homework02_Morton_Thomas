//
//  ViewController.swift
//  Ind02_Morton_Thomas
//
//  Created by user on 2/26/23.
//

import UIKit


//Maintains game state
var answerShowing = false
var gameIsWon = false

//Globals from tapGestureHandler
var firstTappedImg: UIImageView?
var secondTappedImg: UIImageView?
var firstImageCoords = (first: -1, second: -1)
var secondImageCoords = (first: -1, second: -1)
var blankImageCoords = (first: 3, second: 0)

//Globals from shuffle function
var blankTileIdx = 3
var randChoiceIdx = 3

class ViewController: UIViewController {
    @IBOutlet var gameTiles: [UIView]!
    @IBOutlet var startingState: [UIView]!
    
    @IBOutlet weak var winnerImage: UIImageView!
    @IBOutlet weak var imageSolution: UIImageView!
    
    var playerTiles = GameTiles().generateArray()
    var solutionArray = GameTiles().generateArray()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        //Keep the gameIsWon image and solution from displaying after view updates
        if gameIsWon == false {
            self.winnerImage.frame.origin.y = -(UIScreen.main.bounds.height)
        }
        
        if answerShowing == false {
            self.imageSolution.frame.origin.y = -(UIScreen.main.bounds.height)
        }
      
    }
    
    func swapTiles() {
        //I know this function looks like bad, but Swift does not like math with tuples for some reason
        //In hindsight I should have used CGPoints
        
        //Variables for math with tuples
        let first_x = firstImageCoords.first
        let first_y = firstImageCoords.second
        let second_x = secondImageCoords.first
        let second_y = secondImageCoords.second
        let blank_x = blankImageCoords.first
        let blank_y = blankImageCoords.second
        
        //Verify whether the tiles are bordering
        if firstImageCoords == blankImageCoords && (abs(second_x - blank_x) == 1 || abs(second_y - blank_y) == 1) && ((abs(second_x - blank_x) + abs(second_y - blank_y)) < 2) {
            
            //If valid, set the blank tile's coordinates to its new location
            blankImageCoords = secondImageCoords
            
            //Then swap the images
            swap(&firstTappedImg!.image, &secondTappedImg!.image)
            
            //And update the playerTiles array
            let temp = playerTiles[first_y][first_x]
            playerTiles[first_y][first_x] = playerTiles[second_y][second_x]
            playerTiles[second_y][second_x] = temp
        }
        else if secondImageCoords == blankImageCoords && (abs(first_x - blank_x) == 1 || abs(first_y - blank_y) == 1) && ((abs(first_x - blank_x) + abs(first_y - blank_y)) < 2){
            
            //If valid, set the blank tile's coordinates to its new location
            blankImageCoords = firstImageCoords
            
            //Then swap the images
            swap(&firstTappedImg!.image, &secondTappedImg!.image)
            
            //And update the playerTiles array
            let temp = playerTiles[first_y][first_x]
            playerTiles[first_y][first_x] = playerTiles[second_y][second_x]
            playerTiles[second_y][second_x] = temp
        }
        //if neither tile is the blank tile exit the function without swapping
        //Clear the stored properties for the tiles
        firstImageCoords = (first: -1, second: -1)
        secondImageCoords = (first: -1, second: -1)
        firstTappedImg = nil
        secondTappedImg = nil
    }
    
    func displayWin() {
        UIView.animate(withDuration: 0.0, animations:  {
            gameIsWon = true
            
            //Display "You Win!!"
            self.winnerImage.frame.origin.y = 0.0
            
            //Cleanup game state variables
            firstImageCoords = (first: -1, second: -1)
            secondImageCoords = (first: -1, second: -1)
            blankImageCoords = (first: 3, second: 0)
            firstTappedImg = nil
            secondTappedImg = nil
            blankTileIdx = 3
            randChoiceIdx = 3
            self.gameTiles = self.startingState
        })
    }
    
//MARK: Button interfaces
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        //On click, move the solution to its origin on screen
        if answerShowing == false {
            UIView.animate(withDuration: 1.0, animations:  {
                self.imageSolution.frame.origin.y = 0.0
                answerShowing = true
                sender.setTitle("Hide Answer", for: .normal)
            })
        }
        //on hide answer, move the solution off-screen
        else {
            UIView.animate(withDuration: 1.0, animations: {
                self.imageSolution.frame.origin.y = -(UIScreen.main.bounds.height)
                answerShowing = false
                sender.setTitle("Show Answer", for: .normal)
            })
        }
    }

    @IBAction func shuffleButtonTapped(_ sender: UIButton) {
        var shuffleCount: Int = 50
        
        //Ensure no tile is selected before shuffle
        firstTappedImg = nil
        secondTappedImg = nil
        
        var blankTile: UIImageView?
        
        //Game is no longer won since we've shuffled. Hide the winning message
        if gameIsWon {
            self.winnerImage.frame.origin.y = -(UIScreen.main.bounds.height)
            gameIsWon = false
        }
        
        while shuffleCount > 0 {
            blankTile = (gameTiles[0].subviews[blankTileIdx] as? UIImageView)!
            
            let revertChoice = randChoiceIdx
            var randNum: Int?
            
            //Rules for 1D array to 2D array 4x5
            //If the index - 3 mod4 == 0, the tile is aligned to the right edge
            if (blankTileIdx - 3) % 4 == 0 {
                randNum = [-4, -1, 4].randomElement()!
            }
            //If the index mod4 == 0, the tile is aligned to the left edge
            else if blankTileIdx % 4 == 0 {
                randNum = [-4, 1, 4].randomElement()!
            }
            //Otherwise the alignment doesn't matter and move will be validated in next statement
            else {
                randNum = [-4, -1, 1, 4].randomElement()!
            }
            
            //If the selected new index is outside the bounds of the array, undo the random choice
            if randChoiceIdx + randNum! > gameTiles[0].subviews.count - 3 || randChoiceIdx + randNum! < 0 {
                randChoiceIdx = revertChoice
            }
            //Otherwise proceed to swap tiles
            else {
                randChoiceIdx += randNum!
                
                let randTile: UIImageView = (gameTiles[0].subviews[randChoiceIdx] as? UIImageView)!

                //Iterate through the playerTiles to match image data for the random tile
                for i in 0...playerTiles.count - 1 {
                    var exit = false
                    
                    for j in 0...playerTiles[i].count - 1 {
                        if randTile.image!.pngData() == playerTiles[i][j] {
                            
                            //Perform the swap on locating the image data
                            let temp: Data = playerTiles[i][j]!
                            playerTiles[i][j] = playerTiles[blankImageCoords.second][blankImageCoords.first]
                            playerTiles[blankImageCoords.second][blankImageCoords.first] = temp
                            
                            //If found, we can exit both for loops (I know, this is really poor implementation!)
                            exit = true
                            break
                        }
                        if exit { break }
                    }
                }
                
                //Update coordinate information for the blank tile according the random choice
                switch randNum! {
                case -4:
                    blankImageCoords.second -= 1
                case -1:
                    blankImageCoords.first -= 1
                case 1:
                    blankImageCoords.first += 1
                case 4:
                    blankImageCoords.second += 1
                default:
                    print("Error assigning coordinates in shuffle function!!")
                }
                
                //then update images on-screen
                swap(&blankTile!.image, &randTile.image)
                blankTileIdx = randChoiceIdx
                gameTiles[0].exchangeSubview(at: randChoiceIdx, withSubviewAt: blankTileIdx)
                
                shuffleCount -= 1
            }
        }
    }
    
    
    //MARK: ImageView Gesture Recognizer
    @IBAction func tapHandler(_ sender: UITapGestureRecognizer) {
        //If we have no data for the first image, identify the image
        if firstTappedImg == nil {
            firstTappedImg = sender.view as? UIImageView
            
            //Then retrieve the coordinates for the image based on its location in playerTiles
            for i in 0...playerTiles.count - 1 {
                for j in 0...playerTiles[i].count - 1 {
                    
                    if firstTappedImg!.image?.pngData() == playerTiles[i][j] {
                        firstImageCoords.first = j
                        firstImageCoords.second = i
                        
                        return
                    }
                }
            }
        }
        //If we have no data for the second image, identify the image
        else if secondTappedImg == nil {
            secondTappedImg = sender.view as? UIImageView
            
            //Then retrieve the coordinates for the image based on its location in playerTiles
            var exit = false
            for i in 0...playerTiles.count - 1 {
                for j in 0...playerTiles[i].count - 1 {

                    if secondTappedImg!.image?.pngData() == playerTiles[i][j] {
                        secondImageCoords.first = j
                        secondImageCoords.second = i
                        
                        //Once found, we can exit the loops
                        exit = true
                        break
                    }
                }
                if exit { break }
            }
        }
        
        //Perform the swap if both images found and valid
        if firstTappedImg != nil && secondTappedImg != nil {
            swapTiles()

            //Check for winning arrangement
            if playerTiles == solutionArray {
                displayWin()
            }
        }
    }
}

