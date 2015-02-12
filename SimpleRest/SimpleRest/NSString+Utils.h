//
//  NSString+Utils.h
//  SimpleRest
//
//  Created by Tom Jay on 2/10/15.
//  Copyright (c) 2015 Tom Jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)

-(id) jsonStringToObject;

-(NSData *) stringToData;

-(NSData *) base64StringToData;



@end
