//
//  MainViewController.swift
//  QRScannerSample
//
//  Created by wbi on 2020/05/20.
//  Copyright © 2020 mercari.com. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapButton(_ sender: UIButton) {
        let vc = QRViewController()
        navigationController?.present(vc, animated: true)
        //navigationController?.pushViewController(vc, animated: true)
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
