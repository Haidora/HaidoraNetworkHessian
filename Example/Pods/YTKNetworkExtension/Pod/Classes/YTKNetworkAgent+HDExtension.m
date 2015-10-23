//
//  YTKNetworkAgent+HDExtension.m
//  Pods
//
//  Created by Dailingchi on 15/10/21.
//
//

#import "YTKNetworkAgent+HDExtension.h"
#import <Aspects.h>

#import "YTKNetworkConfig.h"
#import "YTKNetworkPrivate.h"
#import "YTKBaseRequest+HDExtension.h"

@interface YTKNetworkAgent (HDExtensionPrivate)

- (void)handleRequestResult:(AFHTTPRequestOperation *)operation;
- (void)addOperation:(YTKBaseRequest *)request;
- (BOOL)checkResult:(YTKBaseRequest *)request;

@end

@implementation YTKNetworkAgent (HDExtension)

+ (void)load
{
    // hook method
    [self aspect_hookSelector:@selector(addRequest:)
                  withOptions:AspectPositionInstead
                   usingBlock:^(id<AspectInfo> info, YTKBaseRequest *request) {
                     [((YTKNetworkAgent *)[info instance])hd_addRequest:request];
                   } error:NULL];

    NSError *error;
    [self aspect_hookSelector:@selector(checkResult:)
                  withOptions:AspectPositionAfter
                   usingBlock:^(id<AspectInfo> info, YTKBaseRequest *request) {
                     BOOL result = NO;
                     [info.originalInvocation getReturnValue:&result];
                     if (result)
                     {
                         result = [request hd_validate];
                         [info.originalInvocation setReturnValue:&result];
                     }
                   } error:&error];
    if (error)
    {
        NSLog(@"%@", error);
    }
}

- (void)hd_addRequest:(YTKBaseRequest *)request
{
    // hook _manager
    AFHTTPRequestOperationManager *_manager = [self valueForKey:@"_manager"];

    YTKRequestMethod method = [request requestMethod];
    NSString *url = [self buildRequestUrl:request];
    id param = request.requestArgument;
    AFConstructingBlock constructingBlock = [request constructingBodyBlock];

    if (request.requestSerializerType == YTKRequestSerializerTypeHTTP)
    {
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    else if (request.requestSerializerType == YTKRequestSerializerTypeJSON)
    {
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }

    if (request.hd_requestSerializerClass &&
        [request.hd_requestSerializerClass isSubclassOfClass:[AFHTTPRequestSerializer class]])
    {
        _manager.requestSerializer = [request.hd_requestSerializerClass serializer];
    }
    if (request.hd_responseSerializerClass &&
        [request.hd_responseSerializerClass isSubclassOfClass:[AFHTTPResponseSerializer class]])
    {
        _manager.responseSerializer = [request.hd_responseSerializerClass serializer];
    }

    _manager.requestSerializer.timeoutInterval = [request requestTimeoutInterval];

    // if api need server username and password
    NSArray *authorizationHeaderFieldArray = [request requestAuthorizationHeaderFieldArray];
    if (authorizationHeaderFieldArray != nil)
    {
        [_manager.requestSerializer
            setAuthorizationHeaderFieldWithUsername:(NSString *)
                                                        authorizationHeaderFieldArray.firstObject
                                           password:(NSString *)
                                                        authorizationHeaderFieldArray.lastObject];
    }

    // if api need add custom value to HTTPHeaderField
    NSDictionary *headerFieldValueDictionary = [request requestHeaderFieldValueDictionary];
    if (headerFieldValueDictionary != nil)
    {
        for (id httpHeaderField in headerFieldValueDictionary.allKeys)
        {
            id value = headerFieldValueDictionary[httpHeaderField];
            if ([httpHeaderField isKindOfClass:[NSString class]] &&
                [value isKindOfClass:[NSString class]])
            {
                [_manager.requestSerializer setValue:(NSString *)value
                                  forHTTPHeaderField:(NSString *)httpHeaderField];
            }
            else
            {
                YTKLog(
                    @"Error, class of key/value in headerFieldValueDictionary should be NSString.");
            }
        }
    }

    // if api build custom url request
    NSURLRequest *customUrlRequest = [request buildCustomUrlRequest];
    if (customUrlRequest)
    {
        AFHTTPRequestOperation *operation =
            [[AFHTTPRequestOperation alloc] initWithRequest:customUrlRequest];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,
                                                   id responseObject) {
          [self handleRequestResult:operation];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [self handleRequestResult:operation];
        }];
        request.requestOperation = operation;
        operation.responseSerializer = _manager.responseSerializer;
        [_manager.operationQueue addOperation:operation];
    }
    else
    {
        if (method == YTKRequestMethodGet)
        {
            if (request.resumableDownloadPath)
            {
                // add parameters to URL;
                NSString *filteredUrl =
                    [YTKNetworkPrivate urlStringWithOriginUrlString:url appendParameters:param];

                NSURLRequest *requestUrl =
                    [NSURLRequest requestWithURL:[NSURL URLWithString:filteredUrl]];
                AFDownloadRequestOperation *operation = [[AFDownloadRequestOperation alloc]
                    initWithRequest:requestUrl
                         targetPath:request.resumableDownloadPath
                       shouldResume:YES];
                [operation
                    setProgressiveDownloadProgressBlock:request.resumableDownloadProgressBlock];
                [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,
                                                           id responseObject) {
                  [self handleRequestResult:operation];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [self handleRequestResult:operation];
                }];
                request.requestOperation = operation;
                [_manager.operationQueue addOperation:operation];
            }
            else
            {
                request.requestOperation = [_manager GET:url
                    parameters:param
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      [self handleRequestResult:operation];
                    }
                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      [self handleRequestResult:operation];
                    }];
            }
        }
        else if (method == YTKRequestMethodPost)
        {
            if (constructingBlock != nil)
            {
                request.requestOperation = [_manager POST:url
                    parameters:param
                    constructingBodyWithBlock:constructingBlock
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      [self handleRequestResult:operation];
                    }
                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      [self handleRequestResult:operation];
                    }];
            }
            else
            {
                request.requestOperation = [_manager POST:url
                    parameters:param
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      [self handleRequestResult:operation];
                    }
                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      [self handleRequestResult:operation];
                    }];
            }
        }
        else if (method == YTKRequestMethodHead)
        {
            request.requestOperation = [_manager HEAD:url
                parameters:param
                success:^(AFHTTPRequestOperation *operation) {
                  [self handleRequestResult:operation];
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [self handleRequestResult:operation];
                }];
        }
        else if (method == YTKRequestMethodPut)
        {
            request.requestOperation = [_manager PUT:url
                parameters:param
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [self handleRequestResult:operation];
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [self handleRequestResult:operation];
                }];
        }
        else if (method == YTKRequestMethodDelete)
        {
            request.requestOperation = [_manager DELETE:url
                parameters:param
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [self handleRequestResult:operation];
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [self handleRequestResult:operation];
                }];
        }
        else if (method == YTKRequestMethodPatch)
        {
            request.requestOperation = [_manager PATCH:url
                parameters:param
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [self handleRequestResult:operation];
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [self handleRequestResult:operation];
                }];
        }
        else
        {
            YTKLog(@"Error, unsupport method type");
            return;
        }
    }

    YTKLog(@"Add request: %@", NSStringFromClass([request class]));
    [self addOperation:request];
}

@end
