//
//  ConfigViewController.swift
//  Matchem_Tab_Shahin
//
//  Created by Branson Boggia on 3/23/23.
//

import UIKit

class ConfigViewController: UIViewController, UITableViewDataSource {
    private var gameVC: GameSceneVC?
    // MARK: Configuration
    
    @IBAction func User_name(_ sender: UITextField) {
        gameVC?.User = sender.text
    }
    //::::::::::::::::::::::::::::::::::::::::::::
    @IBAction func Rectangle_size(_ sender: UISegmentedControl) {
        gameVC?.Size_small = ((gameVC?.Size_small) != nil)
    }
    //::::::::::::::::::::::::::::::::::::::::::::::
    @IBOutlet weak var Hardcore: UISwitch!
    @IBAction func Hard_switch(_ sender: Any) {
        gameVC?.Hard_mode = ((gameVC?.Hard_mode) != nil)
    }
    //:::::::::::::::::::::::::::::::::::::::::::::::::
    @IBOutlet weak var Duration_label: UILabel!
    @IBOutlet weak var Stepper_tab: UIStepper!
    @IBAction func Stepper_touch(_ sender: UIStepper) {
        gameVC?.gameDuration = (sender.value)
        Duration_label.text = gameVC?.gameDuration.description
    }
    //::::::::::::::::::::::::::::::::::::::::
    
    @IBOutlet weak var Speed_label: UILabel!
    @IBAction func Speed_Scale(_ sender: UISlider) {
        gameVC?.newRectInterval = TimeInterval((sender.value))
        Speed_label.text = gameVC?.newRectInterval.description
    }
    //::::::::::::::::::::::::::::::::::::::
    @IBOutlet weak var Color_spectrum: UIColorWell!
    
    @IBOutlet weak var ColorPicker: UIColorWell!
    
    @objc func colorWellDidChange(_ sender: UIColorWell) {
        if (sender.selectedColor != nil) {
            self.gameVC?.ChosenColor = sender.selectedColor
           //print("Selected color: \(sender.selectedColor)")
        }
    }
    //-------------------------------------------------------
    
    @IBOutlet weak var GameDuration_txt: UILabel!
    @IBOutlet weak var GameSpeed_txt: UILabel!
    @IBOutlet weak var HarCode_txt: UILabel!
    @IBOutlet weak var Night_txt: UILabel!
    @IBOutlet weak var Color_txt: UILabel!
    @IBOutlet weak var Size_txt: UILabel!
    @IBOutlet weak var Title_txt: UILabel!
    @IBOutlet weak var User_txt: UILabel!
    @IBOutlet weak var High_txt: UILabel!
    //:::::::::::::::::::::::::::::::::::::::::
    
    @IBOutlet weak var Light_mode: UIImageView!
    @objc func LightMode(){
        Light_mode.isHidden = true
        Night_mode.isHidden = false
        Speed_label.textColor = .black
        Duration_label.textColor = .black
        GameDuration_txt .textColor = .black
        GameSpeed_txt.textColor = .black
        HarCode_txt.textColor = .black
        Night_txt.textColor = .black
        Color_txt.textColor = .black
        Size_txt.textColor = .black
        Title_txt.textColor = .black
        User_txt.textColor = .black
        gameVC?.gameInfoLabel.textColor = .black
        self.view.backgroundColor = .white
        gameVC?.view.backgroundColor = .white
        High_txt.textColor = .black
        //gameVC?.High_Score.textColor = .white
        //gameVC?.High_score.background = .black
    }
    //::::::::::::::::::::::::::::::::::::::
    @IBOutlet weak var Night_mode: UIImageView!
    @objc func NightMode(){
        Light_mode.isHidden = false
        Night_mode.isHidden = true
        Speed_label.textColor = .white
        Duration_label.textColor = .white
        GameDuration_txt .textColor = .white
        GameSpeed_txt.textColor = .white
        HarCode_txt.textColor = .white
        Night_txt.textColor = .white
        Color_txt.textColor = .white
        Size_txt.textColor = .white
        Title_txt.textColor = .white
        User_txt.textColor = .white
        gameVC?.gameInfoLabel.textColor = .white
        self.view.backgroundColor = .black
        gameVC?.view.backgroundColor = .black
        High_txt.textColor = .white
        //gameVC?.High_Score.textColor = .black
        //gameVC?.High_score.background = .white
    }
    //------------------------------------------------
    @IBOutlet weak var tableView: UITableView!
    //:::::::::::::::::::::::::::::::::::::::::::
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var board = gameVC?.retrieveScores()
        if (board?.count == 0){
            gameVC?.updateScores(GameSceneVC.Score(score: 0, username: "No one yet"))
        };if (board?.count == 1){
            gameVC?.updateScores(GameSceneVC.Score(score: 0, username: "No one yet"))
        };if (board?.count ?? 0 < 3){
            gameVC?.updateScores(GameSceneVC.Score(score: 0, username: "No one yet"))
        }
        board = gameVC?.retrieveScores()
        return gameVC?.retrieveScores().count ?? 3
    }
    
    //:::::::::::::::::::::::::::::::::::::::::::
    func tableView(_ tableView: UITableView, numberOfRowsInsection section: Int) -> GameSceneVC.Score{
       
        return gameVC?.Game_score ?? GameSceneVC.Score(score: 0, username:"N/a")
    }
    //::::::::::::::::::::::::::::::::::::::::
    @objc(tableView:cellForRowAtIndexPath:)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let board = gameVC?.retrieveScores()
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        cell.textLabel?.text = ((String (format : "UserName: " + (board?[indexPath.row].username ?? "No user Yet") + " Score: %0.2f", board?[indexPath.row].score ?? 0) as CVarArg) as! String)
        
           return cell
       }
    //:::::::::::::::::::::::::::::::::::::::::::::::::::::
    @IBAction func Clear_score(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "highestScores")
    }
    //-------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        if let vc = self.tabBarController?.viewControllers?[0] as? GameSceneVC {
            self.gameVC = vc
        }
        self.ColorPicker.addTarget(self, action: #selector(colorWellDidChange(_:)), for: .valueChanged)
        //:::::::::::::::::::::::::::::::::::::::::::::
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(gesture:)))
        Night_mode.addGestureRecognizer(tapGesture)
        Night_mode.isUserInteractionEnabled = true
        //:::::::::::::::::::::::::::::::::::::::
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped2(gesture:)))
        
        Light_mode.addGestureRecognizer(tapGesture2)
        Light_mode.isUserInteractionEnabled = true
        //:::::::::::::::::::::::::::::::::::::::
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
    }
           override func viewDidAppear(_ animated: Bool) {
               tableView.reloadData()
           }
    //-----------------------------------------------------
    @objc func imageTapped (gesture: UIGestureRecognizer){
        if (gesture.view as? UIImageView) != nil{
            NightMode()
        }
    }
    //:::::::::::::::::::::::::::::::::::::::::::
    @objc func imageTapped2 (gesture: UIGestureRecognizer){
        if (gesture.view as? UIImageView) != nil{
            LightMode()
        }
    }
}
//===============================================================
