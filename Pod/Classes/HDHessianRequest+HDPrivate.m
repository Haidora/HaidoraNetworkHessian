//
//  HDHessianRequest+HDPrivate.m
//  Pods
//
//  Created by Dailingchi on 15/11/2.
//
//

#import "HDHessianRequest+HDPrivate.h"
#import <objc/runtime.h>

static char *kHDHessianRequest_remoteMethodName = "kHDHessianRequest_remoteMethodName";
static char *kHDHessianRequest_parameters = "kHDHessianRequest_parameters";

@implementation HDHessianRequest (HDPrivate)

+ (NSDictionary *)hd_remoteMethodMap
{
    return nil;
}

#pragma mark
#pragma mark Getter/Setter

- (void)setHd_remoteMethodName:(NSString *)hd_remoteMethodName
{
    objc_setAssociatedObject(self, &kHDHessianRequest_remoteMethodName, hd_remoteMethodName,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)hd_remoteMethodName
{
    return objc_getAssociatedObject(self, &kHDHessianRequest_remoteMethodName);
}

- (void)setHd_parameters:(NSArray *)hd_parameters
{
    objc_setAssociatedObject(self, &kHDHessianRequest_parameters, hd_parameters,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSArray *)hd_parameters
{
    return objc_getAssociatedObject(self, &kHDHessianRequest_parameters);
}

@end
