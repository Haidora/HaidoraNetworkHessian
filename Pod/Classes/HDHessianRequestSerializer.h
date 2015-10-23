//
//  HDHessianRequestSerializer.h
//  Pods
//
//  Created by Dailingchi on 15/10/22.
//
//

#import <AFNetworking/AFNetworking.h>
#import "HaidoraNetworkHessianDefines.h"

/**
 *  Hessian请求序列化
 */
@interface HDHessianRequestSerializer : AFHTTPRequestSerializer

/**
 Hessian编码版本
 */
@property (nonatomic, assign) HDHeesianVersion version;

+ (instancetype)serializerWithVersion:(HDHeesianVersion)version;

@end
