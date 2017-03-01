//
//  myXYPoint.h
//  Chess
//
//  Created by Admin on 22/11/14.
//  Copyright (c) 2014 KMHK. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef Chess_myXYPoint_h
#define Chess_myXYPoint_h

@interface myXYPoint : NSObject

@property int x,y;

+(instancetype) myInit:(int)x :(int)y;
+(instancetype) myInitWithTag:(int)tag;
-(int)convertToTag;
-(void)setToX:(int)xCoord andY:(int)yCoord;

@end

#endif
