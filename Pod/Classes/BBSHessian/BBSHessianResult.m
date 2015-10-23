//
//  BBSHessianResponse.m
//  HessianObjC

// Copyright Byron Wright, Blue Bear Studio
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "BBSHessianResult.h"
#import "BBSHessianDecoder.h"
#import "BBSHessianObjCDefines.h"

@implementation BBSHessianResult

- (void)setRemoteClassPrefix:(NSString *)aRemoteClassPrefix
{
    remoteClassPrefix = aRemoteClassPrefix;
}

- (id)initForReadingWithData:(NSData *)someData
{
    if ((self = [super init]) != nil)
    {
        data = someData;
    }
    return self;
}

- (id)resultValue
{
    if (resultValue == nil)
    {
        // decode data
        // the actual return object should be the data between the 'r' and version number
        // and the end character 'z'
        // check first characters for valid return
        uint8_t *returnHeader = malloc(sizeof(uint8_t) * 4);
        if (!returnHeader)
        {
            NSLog(@"could alloc memory for result");
            return nil;
        }
        memset(returnHeader, 0, 4);
        [data getBytes:returnHeader length:3];
        if (!(returnHeader[0] == 'r'))
        {
            free(returnHeader);
            NSDictionary *userInfo =
                [NSDictionary dictionaryWithObject:@"Malformed response from server"
                                            forKey:NSLocalizedDescriptionKey];
            return [NSError errorWithDomain:BBSHessianObjCError
                                       code:BBSHessianProtocolBadReplyError
                                   userInfo:userInfo];
        }
        majorVersion = returnHeader[1];
        minorVersion = returnHeader[2];
        free(returnHeader);
        void *bytes = malloc(sizeof(uint8_t) * ([data length] - 4));
        if (!bytes)
        {
            NSLog(@"could alloc memory for result");
            return nil;
        }
        [data getBytes:bytes range:NSMakeRange(3, [data length] - 4)];
        // calling dataWithBytesNoCopy allows the resultsValueData to free the bytes that where
        // malloced and is more effecient
        NSData *resultValueData = [NSData dataWithBytesNoCopy:bytes length:[data length] - 4];
        BBSHessianDecoder *decoder =
            [[BBSHessianDecoder alloc] initForReadingWithData:resultValueData];
        [decoder setRemoteClassPrefix:remoteClassPrefix];
        id obj = [decoder decodedObject];
        // TODO: ideally we should make sure the last char in the stream after the result is a 'z'
        // I am ingoring this for now
        resultValue = obj;
    }
    return resultValue;
}

- (void)dealloc
{
    resultValue = nil;
}

@end
