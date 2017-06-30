//
//  ViewController.swift
//  OpenHouseCheckIn
//
//  Created by Laura Farvour on 6/27/17.
//  Copyright © 2017 Don Walsh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    var questions = [Question]()
    @IBOutlet weak var questionsTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionsTable.delegate = self
        questionsTable.dataSource = self
        
        loadSampleQuestions()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Table View Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "QuestionCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? QuestionCell  else {
            fatalError("I'm not even sure what this error does")
        }
        
        let question = questions[indexPath.row]
        
        cell.questionLabel.text = question.type + " - " + question.text
        
        return cell
    }
    
    private func loadSampleQuestions() {
        
        guard let question1 = Question(text: "Name", type: "Text") else {
            fatalError("Unable to instantiate question1")
        }
        
        guard let question2 = Question(text: "Email Address", type: "Email") else {
            fatalError("Unable to instantiate question2")
        }
        
        guard let question3 = Question(text: "Phone Number", type: "Phone") else {
            fatalError("Unable to instantiate question3")
        }
        
        guard let question4 = Question(text: "This is a very long and complicated question, no way it would fit on one line.", type: "MC") else {
            fatalError("Unable to instantiate question4")
        }
        
        questions += [question1, question2, question3, question4]
    }

        


}

