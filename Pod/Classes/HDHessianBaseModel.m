//
//  HDHessianBaseModel.m
//  Pods
//
//  Created by Dailingchi on 15/11/3.
//
//

#import "HDHessianBaseModel.h"
#import <objc/runtime.h>

@implementation HDHessianBaseModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self encodeWithCoder:aCoder withClass:[self class]];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self)
    {
        [self decodeWithCoder:aDecoder withClass:[self class]];
    }
    return self;
}

- (void)decodeWithCoder:(NSCoder *)aDecoder withClass:(Class)aDecoderClass
{
    Class superClass = [aDecoderClass superclass];
    if (![superClass isEqual:[NSObject class]])
    {
        [self decodeWithCoder:aDecoder withClass:superClass];
    }
    unsigned count;
    objc_property_t *properties = class_copyPropertyList(aDecoderClass, &count);
    for (unsigned i = 0; i < count; i++)
    {
        NSString *remoteKey = [NSString stringWithUTF8String:property_getName(properties[i])];
        // if need  replace
        __block NSString *localKey = remoteKey;
        if ([_replaceKey.allValues containsObject:remoteKey])
        {
            [_replaceKey enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj,
                                                             BOOL *_Nonnull stop) {
              if ([obj isEqualToString:remoteKey])
              {
                  localKey = key;
                  *stop = YES;
              }
            }];
        }
        if ([aDecoder decodeObjectForKey:remoteKey] != nil)
        {
            [self setValue:[aDecoder decodeObjectForKey:remoteKey] forKey:localKey];
        }
    }
    free(properties);
}

- (void)encodeWithCoder:(NSCoder *)aCoder withClass:(Class)codeClass
{
    Class superClass = [codeClass superclass];
    if (![superClass isEqual:[NSObject class]])
    {
        [self encodeWithCoder:aCoder withClass:superClass];
    }
    unsigned count;
    objc_property_t *properties = class_copyPropertyList(codeClass, &count);
    for (unsigned i = 0; i < count; i++)
    {
        NSString *localKey = [NSString stringWithUTF8String:property_getName(properties[i])];
        // if need  replace
        NSString *remoteKey = _replaceKey[localKey];
        if (!remoteKey)
        {
            remoteKey = localKey;
        }
        // ignore system
        if (![localKey isEqualToString:@"hash"] && ![localKey isEqualToString:@"superclass"] &&
            ![localKey isEqualToString:@"description"] &&
            ![localKey isEqualToString:@"debugDescription"])
        {
            if ([self valueForKey:localKey] != nil)
            {
                [aCoder encodeObject:[self valueForKey:localKey] forKey:remoteKey];
            }
        }
    }
    free(properties);
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"not found key:%@ with Value:%@", key, value);
}

#pragma mark
#pragma mark Getter

- (NSMutableDictionary *)replaceKey
{
    if (nil == _replaceKey)
    {
        _replaceKey = [NSMutableDictionary dictionary];
    }
    return _replaceKey;
}

@end
