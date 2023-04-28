//
//  Utility.swift
//  RandomRectanglesScene
//
//  Created by Guest User on 2/25/23.
//

import UIKit

class Utility: NSObject {
    
    // MARK: Random Value Funcs
    static func randomFloatZeroThroughOne() -> CGFloat {
        let randomFloat = CGFloat.random(in: 0 ... 1.0)     // Get a random value
        return randomFloat
    }
    //:::::::::::::::::::::::::::::::::::::::::::::::
    static func randomFloatZeroThroughhalf() -> CGFloat {
        let randomFloat = CGFloat.random(in: 0 ... 0.5)     // Get a random value
        return randomFloat
    }
    //::::::::::::::::::::::::::::::::::::::::::::::
    static func randomFloatZeroThroughtenth() -> CGFloat {
        let randomFloat = CGFloat.random(in: -0.1 ... 0.1)     // Get a random value
        return randomFloat
    }
//---------------------------------------------------
    let ri = Int.random(in: 0 ... 99)
    let rd = Double.random(in: 0.0 ... 1.0)
    
//--------------------------------------------------- (Create a random CGSize)
    // MARK: Size
    static func getRandomSize(fromMin min: CGFloat, throughMax max: CGFloat) -> CGSize {
        let randWidth = randomFloatZeroThroughOne() * (max - min) + min
        let randHeight = randomFloatZeroThroughOne() * (max - min) + min
        let randSize = CGSize(width: randWidth, height: randHeight)
        return randSize
    }
    //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    static func getRandomSize_small(fromMin min: CGFloat, throughMax max: CGFloat) -> CGSize {
        let randWidth = randomFloatZeroThroughhalf() * (max - min) + min
        let randHeight = randomFloatZeroThroughhalf() * (max - min) + min
        let randSize = CGSize(width: randWidth, height: randHeight)
        return randSize
    }
//-------------------------------------------------------------
    // MARK: Location
    static func getRandomLocation(size rectSize: CGSize, screenSize: CGSize) -> CGPoint {
        
        //::::::::::::::::::::::::::::::::::(Get the screen dimensions)
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        //:::::::::::::::::::::::::::::::::::: (Create a random location/point)
        let rectX = randomFloatZeroThroughOne() * (screenWidth - rectSize.width)
        let rectY = randomFloatZeroThroughOne() * (screenHeight - rectSize.height)
        let location = CGPoint(x: rectX, y: rectY)
        
        return location
    }
//------------------------------------------------------------------
    // MARK: Color
    static func getRandomColor(randomAlpha: Bool) -> UIColor {
        //::::::::::::::::::::(Get random values for the RGB components)
        let randRed = randomFloatZeroThroughOne()
        let randGreen = randomFloatZeroThroughOne()
        let randBlue = randomFloatZeroThroughOne()
        
        //::::::::::::::::::::(Transparency can be none or random)
        var alpha:CGFloat = 1.0
        if randomAlpha {
            alpha = randomFloatZeroThroughOne()
        }
        
        return UIColor(red: randRed, green: randGreen, blue: randBlue, alpha: alpha)
    }
    //-----------------------------------------------------------------
    //MARK: Emojis
   static func getRandomEmoji() -> String {
        let range = 0x1F300...0x1F3F0
        let index = Int(arc4random_uniform(UInt32(range.count)))
        let ord = range.lowerBound + index
       //:::::::::::::::::::::::::
        guard let scalar = UnicodeScalar(ord) else { return "❓" }
        return String(scalar)
    }
    
}
//---------------------------------------------------------------


