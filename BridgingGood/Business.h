//
//  Business.h
//  BridgingGood
//
//  Created by ChunJong Park on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Business : NSObject 
//{
//    NSString * name;
//    NSString * address;
//    NSString * charity;
//    float latitude;
//    float longitude;
//    float distanceAway;
//}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *charity;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic) float distanceAway;

@end
