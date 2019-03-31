//
//  ViewController.swift
//  Bitcoin2
//
//  Created by Mimi Tu on 3/29/19.
//  Copyright © 2019 Mimi Tu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    let currencyLabel = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    
    var selectedCurrencyLabel:String = ""
    
    var finalURL:String = ""
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //How many columns you want in the picker view
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //How many rows you want in the picker view
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //Since you've defined row's numbers are equal to the curreny.count, currency[row] will iterate through the array data
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        selectedCurrencyLabel = currencyLabel[row]
        getCurrencyData(url: finalURL)
    }
    
    
    @IBOutlet weak var priceLabel: UILabel! 
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }
    
    //MARK: Networking
    func getCurrencyData(url:String) {
        
        Alamofire.request(url, method: .get).responseJSON{
            response in
            if response.result.isSuccess{
                
                print("Success. Got the currency data.")
                
                let currencyJSON:JSON = JSON(response.result.value!)
                
                self.updateCurrencyDate(json: currencyJSON)
                
            }
            else{
                print("Error \(String(describing: response.result.error))")
                self.priceLabel.text = "Connection Issues."
            }
        }
    }
    
   //MARK:JSON Parsing
    func updateCurrencyDate(json:JSON){
        
        if let currencyResult = json["ask"].double {
            
            priceLabel.text = "\(selectedCurrencyLabel)\(currencyResult)"
            
        } else {
            
            priceLabel.text = "Currency not available."
        }

    

}
}
