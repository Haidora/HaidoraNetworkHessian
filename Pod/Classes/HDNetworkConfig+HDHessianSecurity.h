//
//  HDNetworkConfig+HDHessianSecurity.h
//  Pods
//
//  Created by Dailingchi on 16/4/5.
//
//

#import <HaidoraNetwork/HaidoraNetwork.h>

/**
 *  加密配置
 */
@protocol HDHessianSecurity <NSObject>

@required
//请求加密
+ (NSData *)securityEncodedRequestData:(NSData *)data;

//返回解密
+ (NSData *)securityDecodedRequestData:(NSData *)data;

@end

@interface HDNetworkConfig (HDHessianSecurity)

@property (nonatomic, assign, readwrite) Class<HDHessianSecurity> securityClass;

@end
