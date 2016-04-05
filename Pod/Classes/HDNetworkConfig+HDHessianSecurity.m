//
//  HDNetworkConfig+HDHessianSecurity.m
//  Pods
//
//  Created by Dailingchi on 16/4/5.
//
//

#import "HDNetworkConfig+HDHessianSecurity.h"
#import <objc/runtime.h>

@implementation HDNetworkConfig (HDHessianSecurity)

- (void)setSecurityClass:(Class<HDHessianSecurity>)securityClass
{
    objc_setAssociatedObject(self, @selector(setSecurityClass:), securityClass,
                             OBJC_ASSOCIATION_ASSIGN);
}

- (Class<HDHessianSecurity>)securityClass
{
    return objc_getAssociatedObject(self, @selector(setSecurityClass:));
}

@end
