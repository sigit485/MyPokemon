//
//  BaseView.swift
//  MyPokemon
//
//  Created by Sigit on 17/01/23.
//

import UIKit
import NVActivityIndicatorView

class BaseView: UIViewController {
    
    public var indicator: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func initIndicatiorView() {
        indicator = NVActivityIndicatorView(frame: CGRect(origin: .zero, size: CGSize(width: 80, height: 80)), type: .circleStrokeSpin, color: .systemBlue, padding: nil)
        indicator.center(to: view)
    }
    
    func showAlert(title: String? = "", message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        })
        alert.addAction(action)
        
        self.present(alert, animated: true)
    }
    
    func showAlertWithField(_ message: String, completion: @escaping ((String) -> Void)) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addTextField()
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] _ in
            let text = alert?.textFields?.first?.text
            if text != "" {
                completion(text ?? "")
            }
        }))
        
        self.present(alert, animated: true)
    }
    
}
