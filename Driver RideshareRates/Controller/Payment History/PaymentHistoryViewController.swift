//
//  PaymentHistoryViewController.swift
//  Driver RideshareRates
//
//  Created by malika on 27/09/23.
//

import UIKit
import Popover
import Alamofire
import Charts

class PaymentHistoryViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet var mFilterLBL: UILabel!
    //MARK:- OUTLETS
    @IBOutlet weak var mYearBTN: UIButton!
    @IBOutlet weak var mMonthBTN: UIButton!
    @IBOutlet weak var mWeekBTN: UIButton!
    @IBOutlet weak var chartView: BarChartView!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var paymentHistoryList: UITableView!
    @IBOutlet weak var totalEarning: UILabel!
    @IBOutlet weak var totalEarningView: UIView!
    @IBOutlet weak var mButtonsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mButtonsView: UIView!
    let conn = webservices()
    var completedRidesData = [PaymentHistoryModal]()
    var filterStatus = false
    var barButtonRight = UIBarButtonItem()
    var logoBtnRight = UIButton()
    //MARK:- Variables
   
    fileprivate var texts = ["Date", "Ascending", "descending"]
    //For Pagination
    var isDataLoading:Bool=false
    var pageNo:Int=0
    var limit:Int=10
    var offset:Int=0 //pageNo*limit
    var didEndReached:Bool=false
    let spinner = UIActivityIndicatorView(style: .gray)
   // let players = ["tee","sdf","sdf","sdf","sdf","sdf"]
 //   let goals = [6, 8, 26, 30, 8, 10]
    var months = [String]()
    var amount = [Double]()
    var cyear = Int()
    var cmonth = Int()
    var cweek = Int()
    //    let unitsBought = [10.0, 14.0, 60.0, 13.0, 2.0]
    
    var monthAmount = [RidesData]()
    
    //MARK:- Default Func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNav()
        self.settupTableView()
        mButtonsViewHeight.constant = 0
        mButtonsView.isHidden = true
        let date = Date()
        let calendar = Calendar.current
        cyear = calendar.component(.year, from: date)
        cmonth = calendar.component(.month, from: date)
        cweek = 1
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: paymentHistoryList.bounds.width, height: CGFloat(44))
        getearning(urll: "earnios?year=\(cyear)" )
      }
    //MARK:- get earning api
    func getearning(urll : String) {
        Indicator.shared.showProgressView(self.view)
       
        self.conn.startConnectionWithGetTypeWithParam(getUrlString: urll,authRequired: true) { (value) in
            print(value)
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                    let data = (value["data"] as? [[String:AnyObject]] ?? [[:]])
                    do{
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        self.months.removeAll()
                        self.amount.removeAll()
                        for dictNEO in data  {
                            print(dictNEO)
                            print(type(of: dictNEO))
                           
                            if urll == "earnios?year=\(self.cyear)"{
                                self.months.append(dictNEO["month"] as! String)
                            }else{
                                self.months.append(dictNEO["day"] as! String)
                            }
                            
                            
                            let amou = Double(dictNEO["amount"] as! String)!
                            self.amount.append(amou)
                        }
                        self.customizeChart()
                        self.monthAmount = try newJSONDecoder().decode(rides.self, from: jsonData)
                    }catch{
                        print(error.localizedDescription)
                    }
            }
        }
    }
    //MARK:- customize Chart
    func customizeChart() {
        var dataEntries: [BarChartDataEntry] = []
        print(months)
        for i in 0..<self.months.count {
            let dataEntry = BarChartDataEntry(x: Double(i) , y: self.amount[i])
            print(dataEntry)
            dataEntries.append(dataEntry)
        }
        let xaxis = chartView.xAxis
        xaxis.labelTextColor = UIColor.white
        xaxis.labelPosition = .bottom
        xaxis.valueFormatter = IndexAxisValueFormatter(values:self.months)
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.rightAxis.enabled = false
        let leftAxis = chartView.leftAxis
        leftAxis.labelTextColor = UIColor.white
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Earning Analysis")
        let chartData = BarChartData(dataSet: chartDataSet)
        
       
        chartData.setValueTextColor(UIColor.white)
        chartDataSet.valueTextColor = .white
        chartDataSet.colors = [UIColor(red: 224/255.0, green: 136/255.0, blue: 87/255.0, alpha: 1.0)]
        chartView.legend.textColor = .white

        chartView.data = chartData
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        self.paymentHistoryDetailApi(from: "", to: "", pageNo: "\(pageNo)", perPage: "\(limit)")
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "My Earnings"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8784313725, green: 0.5333333333, blue: 0.3411764706, alpha: 1)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = "My Earnings"
    }
    //MARK:- User Defined Func
    func setNav(){
        self.setNavButton()
    }
    func setNavButton(){
        let logoBtn = UIButton(type: .custom)
        logoBtn.setImage(UIImage(named: "shape_28"), for: .normal)
        logoBtn.addTarget(self, action: #selector(tapNavButton), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: logoBtn)
        self.navigationItem.leftBarButtonItem = barButton
        self.navigationItem.rightBarButtonItem = barButtonRight
    }
    @objc func filterBtnAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DateRangeVC") as! DateRangeVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.dateRangeVCDelegate  = self
        present(vc, animated: true, completion: nil)
    }
    @IBAction func calendarBtnActon(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DateRangeVC") as! DateRangeVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.dateRangeVCDelegate  = self
        present(vc, animated: true, completion: nil)
    }
    @objc func tapNavButton(){
        let presentedVC = self.storyboard!.instantiateViewController(withIdentifier: "SideMenuViewController")
        let nvc = UINavigationController(rootViewController: presentedVC)
        present(nvc, animated: false, pushing: true, completion: nil)
    }
    @IBAction func mYearBTN(_ sender: Any) {
        mButtonsViewHeight.constant = 0
        mButtonsView.isHidden = true
        if mYearBTN.currentImage == UIImage(systemName: "poweroff"){
            mWeekBTN.setImage(UIImage(systemName: "poweroff"), for: .normal)
            mMonthBTN.setImage(UIImage(systemName: "poweroff"), for: .normal)
            mYearBTN.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            getearning(urll: "earnios?year=\(cyear)")
        }
    }
    @IBAction func mWeekBTN(_ sender: Any) {
        mButtonsViewHeight.constant = 20
        mButtonsView.isHidden = false
        if mWeekBTN.currentImage == UIImage(systemName: "poweroff"){
            getearning(urll: "earnios?week=\(cweek)")
            mYearBTN.setImage(UIImage(systemName: "poweroff"), for: .normal)
            mMonthBTN.setImage(UIImage(systemName: "poweroff"), for: .normal)
            mWeekBTN.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }
    }
    @IBAction func mMonthBTN(_ sender: Any) {
        mButtonsViewHeight.constant = 20
        mButtonsView.isHidden = false

        if mMonthBTN.currentImage == UIImage(systemName: "poweroff"){
            getearning(urll: "earnios?month=\(cmonth)")
            mYearBTN.setImage(UIImage(systemName: "poweroff"), for: .normal)
            mWeekBTN.setImage(UIImage(systemName: "poweroff"), for: .normal)
            mMonthBTN.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }
    }
    
    @IBAction func mLeftBtn(_ sender: Any) {
        
        if mWeekBTN.currentImage == UIImage(systemName: "checkmark.circle.fill"){
            if cweek > 1{
                cweek = cweek - 1
                getearning(urll: "earnios?week=\(cweek)")
            }
        }
        if mMonthBTN.currentImage == UIImage(systemName: "checkmark.circle.fill"){
            if cmonth > 1{
                cmonth = cmonth - 1
                getearning(urll: "earnios?month=\(cmonth)")
            }
        }
        
    }
    
    @IBAction func mRighBTN(_ sender: Any) {
        if mWeekBTN.currentImage == UIImage(systemName: "checkmark.circle.fill"){
            if cweek < 4{
                cweek = cweek + 1
                getearning(urll: "earnios?week=\(cweek)")
            }
             
        }
        if mMonthBTN.currentImage == UIImage(systemName: "checkmark.circle.fill"){
            if cmonth < 12{
                cmonth = cmonth + 1
                getearning(urll: "earnios?month=\(cmonth)")
            }
        }
    }
