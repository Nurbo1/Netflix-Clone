//
//  Extensions.swift
//  Netflix Clone
//
//  Created by Нурбол Мухаметжан on 17.06.2024.
//

import Foundation

extension String{
    func capitalizeFirstLetter()-> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
