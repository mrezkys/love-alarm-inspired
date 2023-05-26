//
//  BluetoothManager.swift
//  LoveAlarmInspired
//
//  Created by Muhammad Rezky on 25/05/23.
//


import SwiftUI
import CoreBluetooth

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralManagerDelegate {
    private var centralManager: CBCentralManager!
    var peripheralManager: CBPeripheralManager!
    
    @Published var discoveredDevices: [String] = []
    @Published var isAdvertising = false
    @Published var isScanning = false
    @Published var loadingScanning = false
    
    
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    @objc func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            print("Peripheral Manager is powered on")
        } else {
            print("Peripheral Manager is powered off or unavailable")
        }
    }
    
    
    func startAdvertising(id: String) {
        let advertisementData = [ CBAdvertisementDataLocalNameKey: id]
        peripheralManager.startAdvertising(advertisementData)
        print("start advertising")
        isAdvertising = true
    }
    
    func stopAdvertising() {
        scanTimer?.invalidate()
        
        peripheralManager.stopAdvertising()
        print("stop advertising")
        isAdvertising = false
    }
    
    private var scanTimer: Timer? = nil
    //
    func startScanDevices(targets: [String], play:@escaping () -> Void) {
        scanTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
            self.discoveredDevices.removeAll()
            self.isScanning = true
            print("Mulai pemindaian")
            self.centralManager.scanForPeripherals(withServices: nil)
            self.loadingScanning = true
            let tim = Timer.scheduledTimer(withTimeInterval: 1, repeats: false){t in
                print(self.discoveredDevices)
                for target in targets{
                    if(self.discoveredDevices.contains(target)){
                        print("discovered")
                        play()
                    }
                }
                self.stopScanDevices()
                print("Selesai pemindaian")
                self.loadingScanning = false
                
            }
        }
    }
    //
    
    //    func startScanDevices(target: String, play:@escaping () -> Void) {
    //        discoveredDevices.removeAll()
    //        isScanning = true
    //        print("Mulai pemindaian")
    //        centralManager.scanForPeripherals(withServices: nil)
    //        loadingScanning = true
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    //            print(self.discoveredDevices)
    //            if(self.discoveredDevices.contains(target)){
    //                print("discovered")
    //                play()
    //            }
    //            self.stopScanDevices()
    //            print("Selesai pemindaian")
    //            self.loadingScanning = false
    //            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    //                self.startScanDevices(target: target, play: play)
    //            }
    //        }
    //    }
    
    func stopScanDevices() {
        centralManager.stopScan()
        isScanning = false
    }
    
    
    
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            // Bluetooth is ready for advertising
            //                startAdvertising(id: "mrezkysulihin@icloud.com")
        }
        //        if central.state == .poweredOn {
        //            print("Bluetooth is powered on")
        else {
            print("Bluetooth is powered off or unavailable")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let peripheralName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            if !discoveredDevices.contains(peripheralName) {
                discoveredDevices.append(peripheralName)
            }
        }
    }
}

