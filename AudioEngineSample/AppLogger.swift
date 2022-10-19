//
//  AppLogger.swift
//
//  Created by ToKoRo on 2022-01-05.
//

import Foundation

final class AppLogger {
    static func debug(_ message: @autoclosure () -> String) {
        #if DEBUG
            print(message())
        #endif
    }

    static func info(_ message: @autoclosure () -> String) {
        #if DEBUG || STAGING
            print(message())
        #endif
    }

    static func notice(_ message: @autoclosure () -> String) {
        #if DEBUG || STAGING
            print(message())
        #endif
    }

    static func warning(_ message: @autoclosure () -> String) {
        print(message())
    }

    static func error(_ message: @autoclosure () -> String) {
        print(message())
    }

    static func error(_ error: @autoclosure () -> Swift.Error) {
        print(error())
    }
}
