//
//  ViewController.swift
//  RandomRectanglesScene
//
//  Created by Mohammad Shahin User on 2/25/23.
//

import UIKit

class GameSceneVC: UIViewController {

    //====================================================================
    // MARK: Internal Properties
    private var rectangles = [UIButton]() // Keep track of all rectangles created
    //=======================================================================(Front end)
    
    // MARK: Config Properties
    // Min and max width and height for the rectangles
    private let rectSizeMin:CGFloat = 50.0
    private let rectSizeMax:CGFloat = 150.0
    //:::::::::::::::::::::::::::::::::
    private var randomAlpha = false // Random transparency on or off (if on the game will no longer be functional since the player won't find the box)
    //:::::::::::::::::::::::::::::::::
    private var fadeDuration: TimeInterval = 1    // How long for the rectangle to fade away it is suposed to be 0.8 but I fell 1 is a bit better to see the emoji
    //::::::::::::::::::::::::::::::::
    public var newRectInterval: TimeInterval = 1 // Rectangle creation interval
    private var newRectTimer: Timer?    // Rectangle creation, so the timer can be stopped
    private var newPairtTimer: Timer?
    //:::::::::::::::::::::::::::::::::
    private var pairs = 0
    private var matches = 0
    private var Touches = 0
    //::::::::::::::::::::::::::::::::::
    public var gameDuration: TimeInterval = 12.0   // Game duration
    private var gameTimer: Timer?   // Game timer
    public var game_stop: TimeInterval = 0
    private var game_stop_timer: Timer?
    //::::::::::::::::::::::::::::::::
    private var clockInterval: TimeInterval = 0.1 // Rectangle creation interval
    private var time_stop: Timer?
    //:::::::::::::::::::::::::::::::::::
    public var gameInProgress = false // the game in progress
    public var touched = false
    var firsttouch = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    //::::::::::::::::::::::::::::::::::::: (Game modes)
    public var Hard_mode = false
    public var Color_choice = false
    public var User: String?
    public var Game_score : Score?
    public var Size_small = false
    public var ChosenColor: UIColor?
    public var selected_color: UIColor?
    //::::::::::::::::::::::
    public var score : Int = 0
    public var High_score = 0
    
//---------------------------------(game Start)---------------------------------------
   
    
    
    @IBOutlet var DoubleTap: UITapGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad() // Do any additional setup after loading the view.
    }
    //-------------------------------------------
    
    @IBOutlet weak var High_Score: UILabel!
    //---------------------------------------------------
    @IBOutlet weak var StartBtn: UIButton!
    @IBAction func Starter(_ sender: Any) {
        restarter()
        //gameInfoLabel.textColor = Color_well2
    }
    //::::::
    @IBAction func DoubleTap(_ sender: Any) {
        pauseGame()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)      // Don't forget the call to super in these
    }
    
    // MARK: Touching the boxes
//--------------------------------------------------

    @objc private func handleTouch(sender: UIButton) {
      
        if (gameInProgress){
            Touches+=1
            labelPrint()
            print("\(#function) - \(sender)")
            sender.setTitle(Utility.getRandomEmoji(), for: .normal) //Add emoji text to the rectangle
            if ( touched == false){
                firsttouch = sender
                touched = true
            }else{
                //var firsttouch : UIButton

                if (checkIfsimilar (rec1: sender, rect2: firsttouch )){
                    //:::::::::::::::::::::::::::::::::::::::: (removing the rectangle)
                    removeRectangle(rectangle: sender)
                    sender.removeFromSuperview()
                    removeRectangle(rectangle: firsttouch)
                    firsttouch.removeFromSuperview()
                
                }
                sender.setTitle("", for: .normal)
                firsttouch.setTitle("", for: .normal)
                 touched = false
            }
        }
        }
    //------------------------------------------------------------
    @IBOutlet weak var restartBtn: UIButton!
    @IBAction func restart_Btn(_ sender: Any) {
        restarter()
    }
    //----------------------------------------
    @objc private func restarter() {
        
        touched = false
        UnpauseBtn.isHidden = true
        restartBtn.isHidden = true
        StartBtn.isHidden = true
        startGameRunning()
    }
    //----------------------------------------
    @IBOutlet weak var UnpauseBtn: UIButton!
    @IBAction func Unpause_Btn(_ sender: Any) {
        gameInProgress = true
        pauseGame()
    }
    @objc private func Unpause(sender: UIButton){
        touched = false
        pauseGame()
        //gameInProgress = true
        UnpauseBtn.isHidden = true
    }
    //-------------------------------------------------------------
    // MARK: Game labels

    @IBOutlet weak var gameInfoLabel: UILabel!
    private var gameInfo: String {
        return ""
        }
    //:::::
    var rectanglesCreated: Int = 0 { didSet { gameInfoLabel?.text = gameInfo }}
    var rectanglesTouched: Int = 0 { didSet { gameInfoLabel?.text = gameInfo }}
    
    //::::: (time remaining)
    private lazy var gameTimeRemaining = gameDuration { didSet { gameInfoLabel?.text = gameInfo }
    }
    //---------------------------------------------------
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
//==================================================================== (Back end)

