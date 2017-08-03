
//
//  Logger.swift
//  BluedolphinCloudSdk
//
//  Created by Raghvendra on 31/07/17.
//  Copyright © 2017 raremediacompany. All rights reserved.
//

import Foundation






///The log class containing all the needed methods
public class Log {
    
    ///The max size a log file can be in Kilobytes. Default is 1024 (1 MB)
    public var maxFileSize: UInt64 = 1024
    
    ///The max number of log file that will be stored. Once this point is reached, the oldest file is deleted.
    public var maxFileCount = 4
    
    ///The directory in which the log files will be written
    public var directory = Log.defaultDirectory()
    
    //The name of the log files.
    public var name = "logfile"
    
    ///logging singleton
    public class var logger: Log {
        
        struct Static {
            static let instance: Log = Log()
        }
        return Static.instance
    }
    //the date formatter
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        return formatter
    }
    
    ///write content to the current log file.
    public func write(text: String) {
        let path = "\(directory)/\(logName(num: 0))"
        let fileManager = FileManager.default
        
        if !fileManager.fileExists(atPath: path) {
            do {
                try "".write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            } catch _ {
            }
        }
        if let fileHandle = FileHandle(forWritingAtPath: path) {
            let dateStr = dateFormatter.string(from: NSDate() as Date)
            let writeText = "[\(dateStr)]: \(text)\n"
            fileHandle.seekToEndOfFile()
            fileHandle.write(writeText.data(using: String.Encoding.utf8)!)
            fileHandle.closeFile()
            print(writeText, terminator: "")
            cleanup()
        }
    }
    ///do the checks and cleanup
    func cleanup() {
        let path = "\(directory)/\(logName(num: 0))"
        let size = fileSize(path: path)
        let maxSize: UInt64 = maxFileSize*1024
        if size > 0 && size >= maxSize && maxSize > 0 && maxFileCount > 0 {
            rename(index: 0)
            //delete the oldest file
            let deletePath = "\(directory)/\(logName(num: maxFileCount))"
            let fileManager = FileManager.default
            do {
                try fileManager.removeItem(atPath: deletePath)
            } catch _ {
            }
        }
    }
    
    ///check the size of a file
    func fileSize(path: String) -> UInt64 {
        let fileManager = FileManager.default
        let attrs: NSDictionary? = try? fileManager.attributesOfItem(atPath: path) as NSDictionary
        if let dict = attrs {
            return dict.fileSize()
        }
        return 0
    }
    
    ///Recursive method call to rename log files
    func rename(index: Int) {
        let fileManager = FileManager.default
        let path = "\(directory)/\(logName(num: index))"
        let newPath = "\(directory)/\(logName(num: index+1))"
        if fileManager.fileExists(atPath: newPath) {
            rename(index: index+1)
        }
        do {
            try fileManager.moveItem(atPath: path, toPath: newPath)
        } catch _ {
        }
    }
    
    ///gets the log name
    func logName(num :Int) -> String {
        return "\(name)-\(num).log"
    }
    
    ///get the default log directory
    class func defaultDirectory() -> String {
        var path = ""
        let fileManager = FileManager.default
        #if os(iOS)
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            path = "\(paths[0])/Logs"
        #elseif os(OSX)
            let urls = fileManager.URLsForDirectory(.LibraryDirectory, inDomains: .UserDomainMask)
            if let url = urls.last {
                if let p = url.path {
                    path = "\(p)/Logs"
                }
            }
        #endif
        if !fileManager.fileExists(atPath: path) && path != ""  {
            do {
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
            } catch _ {
            }
        }
        return path
    }
    
}

///a free function to make writing to the log much nicer
public func logw(text: String) {
    Log.logger.write(text: text)
}
