import UIKit

struct Bitcoin: Decodable {
	let ask: Double
	let bid: Double
	let volume: Double
	let averages: [String: Double]
	
// We don't need this contructor anymore with Swift 4
//
//	init(json: [String: Any]) {
//		ask = json["ask"] as? Double ?? 0
//		bid = json["bid"] as? Double ?? 0
//		volume = json["volume"] as? Double ?? 0
//	}
	
}

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let jsonURLString = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
	var finalURL: URL?

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
		currencyPicker.dataSource = self
		currencyPicker.delegate = self
       
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return currencyArray.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return currencyArray[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		
		guard let finalURL = URL(string: String(jsonURLString + currencyArray[row])) else {return}
		
		//MARK: - Vanilla Networking
		
		URLSession.shared.dataTask(with: finalURL) { (data, response, err) in
			// check for error
			// check for response status 200 OK
			
			guard let data = data else {return}
			
			//let dataAsString = String(data: data, encoding: .utf8)
			
			do {
				//MARK: - Vanilla JSON Parsing
				let BTC = try JSONDecoder().decode(Bitcoin.self, from: data)
				
				DispatchQueue.main.async {
					self.bitcoinPriceLabel.text = String(BTC.ask)
				}
				
				// guard let dailyAverage = BTC.averages["day"] else {return}
				// print(dailyAverage)
				
			}catch let jsonError{
				print("Error serializing json:", jsonError)
			}
			
		}.resume()
		
	}
}

