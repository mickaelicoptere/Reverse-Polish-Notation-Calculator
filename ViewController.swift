//
//  ViewController.swift
//  TP1
//
//  Created by LANIER Mickaël on 02/03/2018.
//  Copyright © 2018 LANIER Mickaël. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var nbAVirgule = false
    var onEstAuMilieuDuNombre = false
    var pileDeNombres : Array<Double> = Array<Double>()
    
    var brain = Cerveau()
    
    var valeurAfichée : Double {
        get {
            onEstAuMilieuDuNombre = false
            nbAVirgule=true	
            return NumberFormatter().number(from: ecran.text!)!.doubleValue
        }
        set {
            ecran.text = "\(newValue)"
            onEstAuMilieuDuNombre = false
            nbAVirgule = false
        }
    }
    
    @IBOutlet weak var screenPile: UILabel!
    @IBOutlet weak var ecran: UILabel!

    //Methode
    
    
    @IBAction func ajouteChiffre(_ sender: UIButton) {
        let chiffre = sender.currentTitle!
        
        if onEstAuMilieuDuNombre {
            ecran.text = ecran.text! + chiffre
        }else {
            ecran.text = chiffre
            onEstAuMilieuDuNombre = true
        }
    }
    
    
    @IBAction func entry(_ sender: UIButton) {
        if onEstAuMilieuDuNombre {
            brain.pousseOpérande(nombre : valeurAfichée)
            onEstAuMilieuDuNombre = false
            affichePile()
        }
        print ("le cerveau vaut : \(brain)")
    }
    
    @IBAction func clearScreen(_ sender: Any) {
        ecran.text = "0"
        onEstAuMilieuDuNombre = false
        brain.clearScreen(description)
        affichePile()
    }
    
    @IBAction func calcule(_ sender: UIButton) {
        if onEstAuMilieuDuNombre {
            brain.pousseOpérande(nombre: valeurAfichée)
            onEstAuMilieuDuNombre = false
        }
        brain.applique(opération: sender.currentTitle!)
        if let result = brain.evaluate(){
            valeurAfichée = result
        }
        print("le cerveau vaut \(brain)")
        affichePile()
    }
    
    
    @IBAction func retirerChiffre(_ sender: UIButton) {
        if ecran.text!.characters.count>1 {
            ecran.text?.removeLast()
        } else if ecran.text?.characters.count == 1 {
            valeurAfichée = 0
            ecran.text = "0"
        }
    }
    
    func applique(operation: (Double, Double)->Double){
        if pileDeNombres.count >= 2 {
            valeurAfichée = operation(pileDeNombres.popLast()!,pileDeNombres.popLast()!)
        }
    }
    
    func affichePile() {
        screenPile.text = brain.description
    }
    
    func applique(operation: (Double)->Double){
        if pileDeNombres.count >= 1{
            valeurAfichée = operation(pileDeNombres.popLast()!)
        }
    }
    
    @IBAction func ajouteVirgule(_ sender: UIButton){
        if !nbAVirgule {
            nbAVirgule = true
            if onEstAuMilieuDuNombre {
                ecran.text = ecran.text! + "."
            }else {
                ecran.text = "0."
                onEstAuMilieuDuNombre = true
            }
        }
    }
}

