//
//  Cerveau.swift
//  TP1
//
//  Created by LANIER Mickaël on 16/03/2018.
//  Copyright © 2018 LANIER Mickaël. All rights reserved.
//

import Foundation

class Cerveau : CustomStringConvertible {
    var pileDOp = [Op]()// ou Array<Op>
    var opérationsConnues = [String:Op]()//ou Dictionary<String, Op>()
    enum Op : CustomStringConvertible {
        case Opérande(Double)
        case OpérationBinaire (String, (Double, Double) -> Double)
        case OpérationUnaire (String, (Double) -> Double)
        var description: String {
            switch self {
            case .Opérande(let valeur):
                return "\(valeur)"
            case .OpérationUnaire(let nom, _):
                return nom
            case .OpérationBinaire(let nom, _):
                return nom
            }
        }
    }
    func pousseOpérande(nombre: Double){ // pousse
        pileDOp.append(Op.Opérande(nombre))
    }
    
    var description : String {
        return pileDOp.description
    }
    
    init(){
        opérationsConnues["+"] = Op.OpérationBinaire("+") {$0+$1}
        opérationsConnues["-"] = Op.OpérationBinaire("-") {$1-$0}
        opérationsConnues["×"] = Op.OpérationBinaire("*") {$0*$1}
        opérationsConnues["÷"] = Op.OpérationBinaire("÷") {$0/$1}
        
        opérationsConnues["√"] = Op.OpérationUnaire("√") {sqrt($0)}
        opérationsConnues["cos"] = Op.OpérationUnaire("cos") {cos($0)}
        opérationsConnues["sin"] = Op.OpérationUnaire("sin") {sin($0)}
        opérationsConnues["²"] = Op.OpérationUnaire("²") {$0*$0}
        
    }
    func applique(opération nom: String){ //globale: "opération" locale: "nom"
        if let operation = opérationsConnues[nom] { // si nil code ignoré si !nil ->
            pileDOp.append(operation)
        }
    }
    
    func evaluate() -> Double? {
        let(valeur, _) = evaluate(pileDOp)
        return valeur
    }
    
    func clearScreen(_ sender: Any){
        pileDOp.removeAll();
    }

    func evaluate(_ ops:[Op]) -> (Double?, [Op]) {
        if !ops.isEmpty {
            var remainOps = ops;
            let op = remainOps.popLast()!
            switch op {
            case .Opérande(let nombre):
                return (nombre, remainOps)
            case .OpérationUnaire(_, let opération):
            var (valeur, resPile) = evaluate(remainOps)
                if let val = valeur {
                    return (opération(val), resPile)
                }
                else {
                    return (nil, resPile)
                }
            case .OpérationBinaire(_,let opération):
                var (valeur, resPile) = evaluate(remainOps)
                if let val1 = valeur {
                    (valeur, resPile) = evaluate(resPile)
                    if let val2 = valeur {
                        return (opération(val1,val2), resPile)
                    }
                }
            return (nil, resPile)
            }
        }
        return (nil, ops)
    }
    //Compléter opérations connues 
}
