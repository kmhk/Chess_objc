//
//  myXYPoint.m
//  Chess
//
//  Created by Admin on 22/11/14.
//  Copyright (c) 2014 KMHK. All rights reserved.
//

#import "myXYPoint.h"

#ifndef Chess_myXYPoint_m
#define Chess_myXYPoint_m

@implementation myXYPoint

@synthesize x,y;

+(instancetype)myInit:(int)x :(int)y
{
    myXYPoint *tempInstance = [[myXYPoint alloc]init];
    [tempInstance setX:x];
    [tempInstance setY:y];
    return tempInstance;
}

+(instancetype)myInitWithTag:(int)tag
{
    int x = tag%8;
    if (x == 0) {
        x = 8;
    }
    int y = ((tag - x)/8) + 1;
    myXYPoint *tempInstance = [myXYPoint myInit:x :y];
    return tempInstance;
}

-(int)convertToTag
{
    return (8*([self y] - 1) + [self x]);
}

-(void)setToX:(int)xCoord andY:(int)yCoord
{
    [self setX:xCoord];
    [self setY:yCoord];
}

@end

#endif
