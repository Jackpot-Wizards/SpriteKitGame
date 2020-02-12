//
//  PlatformController.swift
//  Handles the random generation of platforms
//
//  Created by
//  Ignat Pechkurenko - 301091721
//  Blair Desjardins  - 301086973
//  Heun Oh           - 301082798
//
//  Date last modified: Feb 11 2020
//  Version 1.0

import Foundation
import GameplayKit

class PlatformController
{
    private let numPlatformListPool = 9     // Number of platform list in the pool
    
    // Platform list pool
    private var platformListPool : Array<Array<Platform>> = Array(Array())
    
    private var idxPlatformListPrev = -1    // Previsously selected index of the pool
    private var levelName = ""              // Level Name
    
    
    init(_ level : String = "platformsLevel1")
    {
        if levelName != level
        {
            // Get the object information from the plist
            var nsDictionary: NSDictionary?
            if let path = Bundle.main.path(forResource: level, ofType: "plist")
            {
                nsDictionary = NSDictionary(contentsOfFile: path)
                            
                for idx in 1...numPlatformListPool
                {
                    let platformPlist = "platforms" + String(idx)
                    platformListPool.append([Platform]())
                    if let plts = nsDictionary?[platformPlist] as? Array<[String: Any]>
                    {
                        for plt in plts
                        {
                            let newPlatform = Platform(dict:plt)!
                            platformListPool[idx-1].append(newPlatform)
                        }
                    }

                }
            }
        }
        
        levelName = level
    }
    
    /**
     Randomly select and return platfrom list from the pool
     */
    func getNewPlatformList() -> Array<Platform>
    {
        // Randomly select next platform list
        let randomSource = GKARC4RandomSource()
        var idxSel = randomSource.nextInt(upperBound: platformListPool.count)
        while(idxPlatformListPrev == idxSel) {
            idxSel = randomSource.nextInt(upperBound: platformListPool.count)
        }
        idxPlatformListPrev = idxSel
        
        return platformListPool[idxSel]
    }
}
