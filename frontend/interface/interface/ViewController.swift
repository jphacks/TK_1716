//
//  ViewController.swift
//  interface
//
//  Created by Kento Ohtani on 2017/10/22.
//  Copyright © 2017年 Kento Ohtani. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation


@IBDesignable class CustomLabel: UILabel {
    
    //角丸の半径（０で四角形）
    @IBInspectable var cornerRadius: CGFloat = 0.0
    
    //枠
    @IBInspectable var borderColor: UIColor = UIColor.clear
    @IBInspectable var borderWidth: CGFloat = 0.0
    
    override func draw(_ rect: CGRect) {
        //角丸
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = (cornerRadius > 0)
        
        //枠線
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        
        super.draw(rect)
        
    }
}







class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, CLLocationManagerDelegate {
    
    
    //日付関連
    @IBOutlet var datelabel : UILabel!
    var datelabeltext : String = ""
    @IBOutlet var yearlabel : UILabel!
    var yearlabeltext : String = ""
    
    //bluetooth関連
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    var temperatureCharacteristic: CBCharacteristic?
    var humidityCharacteristic: CBCharacteristic?
    var smellCharacteristic: CBCharacteristic?
    var cryCharacteristic: CBCharacteristic?
    
    //温度
    var temperature : Int!
    var temperatureText : String!
    var temperatureFloat : Float = 0
    //湿度
    var humidity : Int!
    var humidityText : String!
    var humidityFloat : Float = 0
    //臭気
    var smell : Int!
    var smellText : String!
    //泣き声
    var cry : Int!
    var cryText : String!
    //不快指数
    var DI : Float = 0
    var ditext : String = ""
    
    
    //map関連
    var urlStringOmutsu : String = "http://"
    var urlStringMilk : String = "http://"
    var serverName : String = "ec2-18-221-203-131.us-east-2.compute.amazonaws.com"
    //緯度
    var latitudeText : String = ""
    var latArray : [String] = []
    var latArraylast : String = ""
    //経度
    var lngitudeText : String = ""
    var lngArray : [String] = []
    var lngArraylast : String = ""
    //GPS
    var locationManager: CLLocationManager!
    
    //bluetoothTimer temperature
    var bluetoothTimer1: Timer!
    //bluetoothTimer humidity
    var bluetoothTimer2: Timer!
    //bluetoothTimer smell
    var bluetoothTimer3: Timer!
    //bluetoothTimer cry
    var bluetoothTimer4: Timer!
    
    
    
    //popviewTimer smell
    var popviewTimer1: Timer!
    var popviewTimer2: Timer!
    var popviewTimer3: Timer!
    var popviewTimer4: Timer!

    

    //label
    @IBOutlet var temperatureLabel : UILabel!
    @IBOutlet var humidityLabel : UILabel!
    @IBOutlet var diLabel : UILabel!
    //check用label
    @IBOutlet var smellLabel : UILabel!
    @IBOutlet var cryLabel : UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //年
        func getYear(format:String = "yyyyねん") -> String {
            
            let now = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = format
            return formatter.string(from: now as Date)
        }

        yearlabeltext = getYear()
        datelabel.text = yearlabeltext
        
        //日付
        func getToday(format:String = "MMがつddにち") -> String {
            
            let now = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = format
            return formatter.string(from: now as Date)
        }
 
        datelabeltext = getToday()
        datelabel.text = datelabeltext
        
