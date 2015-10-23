//
//  YTKBaseRequest+HDHessianRequest.h
//  Pods
//
//  Created by Dailingchi on 15/10/22.
//
//

#import <YTKNetwork/YTKBaseRequest.h>

@interface YTKBaseRequest (HDHessianRequest)

@property (nonatomic, copy) NSString *hd_remoteMethodName;
@property (nonatomic, copy) NSArray *hd_parameters;

/**
 *  远程方法映射
 *
 *  @{@"本地方法名":@"远程方法名"};
 */
+ (NSDictionary *)hd_remoteMethodMap;

@end
