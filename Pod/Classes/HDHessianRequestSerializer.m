//
//  HDHessianRequestSerializer.m
//  Pods
//
//  Created by Dailingchi on 15/10/22.
//
//

#import "HDHessianRequestSerializer.h"
#import "BBSHessianCall.h"

@implementation HDHessianRequestSerializer

+ (instancetype)serializer
{
    return [self serializerWithVersion:HDHeesianVersion1];
}

+ (instancetype)serializerWithVersion:(HDHeesianVersion)version
{
    HDHessianRequestSerializer *serializer = [[self alloc] init];
    serializer.version = version;
    return serializer;
}

#pragma mark
#pragma mark AFURLRequestSerializer

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(request);

    if ([self.HTTPMethodsEncodingParametersInURI
            containsObject:[[request HTTPMethod] uppercaseString]])
    {
        return [super requestBySerializingRequest:request withParameters:parameters error:error];
    }

    NSMutableURLRequest *mutableRequest = [request mutableCopy];

    [self.HTTPRequestHeaders
        enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL *__unused stop) {
          if (![request valueForHTTPHeaderField:field])
          {
              [mutableRequest setValue:value forHTTPHeaderField:field];
          }
        }];

    if (parameters)
    {
        if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"])
        {
            [mutableRequest setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
        }

        if ([parameters isKindOfClass:[NSArray class]] && ((NSArray *)parameters).count > 0)
        {
            NSString *methodName = [((NSArray *)parameters)firstObject];
            NSMutableArray *mutableParameters = [parameters mutableCopy];
            // Hessian编码
            BBSHessianCall *hessianCall =
                [[BBSHessianCall alloc] initWithRemoteMethodName:methodName];
            [mutableParameters removeObjectAtIndex:0];
            [hessianCall setParameters:mutableParameters];
            [mutableRequest setHTTPBody:[hessianCall data]];

//日志
#ifdef DEBUG
            NSLog(@"request method: %@", methodName);
            NSLog(@"request parameter:\n");
            [mutableParameters
                enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                  NSLog(@"paramter%@:%@\n", @(idx), obj);
                }];
#endif
        }
    }

    return mutableRequest;
}

#pragma mark
#pragma mark NSSecureCoding

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (!self)
    {
        return nil;
    }
    self.version = [[decoder
        decodeObjectOfClass:[NSNumber class]
                     forKey:NSStringFromSelector(@selector(version))] unsignedIntegerValue];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    [coder encodeInteger:self.version forKey:NSStringFromSelector(@selector(version))];
}

#pragma mark
#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    HDHessianRequestSerializer *serializer = [super copyWithZone:zone];
    serializer.version = self.version;
    return serializer;
}

@end