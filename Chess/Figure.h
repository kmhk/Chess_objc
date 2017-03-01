//
//  Figure.h
//  Chess
//
//  Created by Admin on 15/11/14.
//  Copyright (c) 2014 KMHK. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef Chess_Figure_h
#define Chess_Figure_h

@interface Figure: NSObject

@property (nonatomic, readwrite) int tag,x,y,type;
@property (nonatomic, readwrite) BOOL alive;
@property (nonatomic, readwrite) NSString *color;

+(instancetype)myInit:(int)type y:(int)x type:(int)y color:(NSString*)color;
-(void)moveTo:(int)newX y:(int)newY;
-(void)listStats;
-(NSString*)listName;
-(NSString*)listColor;
-(BOOL)existInTheseCoords:(long int)currentTag;
-(void)kill;

@end

#endif
