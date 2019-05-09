//
//  GestureManager.swift
//  GameCube
//
//  Created by Michał.Krupa on 07.03.2018.
//  Copyright © 2018 Michał.Krupa. All rights reserved.
//

import UIKit

class GestureManager: NSObject {
    
    static let shared   = GestureManager()
    
    var gestPosLogs     = true // Zmienna do wyswietlania logów pozycji w obrębie GestureManagera
    var gestGestLogs    = true // Zmienna do wyswietlania akcji gestów
    
    var screenSize:CGSize
    var touchBeganArr:Array<CGPoint>?
    var touchContinueArrActiv:Array<CGPoint>?
    var touchEndsArr:Array<CGPoint>?
    
    var touch1: CGPoint?
    var touch2: CGPoint?
    
    override init() {
        screenSize = CGSize(width: 0, height: 0)
    }
    
    public func touchesBegan(array:Array<CGPoint>) {
        touchBeganArr = array
        if gestPosLogs { print("touch begin array \(String(describing: touchBeganArr!))") }
    }
    
    public func touchesMoved(array:Array<CGPoint>) {
        touchContinueArrActiv = array
        if gestPosLogs { print("touch cont array \(String(describing: touchContinueArrActiv!)) time:\(Date()) ") }
    }
    
    public func touchesEnded(array:Array<CGPoint>) {
        touchEndsArr = array
        if gestPosLogs { print("touch end array \(String(describing: touchEndsArr!)) ") }
    }
    
    public func touchesCancelled(array:Array<CGPoint>) {
        
    }
    
    private func calculateGestureAction() {
        
    }
}
