//
//  RuntimeUtils.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation

func executeWithDelay(_ ts: TimeInterval = 0.2, blockToExecute: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + ts, execute: {
        blockToExecute()
    })
}

func executeOnMainThread(_ ts: TimeInterval = 0.0, blockToExecute: @escaping () -> Void) {
    if Thread.isMainThread {
        executeWithDelay(ts, blockToExecute: blockToExecute)
    } else {
        DispatchQueue.main.sync {
            executeWithDelay(ts, blockToExecute: blockToExecute)
        }
    }
}

func executeOnBackgroundThread(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
    DispatchQueue.global(qos: .background).async {
        background?()
        if let completion = completion {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                completion()
            })
        }
    }
}
