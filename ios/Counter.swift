//
//  Counter.swift
//  uPortMobile
//
//  Created by Ryan Robison on 2/17/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import sdk_core_swift
import CoreBluetooth
import XyBleSdk
import mod_ble_swift
import sdk_objectmodel_swift

@objc(Counter)
class Counter: NSObject, XYSmartScanDelegate, XyoHueresticGetter {
  func getHeuristic() -> XyoObjectStructure? {
    if (id != nil) {
      let shema = XyoObjectSchema.create(id: 40, isIterable: false, isTypedIterable: false, sizeIdentifier: XyoObjectSize.ONE)
      return XyoObjectStructure.newInstance(schema: shema, bytes: XyoBuffer(data: id!))
    }
   
    return nil
  }
  
  private var id : [UInt8]? = nil
  private var can = true
  private var boundWitness : XyoBoundWitness? = nil
  private let hasher = XyoSha256()
  private let storageProvider = XyoInMemoryStorage()
  private lazy var blockRepo : XyoStrageProviderOriginBlockRepository = XyoStrageProviderOriginBlockRepository(storageProvider: self.storageProvider, hasher: self.hasher)
  private lazy var originChainCreator : XyoRelayNode =  XyoRelayNode(hasher: self.hasher, blockRepository: self.blockRepo)
  private var objects : [XYBluetoothDevice] = []
  private let scanner = XYSmartScan.instance
  
  func smartScan(status: XYSmartScanStatus) {}
  func smartScan(location: XYLocationCoordinate2D) {}
  func smartScan(detected device: XYBluetoothDevice, signalStrength: Int, family: XYDeviceFamily) {}
  func smartScan(entered device: XYBluetoothDevice) {}
  func smartScan(exiting device: XYBluetoothDevice) {}
  func smartScan(exited device: XYBluetoothDevice) {}
  
  func smartScan(detected devices: [XYBluetoothDevice], family: XYDeviceFamily) {
    if (devices.count > 0 && can) {
      can = false
      self.bw(device2: devices[0])
    }
  }
  
  // This is going to be hooked into the intitiation function of the application
  @objc
  func loadOnStartUp() {
    DispatchQueue.main.sync {
      print("1 hello startup")
      self.originChainCreator.originState.addSigner(signer: XyoStubSigner())
      print("2 hello startup")
      XyoBluetoothDevice.family.enable(enable: true)
      print("3 hello startup")
      XyoBluetoothDeviceCreator.enable(enable: true)
      print("4 hello startup")
      self.scanner.start(mode: XYSmartScanMode.foreground)
      
      // set id to uPort address
      originChainCreator.addHuerestic(key: "dtring", getter: self)
      
      print("5 hello startup")
      self.scanner.setDelegate(self, key: "main")
      print("6 hello startup")
    }
    
    
    
  }
  
  @objc
  static func requiresMainQueueSetup () -> Bool {
    return false
  }
  
  // This is the onclick function
  func bw(device2 : XYBluetoothDevice) {
    //        cell.indicator.startAnimating()
    DispatchQueue.main.async {
      guard let device = device2 as? XyoBluetoothDevice else {
        return
      }
      
      // await instead
      device.connection {
        do {
          guard let pipe = device.tryCreatePipe() else {
            return
          }
          
          let handler = XyoNetworkHandler(pipe: pipe)
          self.boundWitness = try self.originChainCreator.doNeogeoationThenBoundWitness(handler: handler, procedureCatalogue: XyoFlagProcedureCatalogue(forOther: 0xff, withOther: 0xff))
          
          
        } catch {
          XYCentral.instance.disconnect(from: device)
          return
          // cell.indicator.stopAnimating()
        }
        
        DispatchQueue.main.async {
          // cell.indicator.stopAnimating()
        }
        
      }.always {
        XYCentral.instance.disconnect(from: device)
        self.can = true
      }
    }
  }
  
  private var count = 0
  @objc
  func increment() {
    count += 1
    print("count is \(count)")
    NSLog("count is %S", count)
  }
  
  @objc
  func getAddress(_ callback: RCTResponseSenderBlock) {
    callback([id])
  }
  
  @objc
  func setAddress(add : [UInt8]) {
    self.id = add;
  }
  
  @objc   // only returns static data - won't update after startup
  func constantsToExport() -> [AnyHashable : Any]! {
    return [
      "number": 123.9,
      "string": "foo",
      "boolean": true,
      "array": [1, 22.2, "33"],
      "object": ["a": 1, "b": 2]
    ]
  }

  
}
