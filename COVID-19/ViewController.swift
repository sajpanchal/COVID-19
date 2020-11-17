//
//  ViewController.swift
//  COVID-19
//
//  Created by saj panchal on 2020-04-16.
//  Copyright © 2020 saj panchal. All rights reserved.
//

import UIKit
import Charts
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate {
    let lm = CLLocationManager()
    @IBOutlet weak var viewSegmentCtrl: UISegmentedControl!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var statsView: UIView!
    @IBOutlet weak var confirmCasesLbl: UILabel!
    @IBOutlet weak var totalDeathsLbl: UILabel!
    @IBOutlet weak var totalPopulationAffectedLbl: UILabel!
    @IBOutlet weak var nearestCountryBtnOutlet: UIButton!
    @IBOutlet weak var underTreatementLbl: UILabel!
    @IBOutlet weak var recoveryRateLbl: UILabel!
    @IBOutlet weak var deathRateLbl: UILabel!
    @IBOutlet weak var totalRecoveredLbl: UILabel!

    var displayName: String = ""
    var lat: Double = 0.0
    var long: Double = 0.0
    var countrywiseConfirmed: Int = 0
    var countrywiseDeaths: Int = 0
    var countrywiseRecovery: Int = 0
    var countrywiseUnderTreatment: Int = 0
    var countryRecoveryRate: String = ""
    var countryDeathRate: String = ""
    var countryUnderTreatmentRate: String = ""
    var myCoordinates: CLLocation?
    var countryCoordinates: CLLocation?
    var counter = 0
    var nearsetLat = 0.0
    var nearsetLong = 0.0
    var countryArrayId = 0
    var differenceInMeters: Double = 0
    var differenceInMetersPrev: Double = 0
    var nearestdifferenceInMeter: Double = 0
    var myLatitude : Double?
    var myLongitude : Double?
    var underTreatment: Int?
    let totalPopulation = 7794798739
    let numberFormatter = NumberFormatter()
    
    struct COVIDdata: Codable
    {
        let totalConfirmed: Int?
        let totalDeaths: Int?
        let totalRecovered: Int?
        let areas: [Country]
    }
    struct Country: Codable
    {
        let displayName : String?
        let lat: Double?
        let long: Double?
        let totalConfirmed: Int?
        let totalDeaths: Int?
        let totalRecovered: Int?
    
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        lm.delegate = self
        lm.requestWhenInUseAuthorization()
        lm.startUpdatingLocation()
        numberFormatter.numberStyle = .decimal
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("hello")
        if let location = locations.last
        {
            myLatitude = location.coordinate.latitude
            myLongitude = location.coordinate.longitude
            
            decodeJSONData()
        }
    }
    @IBAction func refreshBtn(_ sender: Any)
    {
        decodeJSONData()
    }
    @IBAction func viewSegmentCtrl(_ sender: Any)
    {
        if viewSegmentCtrl.selectedSegmentIndex == 0
        {
            graphView.isHidden = true
            statsView.isHidden = false
        }
        else if viewSegmentCtrl.selectedSegmentIndex == 1
        {
            graphView.isHidden = false
            statsView.isHidden = true
        }
    }
    @IBAction func nearestCountryBtn(_ sender: Any)
    {
        nearestCountryBtnOutlet.tag = 1
    }
    func decodeJSONData() -> Void
    {
        if (myLatitude != nil && myLongitude != nil)
                  {
           
            let urlString = "https://www.bing.com/covid/data"
                      /* step 2 create url session */
                      let urlSession = URLSession(configuration: .default)
                      let url = URL(string: urlString)
                      if let url = url
                      {
                          /* step 3 give URL session a data task */
                          let dataTask = urlSession.dataTask(with: url)
                          {
                              (data, respose, error) in
                              if let data = data
                              {
                                  let jsonDecoder = JSONDecoder()
                                  
                                  do {
                                      let readableData = try jsonDecoder.decode(COVIDdata.self, from: data)
                                      self.displayCOVIDData(readableData)
                                      self.fileterNearestCountry(readableData)
                                  }
                                  catch
                                  {
                                      if let data = self.getData(filename: "covid_data")
                                      {
                                            do
                                            {
                                                let jsonDocoder = JSONDecoder()
                                                let readableData = try jsonDocoder.decode(COVIDdata.self, from: data)
                                                self.displayCOVIDData(readableData)
                                                self.fileterNearestCountry(readableData)
                                            }
                                        catch
                                        {
                                            print("Cannot decode your data1")
                                            print(error)
                                        }
                                      }
                                  }
                              }
                          }
                          /* step 4 start data task */
                          dataTask.resume()
                      }
                  }
    }
    func getData(filename fileName: String) -> Data?
    {
            if let url = Bundle.main.url(forResource: fileName, withExtension: "json")
            {
                do
                {
                    let data = try Data(contentsOf: url)
                    return data
                } catch
                {
                    print("I can not read your file \(fileName).json")
                    print(error)
                }
            }
            print("I can not read the file \(fileName).json")
            return nil
        }
    
    func displayCOVIDData(_ readableData: COVIDdata) -> Void
    {
        DispatchQueue.main.async
            {
                self.totalDeathsLbl.text = self.numberFormatter.string(from: NSNumber(value: readableData.totalDeaths!))
                self.confirmCasesLbl.text = self.numberFormatter.string(from: NSNumber(value: readableData.totalConfirmed!))
                self.totalRecoveredLbl.text = self.numberFormatter.string(from: NSNumber(value:readableData.totalRecovered!))
                self.underTreatment = readableData.totalConfirmed! - (readableData.totalRecovered! + readableData.totalDeaths!)
                self.totalPopulationAffectedLbl.text = self.percentageFunction(receivedData: readableData.totalConfirmed!, ComparisonData: self.totalPopulation)
                self.underTreatementLbl.text = self.percentageFunction(receivedData: self.underTreatment!, ComparisonData: readableData.totalConfirmed!)
                self.recoveryRateLbl.text = self.percentageFunction(receivedData: readableData.totalRecovered!, ComparisonData: readableData.totalConfirmed!)
                self.deathRateLbl.text = self.percentageFunction(receivedData: readableData.totalDeaths!, ComparisonData: readableData.totalConfirmed!)
                self.updateGraph(readableData.totalRecovered!, readableData.totalDeaths!, readableData.totalConfirmed!)
            }
    }
    func fileterNearestCountry (_ readableData: COVIDdata)
    {
        myCoordinates = CLLocation(latitude: myLatitude!, longitude: myLongitude!)
        while (counter < readableData.areas.count)
               {
                countryCoordinates = CLLocation(latitude: readableData.areas[counter].lat!, longitude: readableData.areas[counter].long!)
                differenceInMeters = (myCoordinates!.distance(from: countryCoordinates!))
                if(differenceInMeters <= nearestdifferenceInMeter || counter == 0)
                {
                    nearsetLat = readableData.areas[counter].lat!
                    nearsetLong = readableData.areas[counter].long!
                    nearestdifferenceInMeter = differenceInMeters
                    countryArrayId = counter
                }
                differenceInMetersPrev = differenceInMeters
                counter += 1
               }
        displayName  = readableData.areas[countryArrayId].displayName!
        lat = readableData.areas[countryArrayId].lat!
        long = readableData.areas[countryArrayId].long!
        countrywiseConfirmed = readableData.areas[countryArrayId].totalConfirmed!
        countrywiseDeaths = readableData.areas[countryArrayId].totalDeaths!
        countrywiseRecovery = readableData.areas[countryArrayId].totalRecovered!
        countryUnderTreatmentRate = self.percentageFunction(receivedData: (countrywiseConfirmed - (countrywiseRecovery + countrywiseDeaths)), ComparisonData: countrywiseConfirmed)
        countryRecoveryRate = self.percentageFunction(receivedData: countrywiseRecovery, ComparisonData: countrywiseConfirmed)
        countryDeathRate = self.percentageFunction(receivedData: countrywiseDeaths, ComparisonData: countrywiseConfirmed)
        counter = 0
    }
    
    func percentageFunction(receivedData: Int, ComparisonData: Int) -> String
      {
          let percentage = Double(100 * receivedData)/Double(ComparisonData)
          let str = String(format:"%.2f",percentage)
          return str + "%"
      }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(nearestCountryBtnOutlet.tag == 1)
        {
        let destination = segue.destination as! CountryViewController
        destination.displayName = displayName
        destination.lat = lat
        destination.long = long
        destination.countrywiseConfirmed = countrywiseConfirmed
        destination.countrywiseRecovery = countrywiseRecovery
        destination.countrywiseDeaths = countrywiseDeaths
        destination.countryDeathRate = countryDeathRate
        destination.countryRecoveryRate = countryRecoveryRate
        destination.countryUnderTreatmentRate = countryUnderTreatmentRate
        nearestCountryBtnOutlet.tag = 0
        }
    }
        
    func updateGraph(_ totalRecovered: Int, _ totalDeaths: Int, _ totalConfirmed: Int) -> Void
    {
        let recoveryRate = percentageFunction(receivedData: totalRecovered, ComparisonData: totalConfirmed)
        let deathRate = percentageFunction(receivedData: totalDeaths, ComparisonData: totalConfirmed)
        let sickPeopleRate = percentageFunction(receivedData: underTreatment!, ComparisonData: totalConfirmed)
        let recoveryData = PieChartDataEntry(value: Double(totalRecovered), label:"Recovery "+recoveryRate)
        let deathData = PieChartDataEntry(value: Double(totalDeaths), label:"Deaths " + deathRate)
        let underCareData = PieChartDataEntry(value: Double(underTreatment!), label:"Under medical care " + sickPeopleRate)
        let covidData = PieChartDataSet(entries: [recoveryData,deathData,underCareData], label: "")
        pieChart.chartDescription?.text = "Total affected\n" + numberFormatter.string(from: NSNumber(value:totalConfirmed))!
        pieChart.data = PieChartData(dataSet: covidData)
        covidData.colors = ChartColorTemplates.material()
        formatGraph()
        pieChart.notifyDataSetChanged()
    }
    func formatGraph() -> Void
    {
        pieChart.backgroundColor = UIColor.black
        pieChart.holeColor = UIColor.clear
        pieChart.chartDescription?.textColor = UIColor.white
        pieChart.legend.textColor = UIColor.white
        pieChart.legend.font = UIFont(name: "Futura", size: 14)!
        pieChart.chartDescription?.font = UIFont(name: "Futura", size: 16)!
        pieChart.chartDescription?.xOffset = pieChart.frame.width - 180
        pieChart.chartDescription?.yOffset = pieChart.frame.height * (0.385)
        pieChart.chartDescription?.textAlign = NSTextAlignment.center
    }
}

