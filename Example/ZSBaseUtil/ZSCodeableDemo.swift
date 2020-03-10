//
//  ZSCodeableDemo.swift
//  ZSBaseUtil_Example
//
//  Created by 张森 on 2020/3/5.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import ZSBaseUtil

struct SubModel: ZSCodable {
    
    var isSuccess: Bool?
    
    var other: String?
    
    var project: Int?
    
    enum CodingKeys: String, CodingKey {
        case isSuccess = "is_success"
        case project = "project"
        case other = "other_model"
    }
}


struct Model: ZSCodable {
    
    var subModel: SubModel?
    
    var other: Int?
    
    var project: String?
    
    enum CodingKeys: String, CodingKey {
        case subModel = "sub_model"
        case other = "other_model"
        case project = "project"
    }
}

class ZSCodeableDemo: NSObject {
    
    class func demo() {
        
        let sub: String = ["is_success" : true,
                           "other_model" : "project",
                           "project": 1].zs_json ?? ""
        
        let params: String = ["sub_model" : sub,
                              "other_model" : 12,
                              "project": "project"].zs_json ?? ""
        
        
        let model = try? Model.zs_modelFromJSON(params)
        
        print(model)
    }
}
