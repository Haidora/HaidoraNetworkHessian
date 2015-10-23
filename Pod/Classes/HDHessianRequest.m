//
//  HDHessianRequest.m
//  Pods
//
//  Created by Dailingchi on 15/10/22.
//
//

#import "HDHessianRequest.h"
#import <YTKBaseRequest+HDExtension.h>

#import "HDHessianRequestSerializer.h"
#import "HDHessianResponseSerializer.h"

@implementation HDHessianRequest

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"/%@", NSStringFromClass([self class])];
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (Class)hd_requestSerializerClass
{
    return [HDHessianRequestSerializer class];
}

- (Class)hd_responseSerializerClass
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

- (BOOL)hd_validate
{
    return self.requestOperation.error ? NO : YES;
}

@end
