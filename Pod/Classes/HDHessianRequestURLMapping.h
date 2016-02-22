//
//  HDHessianRequestURLMapping.h
//  Pods
//
//  Created by Dailingchi on 16/2/22.
//
//

#import <Foundation/Foundation.h>

/**
 *  用于配置指定服务的地址
 */
@interface HDHessianRequestURLMapping : NSObject

+ (HDHessianRequestURLMapping *)sharedInstance;

+ (NSString *)URLStringForRequest:(NSString *)requestName;
+ (void)addURLString:(NSString *)URLString forRequest:(NSString *)requestName;
+ (void)removeURLStringForRequest:(NSString *)requestName;

@end
