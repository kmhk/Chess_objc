//
//  Figure.m
//  Chess
//
//  Created by Admin on 15/11/14.
//  Copyright (c) 2014 KMHK. All rights reserved.
//

#import "Figure.h"

#ifndef Chess_Figure_m
#define Chess_Figure_m

@implementation Figure

@synthesize tag,x,y,type,alive,color;

+(instancetype)myInit:(int)x y:(int)y type:(int)type color:(NSString*)color
{
    Figure *tempInstance = [[Figure alloc] init];
    if ([tempInstance isKindOfClass:[Figure class]] == YES) {
        [tempInstance setType:(int)type];
        [tempInstance setX:(int)x];
        [tempInstance setY:(int)y];
        [tempInstance setAlive:YES];
        int tempTag = 8*(y-1) + x;
        [tempInstance setTag:tempTag];
        [tempInstance setColor:color];

        //NSLog(@"Figure created: x:%i, y:%i, type: %@ %@, tag:%i",x, y, [tempInstance color], [tempInstance listName],tempTag);
    }
    return tempInstance;
}

-(void)moveTo:(int)newX y:(int)newY
{
    int oldX,oldY;
    oldX = [self x];
    oldY = [self y];
    [self setX:newX];
    [self setY:newY];
    NSLog(@"Move command: %@ %@ from (%i;%i) to (%i;%i)",[self color],[self listName],oldX,oldY,newX,newY);
}

-(void)listStats
{
    NSLog(@"X = %i, Y = %i, type = %i, tag = %i",[self x],[self y],[self type], [self tag]);
}

-(NSString*)listName
{
    NSString *thingToReturn = @"";
    switch([self type])
    {
        case 0:
            thingToReturn = @"Pawn";
            break;
        case 1:
            thingToReturn = @"Rook";
            break;
        case 2:
            thingToReturn = @"Knight";
            break;
        case 3:
            thingToReturn = @"Bishop";
            break;
        case 4:
            thingToReturn = @"Queen";
            break;
        case 5:
            thingToReturn = @"King";
            break;
        default:
            thingToReturn = @"don't know such figure type";
            NSLog(@"Error! wrong figure type (out of range 0-5)");
            break;
    }
    //NSLog(@"This is %@",thingToReturn);
    return thingToReturn;
}

-(NSString*)listColor
{
    NSString* currentColor;
    currentColor = [self color];
    return currentColor;
}

-(BOOL)existInTheseCoords:(long int)currentTag
{
    if ([self tag] == currentTag) {
        return YES;
    }
    else {
        return NO;
    }
}

-(void)kill
{
    [self setAlive:NO];
    [self setX:100];
    [self setY:100];
    NSLog(@"%@ %@ died.",[self listColor],[self listName]);
}

@end

#endif
