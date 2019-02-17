//
//  Counter.m
//  uPortMobile
//
//  Created by Ryan Robison on 2/17/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "React/RCTBridgeModule.h"

@interface RCT_EXTERN_MODULE(Counter, NSObject)

//RCT_EXTERN_METHOD(getAddress: (RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(loadOnStartUp)
RCT_EXTERN_METHOD(setAddress: ([UInt8])add)

@end
