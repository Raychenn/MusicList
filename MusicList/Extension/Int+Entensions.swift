//
//  Int+Entensions.swift
//  MusicList
//
//  Created by Boray Chen on 2024/7/19.
//

import Foundation

extension Int {
    func formatTime() -> String {
        let totalSeconds = self / 1000
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        
        return String(format: "%d:%02d", minutes, seconds)
    }
}
