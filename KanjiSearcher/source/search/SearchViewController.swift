//
//  SearchViewController.swift
//  KanjiSearcher
//
//  Created by 吉田拓真 on 2020/07/12.
//  Copyright © 2020 hmiyado. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: override UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: IBxxx
    
    @IBOutlet weak var textFieldReading: UITextField!
    @IBAction func buttonSearch(_ sender: Any) {
        guard let reading = textFieldReading.text else {
            return
        }
        print("reading: \(reading)")
    }
}

