//
//  ZSCodable.swift
//  JadeKing
//
//  Created by 张森 on 2019/9/6.
//  Copyright © 2019 张森. All rights reserved.
//

import Foundation

fileprivate enum ZSCodableError: Error {
    /// json转model失败
    case zs_jsonToModelFail
    /// json转data失败
    case zs_jsonToDataFail
    /// json转数组失败
    case zs_jsonToArrayFail
    /// 字典转json失败
    case zs_dictToJsonFail
    /// model转json失败
    case zs_modelToJsonFail
}

protocol ZSCodable: Codable {
    
    func modelCodableFinished()
    mutating func structCodableFinish()
}

extension ZSCodable {
    
    func modelCodableFinished() {}
    
    mutating func structCodableFinish() {}
    
    // TODO: 字典转模型
    static func zs_modelFromDict(_ dict: [String : Any]) throws -> Self {
        
        guard let JSONString = dict.zs_toJSONString() else {
            throw ZSCodableError.zs_dictToJsonFail
        }
        
        guard let obj = try? zs_modelFromJSON(JSONString) else {
            throw ZSCodableError.zs_dictToJsonFail
        }
        
        return obj
    }
    
    // TODO: JSON转模型
    static func zs_modelFromJSON(_ JSONString: String) throws -> Self {

        guard let jsonData = JSONString.data(using: .utf8) else {
            throw ZSCodableError.zs_jsonToDataFail
        }
        
        let decoder = JSONDecoder()
        
        guard let obj = try? decoder.decode(self, from: jsonData) else {
            throw ZSCodableError.zs_jsonToModelFail
        }

        var vobj = obj
        let mirro = Mirror(reflecting: vobj)
        
        if mirro.displayStyle == .struct {
            vobj.structCodableFinish()
        }
        
        if mirro.displayStyle == .class {
            vobj.modelCodableFinished()
        }
        
        return vobj
    }
    
    // TODO: 模型转字典
    func zs_reflectModelToDict() -> [String : Any] {
        
        let mirro = Mirror(reflecting: self)
        var dict = [String : Any]()
        for case let (key?, value) in mirro.children {
            dict[key] = value
        }
        return dict
    }
    
    // TODO: 模型转JSON字符串
    func zs_toJSONString() throws -> String {
        
        guard let string = self.zs_reflectModelToDict().zs_toJSONString() else {
            throw ZSCodableError.zs_modelToJsonFail
        }
        
        return string
    }
}


extension Dictionary {
    
    func zs_toJSONString() -> String? {
        
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        
        guard let newData: Data = try? JSONSerialization.data(withJSONObject: self, options: []) else { return nil }
        
        return String(data: newData, encoding: .utf8)
    }
}

extension Array {
    
    func zs_toJSONString() -> String? {
    
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        
        guard let newData: Data = try? JSONSerialization.data(withJSONObject: self, options: []) else { return nil }
        
        return String(data: newData, encoding: .utf8)
    }
    
    func modelFromJson<T: Decodable>(_ type: [T].Type) throws -> Array<T> {
        
        guard let JSONString = self.zs_toJSONString() else {
            throw ZSCodableError.zs_dictToJsonFail
        }
        
        guard let jsonData = JSONString.data(using: .utf8) else {
            throw ZSCodableError.zs_jsonToDataFail
        }
        
        let decoder = JSONDecoder()
        
        guard let obj = try? decoder.decode(type, from: jsonData) else {
            throw ZSCodableError.zs_jsonToArrayFail
        }
        
        return obj
    }
}


extension String {
    
    func zs_toDictionary() -> [String : Any]? {
        
        guard let jsonData: Data = self.data(using: .utf8) else {
            
            return nil
        }
        
        guard let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) else {
            
            return nil
        }
        
        return dict as? [String:Any] ?? ["":""]
    }
    
}




extension KeyedDecodingContainer {
    
    /// 防止Int类型数据在JSON中是String的类型
    public func decodeIfPresent(_ type: Int.Type, forKey key: K) throws -> Int? {
        
        if let value = try? decode(type, forKey: key) {
            return value
        }
        
        if let value = try? decode(String.self, forKey: key) {
            return Int(value)
        }
        
        return nil
    }
    
    
    /// 防止String类型数据在JSON中是Int的类型
    public func decodeIfPresent(_ type: String.Type, forKey key: K) throws -> String? {
        
        if let value = try? decode(type, forKey: key) {
            return value
        }
        
        if let value = try? decode(Int.self, forKey: key) {
            return String(value)
        }
        
        return nil
    }
    
    
    /// 防止 Dictionary, Array, SubModel 解析失败
    public func decodeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? where T : Decodable {
        
        return try? decode(type, forKey: key)
    }
}