        //central managerを初期化
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        
        //GPS setting
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    
    

    
    //central managerの状態変化を取得、centralの状態がpoweronなら（セントラルでBluetoothがオンなら）ペリフェラルスキャンを開始
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            print("start scan!!")
            print("state: \(central.state)")
            
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            print("not ready")
        }
    }
    
    
    //ペリフェラルスキャン結果を受け取り、名前が合致していればスキャンを停止、ペリフェラルへの接続を開始
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber)
    {
       
        guard let pName = peripheral.name else {
            print("false")
            return
        }
        
        //設定した名前
        if pName == "raspberrypi" {
            print(pName)
            
            self.peripheral = peripheral
            self.centralManager.connect(self.peripheral, options: nil)
            
            centralManager.stopScan()
            print("start connecting")
        } else {
        }

    }
    
    //ペリフェラルへの接続結果を取得する
    //ペリフェラルへの接続が成功すると呼ばれ、サービス探索を開始する
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral)
    {
        print("connected!")
        
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        print("start searching service")
    }
    //ペリフェラルへの接続が失敗すると呼ばれる
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?)
    {
        print("failed")
    }
    
    
    //サービス探索結果を受け取り、サービスuuidが求めるものと合致する場合、キャラクタリスティック探索を開始する
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else{
            print("error")
            return
        }
        print("\(services.count)個のサービスを発見。\(services)")
        
        for service in services {
            print(service.uuid)
            //使用するサービス
            if String(describing: service.uuid) == "FF10" {
                print("discovering characteristics")
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    
    //キャラクタリスティック探索結果を取得し、キャラクタリスティックuuidが求めるものと合致する場合、Readを開始する
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?)
    {
        if let error = error {
            print("error:\(error)")
            return
        }
        
        let characteristics = service.characteristics
        print("Found \(characteristics?.count) characteristics! : \(characteristics)")
        
        for characteristic in characteristics! {
            
            //温度キャラクタリスティック
            if String(describing: characteristic.uuid) == "FF11" {
                print("found temperature characteristics")
                self.temperatureCharacteristic = characteristic
                print(self.temperatureCharacteristic)
                
                //bluetooth timerをセット
                bluetoothTimer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.roopReadValueTemperature), userInfo: nil, repeats: true)
                //bluetooth timer start
                bluetoothTimer1.fire()

                
            //湿度キャラクタリスティック
            } else if String(describing: characteristic.uuid) == "FF12" {
                print("found humidity characteristic")
                self.humidityCharacteristic = characteristic
                print(self.humidityCharacteristic)
                
                //bluetooth timerをセット
                bluetoothTimer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.roopReadValueHumidity), userInfo: nil, repeats: true)
                //bluetooth timer start
                bluetoothTimer2.fire()
            
            //臭気キャラクタリスティック
            } else if String(describing: characteristic.uuid) == "FF13" {
                print("found smell characteristic")
                self.smellCharacteristic = characteristic
                print(self.smellCharacteristic)
                
                //bluetooth timerをセット
                bluetoothTimer3 = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.roopReadValueSmell), userInfo: nil, repeats: true)
                //bluetooth timer start
                bluetoothTimer3.fire()
                
            //泣き声キャラクタリスティック
            } else if String(describing: characteristic.uuid) == "FF14" {
                print("found cry characteristic")
                self.cryCharacteristic = characteristic
                print(self.cryCharacteristic)
                
                //bluetooth timerをセット
                bluetoothTimer4 = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.roopReadValueCry), userInfo: nil, repeats: true)
                //bluetooth timer start
                bluetoothTimer4.fire()
            }

        }
    }
    
    //temperature timer
    @objc func roopReadValueTemperature(tm: Timer) {
        peripheral.readValue(for: temperatureCharacteristic!)
        print("start temperature read")
    }
    
    //humidity timer
    @objc func roopReadValueHumidity(tm: Timer) {
        peripheral.readValue(for: humidityCharacteristic!)
        print("start humidity read")
    }
    
    //smell timer
    @objc func roopReadValueSmell(tm: Timer) {
        peripheral.readValue(for: smellCharacteristic!)
        print("start smell read")
    }
    
    //cry timer
    @objc func roopReadValueCry(tm: Timer) {
        peripheral.readValue(for: cryCharacteristic!)
        print("start cry read")
    }

    
    //Read 結果を取得する
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?)
    {
        if let error = error {
            print("Failed...error: \(error)")
            return
        }
        
        
        print("Succeeded!")
        print(characteristic.value)
        print(String(describing: characteristic.uuid))
        
        var a = characteristic.value
        //Data型のvalueをStringに変換(Optional型)、16進数の文字列
        let hexText = a?.reduce("") { $0 + String(format: "%.2hhx", $1) }
        print(hexText)
        
        //Optional Bindingでアンラップ
        guard let hexTextUnrapped = hexText else {
            print("value is nil")
            return
        }
        
        //temperature:uuidがFF11なら温度表示
        if String(describing: characteristic.uuid) == "FF11" {
            //16進数の文字列をIntに変換
            temperature = Int(hexTextUnrapped, radix: 16)!
            temperatureFloat = Float(temperature) * 0.0625
            
            temperatureText = String(temperatureFloat) + "℃"
            
            print(temperatureFloat)
            
            temperatureLabel.text = temperatureText
            
        //humidity:uuidがFF12なら湿度表示
        } else if String(describing: characteristic.uuid) == "FF12" {
            //16進数の文字列をIntに変換
            humidity = Int(hexTextUnrapped, radix: 16)!
            humidityFloat = Float(humidity)
            humidityText = String(humidity) + "%"
            
            print(humidity)
            
            humidityLabel.text = humidityText
            
            DI = round(0.81*temperatureFloat + 0.01*(0.99*humidityFloat-14.3)+46.3)
            ditext = String(DI)
            diLabel.text = ditext
            
        //smell:uuidがFF13なら臭気表示
        } else if String(describing: characteristic.uuid) == "FF13" {
            //16進数の文字列をIntに変換
            smell = Int(hexTextUnrapped, radix: 16)!
            smellText = String(smell)
            
            print(smell)
            
            smellLabel.text = smellText
            
            if smell != 0 {
                //popviewTimerをセット
                popviewTimer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.changeViewController3), userInfo: nil, repeats: false)
                //popviewTimer start
                popviewTimer1.fire()
            }
            
        //cry:uuidがFF14ならメッセージ表示
        } else if String(describing: characteristic.uuid) == "FF14" {
            //16進数の文字列をIntに変換
            cry = Int(hexTextUnrapped, radix: 16)!
            
            cryText = String(cry)
            
            print(cry)
            
            cryLabel.text = cryText
            
            //1:milk
            if cry == 1 {
                //popviewTimerをセット
                popviewTimer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.changeViewController4), userInfo: nil, repeats: false)
                //popviewTimer strart
                popviewTimer2.fire()
            //2:tired
            } else if cry == 2 {
                //popviewTimerをセット
                popviewTimer3 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.changeViewController5), userInfo: nil, repeats: false)
                //popviewTimer start
                popviewTimer3.fire()
            //3:unconfortable
            } else if cry == 3 {
                //popviewTimerをセット
                popviewTimer4 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.changeViewController6), userInfo: nil, repeats: false)
                //popviewTimer start
                popviewTimer4.fire()
            }
        }
    }
 
    
    //smellを受け取ったらViewController3に遷移
    @objc func changeViewController3() {
        self.performSegue(withIdentifier: "toViewController3", sender: nil)
    }
    //cryに1を受け取ったらViewController4に遷移
    @objc func changeViewController4() {
        self.performSegue(withIdentifier: "toViewController4", sender: nil)
    }
    //cryに2を受け取ったらViewController5に遷移
    @objc func changeViewController5() {
        self.performSegue(withIdentifier: "toViewController5", sender: nil)
    }
    //cryに3を受け取ったらViewController6に遷移
    @objc func changeViewController6() {
        self.performSegue(withIdentifier: "toViewController6", sender: nil)
    }
    
    
    // Textを任意のViewControllerに受け渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toViewController3") {
            var omutsuUrl: ViewController3 = (segue.destination as? ViewController3)!
            
            //arrayの一番最後を取得
            latArraylast = latArray.last!
            lngArraylast = lngArray.last!
            
            //サーバーの名前、緯度・経度をURLに設定
            urlStringOmutsu = urlStringOmutsu + serverName + "/omutsu?" + "lat=" + latArraylast + "&lng=" + lngArraylast
            
            // ViewControllerのtextVC3にURLを設定
            omutsuUrl.textVC3 = urlStringOmutsu
            
        } else if (segue.identifier == "toViewController2") {
            var setyear: ViewController2 = (segue.destination as? ViewController2)!
            var setdate: ViewController2 = (segue.destination as? ViewController2)!
            // ViewControllerのsetYearにyearlabeltextを指定
            setyear.setYear = yearlabeltext
            setdate.setDate = datelabeltext
            
        } else if (segue.identifier == "toViewController4") {
            var milkUrl: ViewController4 = (segue.destination as? ViewController4)!
            
            //arrayの一番最後を取得
            latArraylast = latArray.last!
            lngArraylast = lngArray.last!
            
            //サーバーの名前、緯度・経度をURLに設定
            urlStringMilk = urlStringMilk + serverName + "/milk?" + "lat=" + latArraylast + "&lng=" + lngArraylast
            
            //ViewController4のtextVC4にURLを設定
            milkUrl.textVC4 = urlStringMilk
        }
    }
    
    
    
    
    
    
    //GPS
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined :
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }
    
    
    //GPS　取得
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last, CLLocationCoordinate2DIsValid(newLocation.coordinate) else {
            print("GPS Error")
            return
        }
        
        latitudeText = "".appendingFormat("%.4f", newLocation.coordinate.latitude)
        lngitudeText = "".appendingFormat("%.4f", newLocation.coordinate.longitude)
        
        print(latitudeText)
        print(lngitudeText)
        
        latArray.append(latitudeText)
        lngArray.append(lngitudeText)
    }
    
    
    
 
 
    
    //おむつ台ボタンが押されたらsafariでwebpageを開く
    @IBAction func openSafariOmustu() {
        
        //arrayの一番最後を取得
        latArraylast = latArray.last!
        lngArraylast = lngArray.last!
        
        //サーバーの名前、緯度・経度をURLに設定
        urlStringOmutsu = urlStringOmutsu + serverName + "/omutsu?" + "lat=" + latArraylast + "&lng=" + lngArraylast
 
        
        let url = NSURL(string: urlStringOmutsu)
        if UIApplication.shared.canOpenURL(url! as URL){
            UIApplication.shared.open(url! as URL)
        }

    }
    
    //授乳室ボタンが押されたらsafariでwebpageを開く
    @IBAction func openSafariMilk() {
        
        //arrayの一番最後を取得
        latArraylast = latArray.last!
        lngArraylast = lngArray.last!
        print(latArraylast)
        print(lngArraylast)
        
        //サーバーの名前、緯度・経度をURLに設定
        
        urlStringMilk = urlStringMilk + serverName + "/milk?" + "lat=" + latArraylast + "&lng=" + lngArraylast
        
        
        let url = NSURL(string: urlStringMilk)
        if UIApplication.shared.canOpenURL(url! as URL){
            UIApplication.shared.open(url! as URL)
        }
    }
    
    
    //画面遷移
    
    //ボタンが押されたらViewController2へ
    @IBAction func buttonTapped(sender : AnyObject) {
        performSegue(withIdentifier: "toViewController2",sender: nil)
    }
    
    //戻るボタン
    @IBAction func goBack(_ segue:UIStoryboardSegue) {}
    
}

