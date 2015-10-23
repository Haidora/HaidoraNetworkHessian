//
//  YTKBaseRequest+HDHessianRequest.m
//  Pods
//
//  Created by Dailingchi on 15/10/22.
//
//

#import "YTKBaseRequest+HDHessianRequest.h"
#import <objc/runtime.h>

static char *kHDYTKBaseRequest_remoteMethodName = "hd_remoteMethodName";
static char *kHDYTKBaseRequest_parameters = "kHDYTKBaseRequest_parameters";

@implementation YTKBaseRequest (HDHessianRequest)


+ (NSDictionary *)hd_remoteMethodMap
{
    return nil;
}


#pragma mark
#pragma mark Getter/Setter

- (void)setHd_remoteMethodName:(NSString *)hd_remoteMethodName
{
    objc_setAssociatedObject(self, &kHDYTKBaseRequest_remoteMethodName, hd_remoteMethodName,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)hd_remoteMethodName
{
    return objc_getAssociatedObject(self, &kHDYTKBaseRequest_remoteMethodName);
}

- (void)setHd_parameters:(NSArray *)hd_parameters
{
    objc_setAssociatedObject(self, &kHDYTKBaseRequest_parameters, hd_parameters,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSArray *)hd_parameters
{
    return objc_getAssociatedObject(self, &kHDYTKBaseRequest_parameters);
}

@end
