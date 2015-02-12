//
//  NSDictionary+Utils.m
//  SimpleRest
//
//  Created by Tom Jay on 2/10/15.
//  Copyright (c) 2015 Tom Jay. All rights reserved.
//

#import "NSDictionary+Utils.h"

@implementation NSDictionary (MAPUtils)

-(NSString *) objectToJSonString {
    
    NSError *error;
    
    NSData *result = [NSJSONSerialization dataWithJSONObject:self options:NSJSONReadingAllowFragments|NSJSONWritingPrettyPrinted error:&error];
    
    if (!result) {
        NSLog(@"%@", error.description);
    }
    
    return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
}


@end
