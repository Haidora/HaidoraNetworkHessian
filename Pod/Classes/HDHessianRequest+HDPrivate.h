//
//  HDHessianRequest+HDPrivate.h
//  Pods
//
//  Created by Dailingchi on 15/11/2.
//
//

#import "HDHessianRequest.h"

@interface HDHessianRequest (HDPrivate)

@property (nonatomic, copy) NSString *hd_remoteMethodName;
@property (nonatomic, copy) NSArray *hd_parameters;

/**
 *  远程方法映射
 *
 *  @{@"本地方法名":@"远程方法名"};
 */
+ (NSDictionary *)hd_remoteMethodMap;

@end
