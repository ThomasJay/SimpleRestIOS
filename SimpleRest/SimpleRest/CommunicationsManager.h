//
//  CommunicationsManager.h
//  SimpleRest
//
//  Created by Tom Jay on 2/10/15.
//  Copyright (c) 2015 Tom Jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommunicationsManager : NSObject

+(CommunicationsManager *) sharedCommunicationsManager;


- (void) getUserDataForParams:(NSDictionary *)params callback:(void (^)(NSError *error, NSDictionary *values))callBack;


@end