extension GameSceneVC {
    
    //  MARK: Rectangle Methods
    private func createRectangle() {        // Create a rectangle
        
        //:::::::::::::::::::::::::::::::::::::::::::: (Get random values for size and location) ---> Utility
        var randSize: CGSize
        if (Size_small){
             randSize = Utility.getRandomSize_small(fromMin: rectSizeMin, throughMax: rectSizeMax)
        }else{
             randSize = Utility.getRandomSize(fromMin: rectSizeMin, throughMax: rectSizeMax)
        }
        let randLocation = Utility.getRandomLocation(size: randSize, screenSize: view.safeAreaLayoutGuide.layoutFrame.size)
        let randLocation2 = Utility.getRandomLocation(size: randSize, screenSize: view.safeAreaLayoutGuide.layoutFrame.size)
        let randomFrame = CGRect(origin: randLocation, size: randSize)
        let randomFrame2 = CGRect(origin: randLocation2, size: randSize)
        
        //::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        let rectangle = UIButton(frame: randomFrame)
        let rectangle_2 = UIButton(frame: randomFrame2)
        
        //:::::::::::::::::::::::::: (Do some button/rectangle setup)
        
        if (ChosenColor != nil) {
            if let c = ChosenColor {
                var split_colors = "\(c)".split(separator: " ")
                split_colors.popLast()
                split_colors = split_colors.reversed()
                split_colors.popLast()
                split_colors = split_colors.reversed()
                
                var rgbCGFloats: [CGFloat] = []
                
                for i in split_colors {
                    rgbCGFloats.append(CGFloat((i as NSString).floatValue))
                }
                
                rectangle.backgroundColor = UIColor(red: rgbCGFloats[0] + Utility.randomFloatZeroThroughtenth(), green: rgbCGFloats[1] + Utility.randomFloatZeroThroughtenth(), blue: rgbCGFloats[2] + Utility.randomFloatZeroThroughtenth(), alpha: 1.0)
                print(rgbCGFloats)
                
                selected_color = c
            }
        }
            
        else{
            rectangle.backgroundColor = Utility.getRandomColor(randomAlpha: randomAlpha)
        }
        rectangle.setTitle("", for: .normal)
        rectangle.setTitleColor(.black, for: .normal)
        rectangle.titleLabel?.font = .systemFont(ofSize: 50)
        rectangle.showsTouchWhenHighlighted = true
        //::::::::::::::::::::::::::::::
        rectangle_2.backgroundColor = rectangle.backgroundColor
        rectangle_2.setTitle("", for: .normal)
        rectangle_2.setTitleColor(.black, for: .normal)
        rectangle_2.titleLabel?.font = .systemFont(ofSize: 50)
        rectangle_2.showsTouchWhenHighlighted = true
        
        //::::::::::::::::::::::::::  (Make the rectangle visible)
        self.view.addSubview(rectangle)
        self.view.addSubview(rectangle_2)
        pairs += 2
        
        labelPrint()
                
        //::::::::::::::::::::::::: (Target to set up connect of button to the VC)
        rectangle.addTarget(self,action: #selector(self.handleTouch(sender:)), for: .touchUpInside)
        rectangle_2.addTarget(self,action: #selector(self.handleTouch(sender:)), for: .touchUpInside)
        
        //::::::::::::::::::::::::::::::::
        rectangles.append(rectangle)
        rectangles.append(rectangle_2)
        
        view.bringSubviewToFront(gameInfoLabel!) // Move label to the front
        
        // :::::::::::::::::::::::::::::::::::::::
    }
    //----------------------------------------------------------------------------------------  (Rectangle fade animation)
    func removeRectangle(rectangle: UIButton) {
        let pa = UIViewPropertyAnimator(duration: fadeDuration, curve: .linear, animations: nil)
        pa.addAnimations {
            rectangle.alpha = 0.0
        }
        pa.startAnimation()
    }
    //-----------------------------------------------------------------------------
    func checkIfsimilar (rec1: UIButton, rect2: UIButton) -> Bool{
        if ((rec1.backgroundColor == rect2.backgroundColor) && (rec1.frame.size.width == rect2.frame.size.width) && (rec1.frame.size.height == rect2.frame.size.height) && (rec1.frame != rect2.frame)){
            matches += 1
            print("match found")
            return true
        }
        if (Hard_mode){
            print("GameOver !!!")
            stopGameRunning()
        }
        print("Not a match")
        return false
    }
    //-----------------------------------------------------------------
    func labelPrint(){
        gameInfoLabel.text = String(format: "Time: %2.0f Created: %2d Touch: %2d",gameTimeRemaining, pairs, Touches)
    }
    //--------------------------------------------------------------
    // MARK: game Scores
    struct Score {
        var score: Float
        var username: String
    }
    //:::::::::::::::::::::::::::::::::
    func storeScores(_ scores: [Score]) {
        let scoreData = scores.map { ["score": $0.score, "username": $0.username] }
        UserDefaults.standard.set(scoreData, forKey: "highestScores")
    }
    //:::::::::::::::::::::::::::::::::::::::::::::::
    func retrieveScores() -> [Score] {
        if let scoreData = UserDefaults.standard.array(forKey: "highestScores") as? [[String: Any]] {
            let scores = scoreData.map { Score(score: $0["score"] as! Float, username: $0["username"] as! String) }
            return scores
        }
        return []
    }
    //:::::::::::::::::::::::::::::::::::::::::::::::
    func updateScores(_ newScore: Score) {
        var scores = retrieveScores()
        scores.append(newScore)
        scores.sort { $0.score > $1.score }
        if scores.count > 3 {
            scores.removeLast()
        }
        //print (newScore)
        storeScores(scores)
    }
}
//============================ GameSceneVC  =======================  (Timer to produce the rectangles)
//  MARK: Timer Functions
extension GameSceneVC {
    
    private func startGameRunning() {
        High_Score.isHidden = true
        gameTimeRemaining = gameDuration
        Touches = 0
        pairs = 0
        matches = 0
        removeSavedRectangles()
        //:::::::::::::::::::::::::::
        gameInfoLabel.textColor = .black
        gameInfoLabel.backgroundColor = .clear
        gameInProgress = true
        labelPrint()

        //::::::::::::::::::::::::::::::
        newRectTimer = Timer.scheduledTimer(withTimeInterval: newRectInterval, repeats: true){ [self] _ in [self]
            if (self.gameInProgress){
                self.createRectangle()    // start creating rectangles
            }
        }
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ [self] _ in [self]
            if (self.gameInProgress && gameTimeRemaining == 1){
                self.stopGameRunning()     // Start reducing time until the time reaches zero
                if let timer = gameTimer { timer.invalidate() }
            }else{
                if (gameTimeRemaining > 0){
                    gameTimeRemaining -= 1 // decrement time remaining
                    labelPrint()
                }
            }
        }
    }
    //---------------------------------------------------------
    func removeSavedRectangles() {
        for rectangle in rectangles {
            rectangle.removeFromSuperview() // Remove all rectangles from superview
            
        }
        rectangles.removeAll()      // Clear the rectangles array
    }
    //-------------------------------------------
    func stopGameRunning() {
        //print(matches)
        self.gameInfoLabel.text = String(format: "Matches: %2d / %2d",matches, pairs/2 )
        
        gameInProgress = false
        gameInfoLabel.textColor = .red
        gameInfoLabel.backgroundColor = .black
        //:::::::::::::::::::::::::::::::::::::
        restartBtn.isHidden = false
        view.bringSubviewToFront(restartBtn!)
        let current = Score(score: 100*(Float(matches)/Float(((pairs)/2))), username: User ?? "N/a")
        updateScores(current)
        var board = retrieveScores()
        if (board.count == 0){
            updateScores(Score(score: 0, username: "No one yet"))
        };if (board.count == 1){
            updateScores(Score(score: 0, username: "No one yet"))
        };if (board.count < 3){
            updateScores(Score(score: 0, username: "No one yet"))
        }
        board = retrieveScores()
        print(board[0])
        print(board[1])
        print(board[2])
        
        High_Score.text = String(format: "High Scores:\n "
                                 + "1) User: " + board[0].username + "  Score: %2.1f\n"
                                 + "2) User: " + board[1].username + "  Score: %2.1f\n"
                                 + "3) User: " + board[2].username + "  Score: %2.1f\n" , board[0].score, board[1].score, board[2].score)
        High_Score.isHidden = false
        view.bringSubviewToFront(High_Score!)
        //:::::::::::::::::::::::::::::::::::::::
        if let timer = newRectTimer { timer.invalidate() }     // Stop the timer
        //self.newRectTimer = nil     // Remove the reference to the timer object
       
    }
        //-------------------------------------------------------
        func pauseGame(){
            //gameInProgress = false
            UnpauseBtn.isHidden = false
            UnpauseBtn.addTarget(self,action: #selector(self.Unpause(sender:)), for: .touchUpInside)
            
            view.bringSubviewToFront(UnpauseBtn) // Move label to the front
            view.bringSubviewToFront(gameInfoLabel!)
            if (gameInProgress){
                gameInProgress = false
                if let timer = gameTimer{timer.invalidate()}
            }else{
                gameTimer = Timer.scheduledTimer( withTimeInterval: 1.0,  repeats : true){ [self] _ in [self]
                    if (gameInProgress && gameTimeRemaining == 1){
                        stopGameRunning()
                        gameTimer?.invalidate()
                    }else{
                        gameTimeRemaining -= 1
                        labelPrint()
                    }
                }
                gameInProgress = true
            }
        }
    }
