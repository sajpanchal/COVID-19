//
//  CountryViewController.swift
//  COVID-19
//
//  Created by saj panchal on 2020-04-18.
//  Copyright © 2020 saj panchal. All rights reserved.
//

import UIKit

class CountryViewController: UIViewController {

    var displayName = String()
    var lat = Double()
    var long = Double()
    var countrywiseConfirmed = Int()
    var countrywiseDeaths = Int()
    var countrywiseRecovery = Int()
    var countryRecoveryRate = String()
    var countryDeathRate = String()
    var countryUnderTreatmentRate = String()
    let numberFormatter = NumberFormatter()
    @IBOutlet weak var countryNameLbl: UILabel!
    @IBOutlet weak var latitudeLbl: UILabel!
    @IBOutlet weak var longitudeLbl: UILabel!
    @IBOutlet weak var confirmedCasesLbl: UILabel!
    @IBOutlet weak var totalRecoveredLbl: UILabel!
    @IBOutlet weak var totalDeathsLbl: UILabel!
    @IBOutlet weak var recoveryRateLbl: UILabel!
    @IBOutlet weak var underTreatmentLbl: UILabel!
    @IBOutlet weak var deathRateLbl: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        numberFormatter.numberStyle = .decimal
        countryNameLbl.text = displayName
        latitudeLbl.text = String(format:"%.2f", lat)+"°"
        longitudeLbl.text = String(format:"%.2f",long)+"°"
        confirmedCasesLbl.text = numberFormatter.string(from: NSNumber (value:countrywiseConfirmed))
        totalDeathsLbl.text = numberFormatter.string(from: NSNumber (value:countrywiseDeaths))
        totalRecoveredLbl.text = numberFormatter.string(from: NSNumber (value:countrywiseRecovery))
        recoveryRateLbl.text = countryRecoveryRate
        underTreatmentLbl.text = countryUnderTreatmentRate
        deathRateLbl.text = countryDeathRate
    }
    

}
