//
//  SQLiteError.swift
//  SQift
//
//  Created by Christian Noon on 11/8/15.
//  Copyright © 2015 Nike. All rights reserved.
//

import Foundation
import SQLite3

/// Used to encapsulate errors generated by SQLite.
public struct SQLiteError: Error {

    // MARK: Properties

    /// The [code](https://www.sqlite.org/c3ref/c_abort.html) of the specific error encountered by SQLite.
    public let code: Int32

    /// The [message](https://www.sqlite.org/c3ref/errcode.html) of the specific error encountered by SQLite.
    public var message: String

    /// A textual description of the [error code](https://www.sqlite.org/c3ref/errcode.html).
    public var codeDescription: String { return String(cString: sqlite3_errstr(code)) }

    private static let successCodes: Set = [SQLITE_OK, SQLITE_ROW, SQLITE_DONE]

    // MARK: Initialization

    init?(code: Int32, connection: Connection) {
        guard !SQLiteError.successCodes.contains(code) else { return nil }

        self.code = code
        self.message = String(cString: sqlite3_errmsg(connection.handle))
    }

    init(connection: Connection) {
        self.code = sqlite3_errcode(connection.handle)
        self.message = String(cString: sqlite3_errmsg(connection.handle))
    }
}

// MARK: - CustomStringConvertible

extension SQLiteError: CustomStringConvertible {
    /// A textual representation of the error message, code and code description.
    public var description: String {
        let messageArray = [
            "message=\"\(message)\"",
            "code=\(code)",
            "codeDescription=\"\(codeDescription)\""
        ]

        return "{ " + messageArray.joined(separator: ", ") + " }"
    }
}
