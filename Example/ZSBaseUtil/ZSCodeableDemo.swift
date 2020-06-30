//
//  ZSCodeableDemo.swift
//  ZSBaseUtil_Example
//
//  Created by 张森 on 2020/3/5.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import ZSBaseUtil

struct SubModel: Codable {
    
    var isSuccess: Bool?
    
    var other: String?
    
    var project: Int?
    
    enum CodingKeys: String, CodingKey {
        case isSuccess = "is_success"
        case project = "projectHssaA"
        case other = "other_model"
    }
}


struct Model: Codable {
    
    var subModel: SubModel?
    
    var other: Int?
    
    var project: [SubModel]?
    
    enum CodingKeys: String, CodingKey {
        case subModel = "sub_model"
        case other = "other_model"
        case project = "projectHssaA"
    }
}

class ZSCodeableDemo {
    
    class func demo() {
        
        let sub: [String : Any] = ["is_success" : true,
                                   "other_model" : "project",
                                   "projectHssaA": 1]
        
        let params: String = ["sub_model" : sub,
                              "other_model" : 12,
                              "projectHssaA": [sub, sub, sub]].zs_json ?? ""

        let array: [SubModel]? = SubModel.zs_from([sub, sub, sub].zs_json!)
        
        let model: Model? = params.zs_model()
        let models: [SubModel]? = [sub, sub, sub].zs_model()
        let submodels: [SubModel]? = SubModel.zs_json(from: models!).zs_model()
        
        print(SubModel.zs_json(from: models!))
        
        print(model!)
        print(array!)
        print(submodels!)
    }
}



// TODO: 继承实现
class ModelDemo: Codable {
    
    var subModel: SubModel?
    
    var other: Int?
    
    var project: [SubModel]?
    
    enum CodingKeys: String, CodingKey {
        case subModel = "sub_model"
        case other = "other_model"
        case project = "projectHssaA"
    }
}


class SubModelDemo: ModelDemo {

    var isSuccess: Bool?
    
    enum CodingKeys: String, CodingKey {
        case isSuccess = "is_success"
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isSuccess = try container.decode(Bool.self, forKey: CodingKeys.isSuccess)
        try super.init(from: decoder)
    }
}
