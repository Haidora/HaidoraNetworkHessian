//
//  HDHessianResponseSerializer.m
//  Pods
//
//  Created by Dailingchi on 15/10/22.
//
//

#import "BBSHessianResult.h"
#import "HDHessianResponseSerializer.h"
#import "HDNetworkConfig+HDHessianSecurity.h"

@implementation HDHessianResponseSerializer

- (instancetype)init
{
    self = [super init];
    if (!self)
    {
        return nil;
    }

    self.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/x-hessian", nil];

    return self;
}

+ (instancetype)serializer
{
    return [self serializerWithVersion:HDHeesianVersion1];
}

+ (instancetype)serializerWithVersion:(HDHeesianVersion)version
{
    HDHessianResponseSerializer *serializer = [[self alloc] init];
    serializer.version = version;
    return serializer;
}

static BOOL AFErrorOrUnderlyingErrorHasCodeInDomain(NSError *error, NSInteger code,
                                                    NSString *domain)
{
    if ([error.domain isEqualToString:domain] && error.code == code)
    {
        return YES;
    }
    else if (error.userInfo[NSUnderlyingErrorKey])
    {
        return AFErrorOrUnderlyingErrorHasCodeInDomain(error.userInfo[NSUnderlyingErrorKey], code,
                                                       domain);
    }

    return NO;
}

#pragma mark - AFURLResponseSerialization

- (id)responseObjectForResponse:(NSHTTPURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    //    YTKLog(@"response:%@", response);
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error])
    {
        if (!error ||
            AFErrorOrUnderlyingErrorHasCodeInDomain(*error, NSURLErrorBadServerResponse,
                                                    AFURLResponseSerializationErrorDomain))
        {
            return nil;
        }
    }
    NSData *tempData = data;
    if (nil != [HDNetworkConfig sharedInstance].securityClass)
    {
        tempData = [[HDNetworkConfig sharedInstance].securityClass securityDecodedRequestData:data];
    }

    BBSHessianResult *hessianResponse = [[BBSHessianResult alloc] initForReadingWithData:tempData];
    //    [response setRemoteClassPrefix:remoteClassPrefix];
    id decodedObject = [hessianResponse resultValue];
    // TODO:检查hessian错误
    if ([decodedObject isKindOfClass:[NSError class]])
    {
        *error = decodedObject;
        return nil;
    }

    return decodedObject;
}
@end
