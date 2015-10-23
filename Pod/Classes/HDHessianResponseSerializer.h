//
//  HDHessianResponseSerializer.h
//  Pods
//
//  Created by Dailingchi on 15/10/22.
//
//

#import <AFNetworking/AFNetworking.h>
#import "HaidoraNetworkHessianDefines.h"

@interface HDHessianResponseSerializer : AFHTTPResponseSerializer

/**
 Hessian编码版本
 */
@property (nonatomic, assign) HDHeesianVersion version;

+ (instancetype)serializerWithVersion:(HDHeesianVersion)version;

@end
