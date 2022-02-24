//
//  UserSettings.swift
//  Calculator
//
//  Created by Кристина Максимова on 22.02.2022.
//

import Foundation

final class UserSettings {
    
    private enum SettingsKeys: String {
        case userName
    }
    
    static var historyArray: [String]! {
        get {
            return UserDefaults.standard.stringArray(forKey: SettingsKeys.userName.rawValue)
        } set {
            let defaults = UserDefaults.standard
            let key = SettingsKeys.userName.rawValue
            guard let history = newValue else {
                defaults.removeObject(forKey: key)
                return }
            defaults.set(history, forKey: key)
        }
    }
}
