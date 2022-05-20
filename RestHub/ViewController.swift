//
//  ViewController.swift
//  RestHub
//
//  Created by Sagar Kadam on 15/05/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        let testGist = Gist(id: nil, isPublic: true, description: "Hello World!", files: nil)
//
//        do{
//            let gistData = try JSONEncoder().encode(testGist)
//            let stringData = String(data: gistData, encoding: .utf8)
//            print(stringData)
//        }catch{
//            print("Encoding Failed...")
//        }
        /*
        DataService.shared.fetchGists { (result) in
            switch result {
            case .success(let gists):
                for gist in gists {
                    print("\(gist)\n")
                }
            case .failure(let error):
                print(error)
            }
        }
        */
        
        DataService.shared.starUnstarGist(id: "7648c2c27aaf659b2349c9d3bad2fa6d", star: true) { success in
            
            if success {
                print("Gist Successfully Starred!!")
            }else{
                print("Gist was not able to be starred..")
            }
        }
         
    }
    
    

    @IBAction func newGistButtonClicked(_ sender: Any) {
        
        DataService.shared.createNewGist { (result) in
            switch result {
            case .success(let json):
                print(json)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    
}

