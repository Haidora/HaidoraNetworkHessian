//
//  HDHessianRequest.m
//  Pods
//
//  Created by Dailingchi on 15/10/22.
//
//

#import "HDHessianRequest.h"
#import "HDHessianRequest+HDPrivate.h"
#import "HDHessianRequestSerializer.h"
#import "HDHessianResponseSerializer.h"

@implementation HDHessianRequest

- (NSString *)requesetURLString
{
    return [NSString stringWithFormat:@"/%@", NSStringFromClass([self class])];
}

- (HDRequestMethod)requestMethod
{
    return HDRequestMethodPost;
}

- (Class)requestSerializerClass
{
    return [HDHessianRequestSerializer class];
}

- (Class)responseSerializerClass
{
    return [HDHessianResponseSerializer class];
}

- (id)requestArgument
{
    NSString *methodName = self.hd_remoteMethodName;
    NSDictionary *methodMap = [[self class] hd_remoteMethodMap];
    if (methodMap && [methodMap objectForKey:methodName])
    {
        methodName = [methodMap objectForKey:methodName];
    }
    NSAssert(methodName, @"方法名不能为空");

    NSMutableArray *requestArgument = [NSMutableArray array];
    [requestArgument addObject:methodName];
    [requestArgument addObjectsFromArray:self.hd_parameters];
    return requestArgument;
}

@end
