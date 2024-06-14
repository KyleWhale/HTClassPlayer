//
//  HTClassSubtitleManager.swift
//  HTClassPlayer
//
//  Created by 李雪健 on 2024/6/13.
//

import Foundation

public class HTClassSubtitleManager {
    
    // srt文件地址
    static public func ht_parseSubtitleFile(_ var_path: URL?, _ var_completion: (([[String: Any]]) -> Void)?) {
        
        guard let var_path = var_path else {
            var_completion?([])
            return
        }
        do {
            let var_data = try Data(contentsOf: var_path)
            if var var_contents = String(data: var_data, encoding: .utf8), !var_contents.isEmpty {
                var_contents = var_contents.replacingOccurrences(of: "\r", with: "")
                var_contents = var_contents.replacingOccurrences(of: "\t", with: "")
                let var_array = var_contents.split(separator: "\n", omittingEmptySubsequences: false).map { String($0) }
                var var_type = 0 // 0：序号 1: 时间 2:英文 3:中文
                var var_items: [[String: Any]] = []
                var var_params: [String: Any] = [:]
                for var_item in var_array {
                    let var_string = var_item.trimmingCharacters(in: .whitespaces)
                    if !var_string.isEmpty {
                        switch var_type {
                        case 0:
                            var_params[ht_AsciiString("index")] = var_string
                            break
                        case 1:
                            if let var_range = var_string.range(of: "-->") {
                                var var_beginStr = String(var_string[..<var_range.lowerBound])
                                var_beginStr = var_beginStr.replacingOccurrences(of: " ", with: "")
                                var_params[ht_AsciiString("begin")] = ht_timeStringToSeconds(var_beginStr)
                                var var_endStr = String(var_string[var_range.upperBound...])
                                var_endStr = var_endStr.replacingOccurrences(of: " ", with: "")
                                var_params[ht_AsciiString("end")] = ht_timeStringToSeconds(var_endStr)
                            }
                            break
                        case 2:
                            var_params[ht_AsciiString("subtitle")] = var_string
                            break
                        default:
                            if var var_last = var_params[ht_AsciiString("subtitle")] as? String {
                                var_last = "\(var_last) \(var_string)"
                                var_params[ht_AsciiString("subtitle")] = var_last
                            }
                            break
                        }
                        var_type += 1
                    } else {
                        // 遇到空行，就添加到数组
                        var_type = 0
                        var_items.append(var_params)
                        var_params.removeAll()
                    }
                }
                var_completion?(var_items)
            } else {
                var_completion?([])
            }
        } catch {
            print("error -----> \(error)")
            var_completion?([])
        }
    }
    
    static func ht_timeStringToSeconds(_ var_input: String) -> Double? {
        // 检查输入字符串是否包含逗号
        if var_input.contains(",") {
            // 按照逗号分割字符串，获取秒和毫秒部分
            let var_parts = var_input.split(separator: ",")
            guard var_parts.count == 2 else {
                return nil
            }
            // 获取秒和毫秒部分
            let var_timePart = String(var_parts[0])
            let var_millisecondPart = String(var_parts[1])
            // 按照冒号分割时间部分，获取小时、分钟和秒
            let var_timeComponents = var_timePart.split(separator: ":")
            guard var_timeComponents.count == 3 else {
                return nil
            }
            // 将各个部分转换为整数
            guard let var_hours = Int(var_timeComponents[0]),
                  let var_minutes = Int(var_timeComponents[1]),
                  let var_seconds = Int(var_timeComponents[2]),
                  let var_milliseconds = Int(var_millisecondPart) else {
                return nil
            }
            // 计算总秒数
            let var_totalSeconds = Double(var_hours * 3600 + var_minutes * 60 + var_seconds) + Double(var_milliseconds) / 1000.0
            return var_totalSeconds
        } else {
            // 按照冒号分割时间部分，获取小时、分钟和秒
            let var_timeComponents = var_input.split(separator: ":")
            guard var_timeComponents.count == 3 else {
                return nil
            }
            // 将各个部分转换为整数
            guard let var_hours = Int(var_timeComponents[0]),
                  let var_minutes = Int(var_timeComponents[1]),
                  let var_seconds = Int(var_timeComponents[2]) else {
                return nil
            }
            // 计算总秒数
            let var_totalSeconds = Double(var_hours * 3600 + var_minutes * 60 + var_seconds)
            return var_totalSeconds
        }
    }

}
