//
//  ViewController.swift
//  morningCall
//
//  Created by Takahiro Kirifu on 2020/03/15.
//  Copyright © 2020 Takahiro Kirifu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let <#変数名#> = segue.destination as! SetViewController
        
        <#変数名#>.<#値を渡す先の変数名#> = <#渡す値#>
        
    }

    @IBAction func plusButton(_ sender: Any) {
        
    }
    
}

