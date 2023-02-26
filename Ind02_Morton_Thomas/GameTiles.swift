//
//  GameTiles.swift
//  Ind02_Morton_Thomas
//
//  Created by user on 2/26/23.
//

import Foundation
import UIKit

class GameTiles {
    //Stores image properties and creates an array of image data
    //This is certainly not the best way to do things, but it is what it is

    let img00 = UIImage(named: "00.png")
    let img10 = UIImage(named: "10.png")
    let img20 = UIImage(named: "20.png")
    let img30 = UIImage(named: "30.png")

    let img01 = UIImage(named: "01.png")
    let img11 = UIImage(named: "11.png")
    let img21 = UIImage(named: "21.png")
    let img31 = UIImage(named: "31.png")

    let img02 = UIImage(named: "02.png")
    let img12 = UIImage(named: "12.png")
    let img22 = UIImage(named: "22.png")
    let img32 = UIImage(named: "32.png")

    let img03 = UIImage(named: "03.png")
    let img13 = UIImage(named: "13.png")
    let img23 = UIImage(named: "23.png")
    let img33 = UIImage(named: "33.png")

    let img04 = UIImage(named: "04.png")
    let img14 = UIImage(named: "14.png")
    let img24 = UIImage(named: "24.png")
    let img34 = UIImage(named: "34.png")
     
    func generateArray() -> [[Data?]] {
        let pngDataArray: [[Data?]] =
        [
            [img00?.pngData(), img10?.pngData(), img20?.pngData(), img30?.pngData()],
            [img01?.pngData(), img11?.pngData(), img21?.pngData(), img31?.pngData()],
            [img02?.pngData(), img12?.pngData(), img22?.pngData(), img32?.pngData()],
            [img03?.pngData(), img13?.pngData(), img23?.pngData(), img33?.pngData()],
            [img04?.pngData(), img14?.pngData(), img24?.pngData(), img34?.pngData()],
        ]
     
        return pngDataArray
    }
}

