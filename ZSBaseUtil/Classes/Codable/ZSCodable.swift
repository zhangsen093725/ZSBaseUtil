//
//  ZSCodable.swift
//  JadeKing
//
//  Created by 张森 on 2019/9/6.
//  Copyright © 2019 张森. All rights reserved.
//

import Foundation

public extension Encodable {
    
    // TODO: 模型转JSON字符串
    var zs_json: String {
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        guard let data = try? encoder.encode(self) else { return "" }
        let string = String(data: data, encoding: .utf8)!
        
        return string
    }
    
    // TODO: 模型数组转JSON字符串
    static func zs_json<T : Encodable>(from array: [T]) -> String {
        
        var tempArray: [Any] = []
        
        for object in array
        {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .useDefaultKeys
            if let data = try? encoder.encode(object)
            {
                if let obj = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                {
                    tempArray.append(obj)
                    continue
                }
            }
            tempArray.append("")
        }
        return tempArray.zs_json ?? ""
    }
}

public extension Decodable {
    
    static func zs_from<T: Decodable>(_ object: Any) -> T? {
        
        let decoder = JSONDecoder()
        var jsonData: Data?
        
        if let map = object as? [String : Any]
        {
            jsonData = map.zs_json?.data(using: .utf8)
        }
        else if let array = object as? [Any]
        {
            jsonData = array.zs_json?.data(using: .utf8)
        }
        else if let string = object as? String
        {
            jsonData = string.data(using: .utf8)
        }
        
        if jsonData != nil
        {
            do {
                return try decoder.decode(T.self, from: jsonData!)
            } catch {
                print(error)
            }
        }
        
        return nil
    }
}


public extension KeyedDecodingContainer {
    
    /// 防止Bool类型数据在JSON中是Int的类型
    func decodeIfPresent(_ type: Bool.Type, forKey key: K) throws -> Bool? {
        
        if let value = try? decode(type, forKey: key) {
            return value
        }
        
        if let value = try? decode(String.self, forKey: key) {
            
            switch value.lowercased() {
            case "true", "yes", "y", "1":
                return true
            case "false", "no", "n", "0":
                return false
            default:
                return nil
            }
        }
        
        if let value = try? decode(Int.self, forKey: key) {
            return value > 0
        }
        
        return nil
    }
    
    
    /// 防止Int类型数据在JSON中是String的类型
    func decodeIfPresent(_ type: Int.Type, forKey key: K) throws -> Int? {
        
        if let value = try? decode(type, forKey: key) {
            return value
        }
        
        if let value = try? decode(String.self, forKey: key) {
            return Int(value)
        }
        
        return nil
    }
    
    
    /// 防止String类型数据在JSON中是Int的类型
    func decodeIfPresent(_ type: String.Type, forKey key: K) throws -> String? {
        
        if let value = try? decode(type, forKey: key) {
            return value
        }
        
        if let value = try? decode(Int.self, forKey: key) {
            return String(value)
        }
        
        return nil
    }
    
    
    /// 防止 Dictionary, Array, SubModel 解析失败
    func decodeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? where T : Decodable {
        
        if let value = try? decode(String.self, forKey: key) {
            
            guard let jsonData = value.data(using: .utf8) else {
                return try? decode(type, forKey: key)
            }
            
            let decoder = JSONDecoder()
            
            guard let obj = try? decoder.decode(type, from: jsonData) else {
                return try? decode(type, forKey: key)
            }
            
            return obj
        }
        
        return try? decode(type, forKey: key)
    }
}


public extension Dictionary {
    
    var zs_json: String? {
        
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        
        guard let newData: Data = try? JSONSerialization.data(withJSONObject: self, options: []) else { return nil }
        
        return String(data: newData, encoding: .utf8)
    }
    
    // TODO: 字典转模型
    func zs_model<T: Decodable>() -> T? {
        
        guard let JSONString = zs_json else { return nil }
        
        return JSONString.zs_model()
    }
}

public extension Array {
    
    var zs_json: String? {
        
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        
        guard let newData: Data = try? JSONSerialization.data(withJSONObject: self, options: []) else { return nil }
        
        return String(data: newData, encoding: .utf8)
    }
    
    // TODO: 数组转模型数组
    func zs_model<T: Decodable>() -> [T]? {
        
        guard let JSONString = zs_json else { return nil }
        
        return JSONString.zs_model()
    }
}


public extension String {
    
    var zs_dictionary: [String : Any]? {
        return Data(utf8).zs_dictionary
    }
    
    var zs_array: [Any]? {
        return Data(utf8).zs_array
    }
    
    // TODO: JSON转模型
    func zs_model<T: Decodable>() -> T? {
        
        guard let jsonData = data(using: .utf8) else { return nil }
        
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(T.self, from: jsonData)
        } catch {
            print(error)
        }
        
        return nil
    }
}


public extension Data {
    
    var zs_dictionary: [String : Any]? {
        
        guard let dict = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers) else {
            
            return nil
        }
        
        return dict as? [String : Any]
    }
    
    var zs_array: [Any]? {
        
        guard let dict = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers) else {
            
            return nil
        }
        
        return dict as? [Any]
    }
}
