//
//  Debouncer.swift
//  MusicList
//
//  Created by Boray Chen on 2024/7/16.
//

import Foundation

class Debouncer {
    private var delay: TimeInterval
    private var task: DispatchWorkItem?

    init(delay: TimeInterval) {
        self.delay = delay
    }

    func schedule(action: @escaping () -> Void) {
        // Cancel the previous task if it exists
        task?.cancel()
        
        // Create a new task
        task = DispatchWorkItem { action() }
        
        // Schedule the new task after the specified delay
        if let task = task {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: task)
        }
    }
}
