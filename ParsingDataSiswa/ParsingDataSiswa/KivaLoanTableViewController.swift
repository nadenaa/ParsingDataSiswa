//
//  KivaLoanTableViewController.swift
//  ParsingDataSiswa
//
//  Created by yusronadena on 11/2/17.
//  Copyright © 2017 yusron. All rights reserved.
//

import UIKit

class KivaLoanTableViewController: UITableViewController {
    
    let kivaLoanURL = "https://raw.githubusercontent.com/mobilesiri/JSON-Parsing-in-Android/master/index.html"
    var loans = [loan]()
    var nameSelected:String?
    var addressSelected:String?
    var emailSelected:String?
    var genderSelected:String?
    var phonemobileSeleced:String?
    var phonehomeSelected:String?
    var phoneoffice:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //retrieve the latest loans by calling the kiva API
        getLatestLoans()
        
        //self sizing cells
        //set row height to 92
        tableView.estimatedRowHeight = 92.0
        //set row table height to automatic dimension
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return loans.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! KivaLoanTableViewCell
        
        // Configure the cell...
        //input the value to each label
        cell.nameLabel.text = loans[indexPath.row].name
        cell.addressLabel.text = loans[indexPath.row].country
        cell.emailLAbel.text = loans[indexPath.row].use
        cell..text = "$\(loans[indexPath.row].amount)"
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //mengecek data yang dikirim
        let dataTask = loans[indexPath.row]
        //memasukan data ke variable namaSelected dan image selected ke masing masing variable nya
        usernameSelected = dataTask.name
        countrySelected = dataTask.country
        useSelected = dataTask.use
        amountSelected = "\(dataTask.amount)"
        //memamnggil segue passDataDetail
        performSegue(withIdentifier: "segue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //mengecek apakah segue nya ada atau  tidak
        if segue.identifier == "segue"{
            //kondisi ketika segue nya ada
            //mengirimkan data ke detailViewController
            let sendData = segue.destination as! ViewController
            sendData.passName = usernameSelected
            sendData.passCountry = countrySelected
            sendData.passUse = useSelected
            sendData.passAmount = amountSelected
        }
    }
    //MARK : - JSON Parsing
    //create new method with name : getLatestLoans()
    func getLatestLoans() {
        guard let loanURL = URL(string: kivaLoanURL) else {
            return //this return is for back up the value that got when call variable loanURL
        }
        
        //declare request for request URL loanUrl
        let request = URLRequest(url: loanURL)
        //declare task for take data from variable request above
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            //check what error is available or not
            if let error = error {
                //condition when error
                //print error
                print(error)
                return //back up value error that we get
            }
            //parse JSON data
            //declare variable data to call data
            if let data = data {
                //for this part will call method parseJsonData that we will make in below
                self.loans = self.parseJsonData(data: data)
                
                //reload tableView
                OperationQueue.main.addOperation({
                    //reload data again
                    self.tableView.reloadData()
                })
            }
        })
        //task will resume to call the json data
        task.resume()
    }
    
    //create new method with name ParseJsonData
    //this method will parsing data Json
    func parseJsonData(data: Data) -> [Loan] {
        //declare variable loans as object from loans class
        var loans = [Loan]()
        //will repeat to json data that parsed
        do{
            //declare jsonResult for take data from the json
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            
            //parse json data
            //declare jsonLoans for call data array jsonResult with name Loans
            let jsonLoans = jsonResult?["loans"] as! [AnyObject]
            //will call data be repeated for jsonLoan have data json array from variable jsonLoans
            for jsonLoan in jsonLoans {
                //declare loan as object from class loan
                let loan = Loan()
                //enter the value to each object from class loan
                //enter value jsonLoan with name object name as string
                loan.name = jsonLoan["name"] as! String
                //enter value jsonLoan with name object loan_amount as string
                loan.amount = jsonLoan["loan_amount"] as! Int
                //enter value jsonLoan with name object use as string
                loan.use = jsonLoan["use"] as! String
                //enter value jsonLoan with name object location as string
                let location = jsonLoan["location"] as! [String:AnyObject]
                //enter value jsonLoan with name object country as string
                loan.country = location["country"] as! String
                //process enter data to object
                loans.append(loan)
            }
        }catch{
            print(error)
        }
        return loans
    }
}