//    func hideBTN(){
//        if mWeekBTN.currentImage == UIImage(systemName: "checkmark.circle.fill"){
//            if cweek == 4{
//               mrig
//            }
//        }
//    }
    
}

    

extension PaymentHistoryViewController : UIScrollViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
    }
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
        if ((paymentHistoryList.contentOffset.y + paymentHistoryList.frame.size.height) >= paymentHistoryList.contentSize.height)
        {
            if !isDataLoading{
                isDataLoading = true
                self.pageNo=self.pageNo+1
                self.limit=self.limit+10
                self.offset=self.limit * self.pageNo
                self.paymentHistoryDetailApi(from: "", to: "", pageNo: "\(self.offset)", perPage: "\(self.limit)")
            }
        }
    }
}


extension PaymentHistoryViewController : UITableViewDelegate,UITableViewDataSource {
    func settupTableView(){
        self.paymentHistoryList.delegate = self
        self.paymentHistoryList.dataSource = self
        self.paymentHistoryList.tableFooterView = spinner
        self.paymentHistoryList.tableFooterView?.isHidden = false
        self.paymentHistoryList.register(UINib(nibName: "PaymentHistoryViewControllerCell", bundle: nil), forCellReuseIdentifier: "PaymentHistoryViewControllerCell")
       // self.paymentHistoryList.register(UINib(nibName: "LoadingView", bundle: nil), forCellReuseIdentifier: "LoadingView")
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.completedRidesData.count ) == 0 {
            tableView.setEmptyMessage("No Data Found.")
        } else {
            tableView.removeErrorMessage()
        }
        return self.completedRidesData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.paymentHistoryList.dequeueReusableCell(withIdentifier: "PaymentHistoryViewControllerCell") as! PaymentHistoryViewControllerCell
        cell.pickUpAddress_lbl.text = self.completedRidesData[indexPath.row].pikup_location ?? ""
        cell.dropAddress_lbl.text = self.completedRidesData[indexPath.row].drop_address ?? ""
        if self.completedRidesData[indexPath.row].user_lastname == ""{
            cell.driverName_lbl.text = "Boss"
        }else{
            cell.driverName_lbl.text = self.completedRidesData[indexPath.row].user_lastname ?? ""

        }
        cell.date_lbl.text =  self.completedRidesData[indexPath.row].time ?? ""
        if self.completedRidesData[indexPath.row].tip_amount == nil {
            cell.mTipAmount.text = ""
        }else{
            cell.mTipAmount.text = "Tip: $" + "\(self.completedRidesData[indexPath.row].tip_amount ?? "")" //self.completedRidesData[indexPath.row].tip_amount! ?? ""
        }

