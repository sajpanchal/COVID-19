//
//  SelfAssessmentViewController.swift
//  COVID-19
//
//  Created by saj panchal on 2020-04-18.
//  Copyright © 2020 saj panchal. All rights reserved.
//

import UIKit

class SelfAssessmentViewController: UIViewController {
   
    struct  Counter
    {
        var fever = 0
        var tiredness = 0
        var cough = 0
        var aches = 0
        var nasal = 0
        var runnyNose = 0
        var throat = 0
        var diarrhoea = 0
    }
    @IBOutlet weak var feverSegmentOutlet: UISegmentedControl!
    @IBOutlet weak var tirednessSegmentOutlet: UISegmentedControl!
    @IBOutlet weak var coughSegmentOutlet: UISegmentedControl!
    @IBOutlet weak var achesSegmentOutlet: UISegmentedControl!
    @IBOutlet weak var nasalSegmentOutlet: UISegmentedControl!
    @IBOutlet weak var runnyNoseSegmentOutlet: UISegmentedControl!
    @IBOutlet weak var throatSegmentOutlet: UISegmentedControl!
    @IBOutlet weak var diarrhoeaSegmentOutlet: UISegmentedControl!
    var severityLevel = 0
    var counter = Counter()
    var alertMessage = ""
    var alertTitle = ""
    @IBAction func feverSegmentBtn(_ sender: Any)
    
    {
        if(feverSegmentOutlet.selectedSegmentIndex == 0)
        {
            counter.fever = 3
        }
        else if(feverSegmentOutlet.selectedSegmentIndex == 1)
        {
            counter.fever = 0
        }
        
    }
    @IBAction func tirednessSegmentBtn(_ sender: Any)
    {
        if(tirednessSegmentOutlet.selectedSegmentIndex == 0)
        {
            counter.tiredness = 3
        }
        else if(tirednessSegmentOutlet.selectedSegmentIndex == 1)
        {
            counter.tiredness = 0
        }
    }
    @IBAction func coughSegmentBtn(_ sender: Any)
    {
        if(coughSegmentOutlet.selectedSegmentIndex == 0)
        {
             counter.cough = 3
        }
        else if(coughSegmentOutlet.selectedSegmentIndex == 1)
        {
            counter.cough = 0
        }
    }
    @IBAction func achesSegmentBtn(_ sender: Any)
    {
        if(achesSegmentOutlet.selectedSegmentIndex == 0)
        {
            counter.aches = 2
        }
        else if(achesSegmentOutlet.selectedSegmentIndex == 1)
        {
            counter.aches = 0
        }
    }
    @IBAction func nasalSegmentBtn(_ sender: Any)
    {
        if(nasalSegmentOutlet.selectedSegmentIndex == 0)
        {
           counter.nasal = 2
        }
        else if(nasalSegmentOutlet.selectedSegmentIndex == 1)
        {
             counter.nasal = 0
        }
    }
    @IBAction func runnyNoseSegmentBtn(_ sender: Any)
    {
        if(runnyNoseSegmentOutlet.selectedSegmentIndex == 0)
        {
             counter.runnyNose = 1
        }
        else if(runnyNoseSegmentOutlet.selectedSegmentIndex == 1)
        {
             counter.runnyNose = 0
        }
    }
    @IBAction func throatSegmentBtn(_ sender: Any)
    {
        if(throatSegmentOutlet.selectedSegmentIndex == 0)
        {
             counter.throat = 1
        }
        else if(throatSegmentOutlet.selectedSegmentIndex == 1)
        {
            counter.throat = 0
        }
    }
    @IBAction func diarrhoreaSegmentBtn(_ sender: Any)
    {
        if(diarrhoeaSegmentOutlet.selectedSegmentIndex == 0)
        {
            counter.diarrhoea = 1
        }
        else if(diarrhoeaSegmentOutlet.selectedSegmentIndex == 1)
        {
            counter.diarrhoea = 0
        }
    }
    @IBAction func checkResultsBtn(_ sender: Any)
    {
        severityLevel = counter.aches + counter.fever + counter.cough + counter.diarrhoea + counter.throat + counter.tiredness + counter.runnyNose + counter.nasal
         alertTitle = "Assessment Report"
        switch severityLevel {
        case 9...16:
            alertMessage = "You are having a highly likely symptoms of exposure to COVID-19. \nPlease contact your nearby medical facility immidiately for medical check up/test."
        case 3...8:
            alertMessage = "You are having a possible symptoms of COVID-19 but it could be some other illness. \nHowever, it is recommanded to take precautions and contact your nearby medical facility to get advice or do medical check-up."
        case 1...2:
            alertMessage = "It seems like you are not exposed to COVID-19 and your illness is less likely related to it. \nBut to deal with the illness you should get a medical advise from the doctor"
        case 0:
            alertMessage = "Congratulations! you are tested negative for COVID-19. \nHowever, Please take care of yourself to continue avoiding yourself from the COVID-19 virus.\nStay home as much as you can. \nStay away from large gatherings. \nFrequently wash your hands."
        default:
            alertMessage = "Error! Something went wrong. Please try again."
        }
        let alertController = UIAlertController(title:alertTitle, message: alertMessage, preferredStyle: .alert)
        let OKButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKButton)
        present(alertController, animated: true)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    

   
}
