//
//  DateRangeVC.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//


import UIKit
protocol dateRangeVCProtocal {
    func backRangeDateSelectedDate(fromDate: String,toDate: String,selectedStatus: String )
}
class DateRangeVC: UIViewController {
    @IBOutlet weak var fromDateLabel: UITextField!
    @IBOutlet weak var toDateLabel: UITextField!
    fileprivate var _popUpVC = UIViewController()
    var dateSelectStatus = false
    var dateRangeVCDelegate: dateRangeVCProtocal?
    
    var datePicker = UIDatePicker()
    var datePicker2 = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        fromDateLabel.delegate = self
        toDateLabel.delegate = self
    }
    
    
    func showDatePicker(){
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker2.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        fromDateLabel.inputView = datePicker
        
       datePicker2.datePickerMode = .date
        datePicker2.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        toDateLabel.inputView = datePicker2
    }
    
    @IBAction func fromDateBtn(_ sender: Any) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CalanderPopUpVC") as! CalanderPopUpVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.modalTransitionStyle = .crossDissolve
//        vc.dateFromTo = .fromDate
//        vc.calanderPopUpDelegate  = self
//        present(vc, animated: true, completion: nil)
    }
    @IBAction func toDateBtn(_ sender: Any) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CalanderPopUpVC") as! CalanderPopUpVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.modalTransitionStyle = .crossDissolve
//        vc.dateFromTo = .toDate
//        vc.calanderPopUpDelegate  = self
//        present(vc, animated: true, completion: nil)
    }
    @IBAction func cancelBtn(_ sender: Any) {
        self.dateRangeVCDelegate?.backRangeDateSelectedDate(fromDate: "", toDate: "", selectedStatus: "")
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func subnmitBtn(_ sender: Any) {
        print("FROM====\(kFromDate)TO=====\(kToDate)")
        if kFromDate != "" && kToDate == ""{
            self.showAlert("Driver RideshareRates", message: "Please Select To Date")
        }
        if kFromDate != "" && kToDate != ""{
            self.dateRangeVCDelegate?.backRangeDateSelectedDate(fromDate: kFromDate, toDate: kToDate, selectedStatus: kSelectedStatus)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension DateRangeVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == fromDateLabel{
            showDatePicker()
        }else if textField == toDateLabel{
            showDatePicker()
          //  mEndDateTXTFLD.text = ""
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == fromDateLabel {
            let selectedDate = datePicker.date
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            self.fromDateLabel.text = formatter.string(from: selectedDate)
            kFromDate = formatter.string(from: selectedDate)
            datePicker2.minimumDate = datePicker.date
        }else if textField == toDateLabel {
            let selectedDate = datePicker2.date
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            self.toDateLabel.text = formatter.string(from: selectedDate)
            kToDate = formatter.string(from: selectedDate)
        }
    }
}
extension DateRangeVC: CalanderPopUpProtocal{
    func backSelectedDate(fromDate: String, toDate: String, selectedStatus: String) {
        kSelectedStatus = selectedStatus
        if selectedStatus == "fromDte"{
            self.fromDateLabel.text = fromDate
            kFromDate = fromDate
        }
        if selectedStatus == "toDte"{
            self.toDateLabel.text = toDate
            kToDate = toDate
        }
    }
}