      //  cell.time_lbl.text = getStringFormat(date: (self.completedRidesData[indexPath.row].date ?? ""))
        cell.amount_lbl.text = " $" + "\(self.completedRidesData[indexPath.row].payout_amount ?? "")"
        cell.distance_lbl.text =  "\(self.completedRidesData[indexPath.row].distance ?? "")" + "  Miles"
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 225
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "PaymentDetailVC") as! PaymentDetailVC
        vc.ridesStatusData = self.completedRidesData[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK:- Web Api
extension PaymentHistoryViewController{
    
    func paymentHistoryDetailApi(from:String , to:String,pageNo :String ,perPage:String) {
        Indicator.shared.showProgressView(self.view)
        var url = "payment_history?from&to&page_no=1&per_page=10"
        if from != ""{
            url = "payment_history?from=\(from)&to=\(to)&page_no=1&per_page=10"
            mFilterLBL.text = "\(from) - \(to)"
        }
        self.conn.startConnectionWithGetTypeWithParam(getUrlString: url,authRequired: true) { (value) in
            print(value)
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                //  if (value["status"] as? Int ?? 0) == 1{
                  if (value["status"] as? Int ?? 0) == 1 {
                      self.totalEarning.text = value["total_payout"] as? String ?? ""
                      let data = (value["data"] as? [[String:Any]] ?? [[:]])
                      do{
                          let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                          self.completedRidesData = try newJSONDecoder().decode(userPaymentHistoryModal.self, from: jsonData)
                          let totalItems = value["total_record"] as? Int ?? 0
                          self.totalEarningView.isHidden = false
                          self.spinner.stopAnimating()
                          self.paymentHistoryList.reloadData()
                      }catch{
                          print(error.localizedDescription)
                      }
                  }
                  else{
                      print("No data found")
                      self.totalEarningView.isHidden = false
                      self.paymentHistoryList.setEmptyMessage("No data found")
                      self.completedRidesData.removeAll()
                      self.paymentHistoryList.reloadData()
                  }
              }
        }
    }
    
}
extension PaymentHistoryViewController: dateRangeVCProtocal{
    func backRangeDateSelectedDate(fromDate: String, toDate: String, selectedStatus: String) {
        print("fromDateFinal\(fromDate)+++++++toDateFinal\(toDate)")
        if fromDate != "" && toDate != "" {
            self.paymentHistoryDetailApi(from: fromDate, to: toDate, pageNo: "\(pageNo)", perPage: "10")
            self.paymentHistoryList.reloadData()
        }
    }
}


