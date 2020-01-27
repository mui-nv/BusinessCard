//
//  InputViewController.swift
//  BusinessCard
//
//  Created by AxiZ on 2020/01/24.
//  Copyright © 2020 AxiZ. All rights reserved.
//

import UIKit
import MapKit

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
    
    @IBAction func actionRegister(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        testApi()
    }
    
    func registerInformation() {
        
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
            for placeMark in placeMarks! {
                // 緯度
                let lat = placeMark.location?.coordinate.latitude
//                print("lat:" + lat!.description)
                // 経度
                let long = placeMark.location?.coordinate.longitude
//                print("long:" + long!.description)
                
                center = CLLocationCoordinate2D(latitude: lat!, longitude: long!)

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
    
    func testApi() {
        var infoParam = CreateInfoParam(userID: 2, name1: "test1", name2: "test2", company: "campany", department: "department", postal: "1234", address1: "test1", address2: "test2", latitude: 1234.0, longitude: 123.0, image: "ns34")
        informationRepo.createInfo(data: infoParam, createSuccess: { infoData in
            print(infoData)
        }, createError: { resultError in
            print(resultError)
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
