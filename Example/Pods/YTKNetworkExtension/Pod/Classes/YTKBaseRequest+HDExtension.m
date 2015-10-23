//
//  YTKBaseRequest+HDExtension.m
//  Pods
//
//  Created by Dailingchi on 15/10/21.
//
//

#import "YTKBaseRequest+HDExtension.h"

@implementation YTKBaseRequest (HDExtension)

- (Class)hd_requestSerializerClass
{
    return nil;
}

- (Class)hd_responseSerializerClass
{
    return nil;
}

- (BOOL)hd_validate
{
    return YES;
}

@end
