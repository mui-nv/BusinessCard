//
//  InputViewController.swift
//  BusinessCard
//
//  Created by AxiZ on 2020/01/24.
//  Copyright © 2020 AxiZ. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

class InputViewController: UIViewController {
    @IBOutlet weak var myMap: MKMapView!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textName2: UITextField!
    @IBOutlet weak var textCompany: UITextField!
    @IBOutlet weak var textDepartment: UITextField!
    @IBOutlet weak var textPostal: UITextField!
    @IBOutlet weak var textAddress1: UITextField!
    @IBOutlet weak var textAddress2: UITextField!
    
    let informationRepo = InformationRepository()
    
    var latitudeValue: Double?
    var longitudeValue: Double?
    
    let disposeBag: DisposeBag = DisposeBag()
    
    var address1Value: String?
    var address2Value: String?
    
    @IBAction func actionRegister(_ sender: Any) {
        registerInformation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        textAddress1.rx.controlEvent([UIControl.Event.editingDidBegin])
        .asDriver()
            .drive(onNext: { value in
                self.address1Value = self.textAddress1.text
            })
        .disposed(by: disposeBag)
        textAddress2.rx.controlEvent([UIControl.Event.editingDidBegin])
        .asDriver()
            .drive(onNext: { value in
                self.address2Value = self.textAddress2.text
            })
        .disposed(by: disposeBag)
        
        textAddress1.rx.controlEvent([UIControl.Event.editingDidEnd])
        .asDriver()
            .drive(onNext: {
                self.checkMapPreview()
            })
        .disposed(by: disposeBag)
        
        textAddress2.rx.controlEvent([UIControl.Event.editingDidEnd])
        .asDriver()
            .drive(onNext: {
                self.checkMapPreview()
            })
        .disposed(by: disposeBag)
    }
    
    func checkMapPreview() {
        guard let address1 = textAddress1.text, let address2 = textAddress2.text, address1 != "", address2 != "" else {
            return
        }
        
        if address1 != address1Value || address2 != address2Value {
            address1Value = address1
            address2Value = address2
            previewMap(addressForLocation: address1 + address2)
        }
    }
    
    func registerInformation() {
        guard let name1 = textName.text, let name2 = textName2.text, let company = textCompany.text, let department = textDepartment.text, let address1 = textAddress1.text, let address2 = textAddress2.text, let postal = textPostal.text else {
            showErrorDialog(messgae: "please insert all data!")
            return
        }
        
        guard name1 != "", name2 != "", company != "", department != "", address1 != "", address2 != "", postal != "", longitudeValue != nil, latitudeValue != nil else {
            showErrorDialog(messgae: "please insert all data!")
            return
        }
        
        let infoParam = CreateInfoParam(userID: 0, name1: name1, name2: name2, company: company, department: department, postal: postal, address1: address1, address2: address2, latitude: latitudeValue!, longitude: longitudeValue!, image: "ns34")
        
        createInformation(infomation: infoParam)
    }
    
    func previewMap(addressForLocation: String) {
        // 中心座標（横浜中華街）
        var center = CLLocationCoordinate2D(latitude: 31.4424225, longitude: 139.6465645)
        
        //        //入力された文字から位置情報を取得
        //        let prefecture:String = "東京都"
        //        let city:String = "中央区"
        //        let street:String = "日本橋本町３ー８第二東硝ビル"
        //
        //        // 建物名が含まれると正しく座標が表示されないことがあります
        //        let addressForLocation = prefecture + city + street
        
        // 入力された住所を元に取材地の座標を登録
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressForLocation) { (placeMarks, error) in
            guard placeMarks != nil else {
                return
            }
            
            for placeMark in placeMarks! {
                // 緯度
                self.latitudeValue = placeMark.location?.coordinate.latitude
                //                print("lat:" + lat!.description)
                // 経度
                self.longitudeValue = placeMark.location?.coordinate.longitude
                //                print("long:" + long!.description)
                
                center = CLLocationCoordinate2D(latitude: self.latitudeValue!, longitude: self.longitudeValue!)
                
                // 表示範囲（約222m×222mの範囲）
                let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
                // 地図の表示領域を決める
                let region = MKCoordinateRegion(center: center, span: span)
                self.myMap.setRegion(region, animated:true)
            }
        }
        
        // 表示範囲（約222m×222mの範囲）
        let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        // 地図の表示領域を決める
        let region = MKCoordinateRegion(center: center, span: span)
        myMap.setRegion(region, animated:true)
        // アノテーションを作る
        let annotation = MKPointAnnotation()
        annotation.coordinate  = center
        annotation.title = "ここです！"
        annotation.subtitle = "私、待ってます"
        // アノテーションを表示する
        myMap.addAnnotation(annotation)
    }
    
    func createInformation(infomation: CreateInfoParam) {
        informationRepo.createInfo(data: infomation, createSuccess: { infoData in
            showErrorDialog(messgae: "Create Infomation Successed!")
        }, createError: { resultError in
            showErrorDialog(messgae: resultError)
        })
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
