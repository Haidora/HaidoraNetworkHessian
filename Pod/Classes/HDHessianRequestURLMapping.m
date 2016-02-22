//
//  HDHessianRequestURLMapping.m
//  Pods
//
//  Created by Dailingchi on 16/2/22.
//
//

#import "HDHessianRequestURLMapping.h"

@interface HDHessianRequestURLMapping ()

@property (nonatomic, strong) NSMutableDictionary *requestURLMapping;

@end

@implementation HDHessianRequestURLMapping

+ (HDHessianRequestURLMapping *)sharedInstance
{
    {
        static HDHessianRequestURLMapping *sharedInstance = nil;
        static dispatch_once_t predicate;
        dispatch_once(&predicate, ^{
          sharedInstance = [[self alloc] init];
        });
        return sharedInstance;
    }
}

+ (NSString *)URLStringForRequest:(NSString *)requestName
{
    return [HDHessianRequestURLMapping sharedInstance].requestURLMapping[requestName];
}

+ (void)addURLString:(NSString *)URLString forRequest:(NSString *)requestName
{
    if (URLString.length > 0 && requestName.length > 0)
    {
        [HDHessianRequestURLMapping sharedInstance].requestURLMapping[requestName] = URLString;
    }
    else
    {
    }
}

+ (void)removeURLStringForRequest:(NSString *)requestName
{
    if (requestName.length > 0)
    {
        [[HDHessianRequestURLMapping sharedInstance]
                .requestURLMapping removeObjectForKey:requestName];
    }
    else
    {
    }
}

- (NSMutableDictionary *)requestURLMapping
{
    if (nil == _requestURLMapping)
    {
        _requestURLMapping = [[NSMutableDictionary alloc] init];
    }
    return _requestURLMapping;
}

@end
