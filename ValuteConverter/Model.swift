//
//  Model.swift
//  ValuteConverter
//
//  Created by Кирилл Шишкин on 27.03.2021.
//

import UIKit

class Currency {
    var numCode: String?
    var charCode: String?
    
    var nominal: String?
    var nominalDouble: Double?
    
    var value: String?
    var valueDouble: Double?
    
    var name: String?
    
    var imageFlag: UIImage? {
        if let charCode = charCode {
            return UIImage(named: charCode)
        }
        return nil
    }
    
    class func rouble() -> Currency {
        let r = Currency()
        r.charCode = "RUR"
        r.name = "Российский рубль"
        r.nominal = "1"
        r.nominalDouble = 1
        r.value = "1"
        r.valueDouble = 1
        
        return r
    }
}

class Model: NSObject, XMLParserDelegate {
    
    static let shared = Model()
    
    var currentcies: [Currency] = []
    var currentDate: String = ""
    
    var fromCurrency: Currency = Currency.rouble()
    var toCurrency: Currency = Currency.rouble()
    
    func convert(amount: Double?) -> String {
        if amount == nil {
            return ""
        }
        let d = ((fromCurrency.nominalDouble! * fromCurrency.valueDouble!) / (toCurrency.nominalDouble! * toCurrency.valueDouble!)) * amount!
        
        return String(d)
    }
    
    var pathForXml: String {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/dataFile.xml"
        
        if FileManager.default.fileExists(atPath: path) {
            return path
        }

        print(path)
        
        return Bundle.main.path(forResource: "dataFile", ofType: "xml")!
    }
    
    var urlForXml: URL {
        return URL(fileURLWithPath: pathForXml)
    }
    
    
    func loadData(date: Date?) {
        var urlString = "https://www.cbr.ru/scripts/XML_daily.asp?date_req="
        
        if date != nil {
            let df = DateFormatter()
            df.dateFormat = "dd/MM/yyyy"
            urlString = urlString + df.string(from: date!)
        }
        
        let url = URL(string: urlString)
        
        let task = URLSession.shared.dataTask(with: url!) { (data, responce, error) in
            
            var errorGlobal: String?
            
            if error == nil {
                let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/dataFile.xml"
                let urlForSave = URL(fileURLWithPath: path)
                
                do {
                    try data?.write(to: urlForSave)
                    print("File is loaded")
                    self.parseXML()
                } catch {
                    print("Error when save data: \(error.localizedDescription)")
                    errorGlobal = error.localizedDescription
                }
            } else {
                print("Error when load data: " + error!.localizedDescription)
                errorGlobal = error?.localizedDescription
            }
            
            if let errorGlobal = errorGlobal {
                NotificationCenter.default.post(name: NSNotification.Name("ErrorWhenXMLloading"), object: self, userInfo: ["ErrorName":errorGlobal])
            }
            
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startLoadingXML"), object: self)
            
        task.resume()
    }
    
    func parseXML() {
        Model.shared.currentcies = [Currency.rouble()]
        
        let parser = XMLParser(contentsOf: urlForXml)
        parser?.delegate = self
        parser?.parse()
        
        print("Data updated")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataRefreshed"), object: self)
        
        for c in currentcies {
            if c.charCode == fromCurrency.charCode {
                fromCurrency = c
            }
            if c.charCode == toCurrency.charCode {
                toCurrency = c
            }
        }
    }
    
    var currentCurrentcy: Currency?
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == "ValCurs" {
            
            if let currentDateString = attributeDict["Date"] {
                currentDate = currentDateString
            }
        }
        
        if elementName == "Valute" {
            currentCurrentcy = Currency()
        }
    }
    
    var currentCharacters: String = ""
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentCharacters = string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "NumCode" {
            currentCurrentcy?.numCode = currentCharacters
        }
        if elementName == "CharCode" {
            currentCurrentcy?.charCode = currentCharacters
        }
        if elementName == "Nominal" {
            currentCurrentcy?.nominal = currentCharacters
            currentCurrentcy?.nominalDouble = Double(currentCharacters.replacingOccurrences(of: ",", with: "."))
        }
        if elementName == "Value" {
            currentCurrentcy?.value = currentCharacters
            currentCurrentcy?.valueDouble = Double(currentCharacters.replacingOccurrences(of: ",", with: "."))
        }
        if elementName == "Name" {
            currentCurrentcy?.name = currentCharacters
        }

        
        if elementName == "Valute" {
            Model.shared.currentcies.append(currentCurrentcy!)
        }
    }
}
