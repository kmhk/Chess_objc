//
//  ViewController.m
//  Chess
//
//  Created by Admin on 15/11/14.
//  Copyright (c) 2014 KMHK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "Figure.h"
#import "myXYPoint.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize myDisplay, ImageView1, ImageView2, ImageView3, ImageView4, ImageView5, ImageView6, ImageView7, ImageView8, ImageView9, ImageView10, ImageView11, ImageView12, ImageView13, ImageView14, ImageView15, ImageView16, ImageView17, ImageView18, ImageView19, ImageView20, ImageView21, ImageView22, ImageView23, ImageView24, ImageView25, ImageView26, ImageView27, ImageView28, ImageView29, ImageView30, ImageView31, ImageView32, ImageView33, ImageView34, ImageView35, ImageView36, ImageView37, ImageView38, ImageView39, ImageView40, ImageView41, ImageView42, ImageView43, ImageView44, ImageView45, ImageView46, ImageView47, ImageView48, ImageView49, ImageView50, ImageView51, ImageView52, ImageView53, ImageView54, ImageView55, ImageView56, ImageView57, ImageView58, ImageView59, ImageView60, ImageView61, ImageView62, ImageView63, ImageView64, pawn1, pawn2, pawn3, pawn4, pawn5, pawn6, pawn7, pawn8, pawnBlack1, pawnBlack2, pawnBlack3, pawnBlack4, pawnBlack5, pawnBlack6, pawnBlack7, pawnBlack8, rook1, rook2, rookBlack1, rookBlack2, knight1, knight2, knightBlack1, knightBlack2, bishop1, bishop2, bishopBlack1, bishopBlack2, queen, queenBlack, king, kingBlack, initializationTrigger,imageTapTrigger,cells,figures,gestureArray,mainButton,playerTurn,turnProgress, figurePositionsWhite, figurePositionsBlack, possibleFigureMoves,figureToMove, log;

-(IBAction)DebugClick:(UIButton *)sender
{
    NSLog(@"_______'figurePositionsWhite/Black' dump:_______");
    for (int i=0;i<16;i++) {
        NSLog(@"%i. white: %i;%i, black: %i;%i",i+1,[(myXYPoint*)figurePositionsWhite[i] x],[(myXYPoint*)figurePositionsWhite[i] y], [(myXYPoint*)figurePositionsBlack[i] x], [(myXYPoint*)figurePositionsBlack[i] y]);
    }
    NSLog(@"_______Actual figure positions_______");
    for (int i=0;i<16;i++) {                            //32
        NSLog(@"%i. %@ %@: {%i;%i}, %@ %@: {%i;%i}",i+1,[(Figure*)figures[i] listColor], [(Figure*)figures[i] listName], [(Figure*)figures[i] x], [(Figure*)figures[i] y],[(Figure*)figures[i+16] listColor], [(Figure*)figures[i+16] listName], [(Figure*)figures[i+16] x], [(Figure*)figures[i+16] y]);
    }
}

-(IBAction)click
{
    if (initializationTrigger == 0)
    {
        // change button name
        [mainButton setTitle:@"Restart" forState:UIControlStateNormal];
        myDisplay.text = @"Let the game begin!";
        log.text = @"Start";
        
        // imageView array
        cells = [self createImageViewArray];
        
        // gesture recognizer array
        gestureArray = [self createGestureRecognizerArray];
        
        // assigning each gesture to class method and each cell to gesture
        for (int i = 0;i < 64;i++) {
            gestureArray[i] = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
            [cells[i] addGestureRecognizer:gestureArray[i]];
            [(UIView*)cells[i] setTag:i+1];
        }
    
        // assigning figures
        [self initFigures];
        
        // packing figures into array
        figures = [[NSMutableArray alloc] initWithObjects:pawn1,pawn2,pawn3,pawn4,pawn5,pawn6,pawn7,pawn8,rook1,rook2,knight1,knight2,bishop1,bishop2,queen,king,pawnBlack1,pawnBlack2,pawnBlack3,pawnBlack4,pawnBlack5,pawnBlack6,pawnBlack7,pawnBlack8,rookBlack1,rookBlack2,knightBlack1,knightBlack2,bishopBlack1,bishopBlack2,queenBlack,kingBlack,nil];
        
        // clear all cells and put all figures
        [self updateBoard];
        
        initializationTrigger = 1;
        NSLog(@"main init trigger = %i",initializationTrigger);
    
    }
    
    // return the game to the starting point of the app
    else if (initializationTrigger == 1) {
        
        [self returnFiguresToBasicPositions];
        [self updateBoard];
        [playerTurn setString:@"white"];
        log.text = @"Start";

        myDisplay.text = @"White player turn";
        imageTapTrigger = 0;
        //[mainButton setTitle:@"Restart" forState:UIControlStateNormal];
        //initializationTrigger = YES;
        NSLog(@"main init trigger = %i\n________________________________________________________",initializationTrigger);
    }
}

-(void)imageTap:(id)sender
{
    // imageTapTrigger: 0 - choosing a figure, 1 - checking and moving
    
    long int currentTag = [(UITapGestureRecognizer*)sender view].tag;
    
    if (imageTapTrigger == 0) {
        long int thisTag = [(UITapGestureRecognizer*)sender view].tag;
        NSLog(@"______________________");
        NSLog(@" ");
        NSLog(@"image tapped, tag = %li",thisTag);
        NSString *chosenCellState = [[NSString alloc]  init];
        
        // part #1: analyze tapped cell (if not a figure, do nothing)
        Figure *currentFigure;
        chosenCellState = [self getCellStateAtTag:currentTag];
        NSString *currentFigureColor, *currentFigureType;
        possibleFigureMoves = [[NSMutableArray alloc]init];
    
        // checking cell type
        if ([chosenCellState isEqualToString:@"figure"] == YES) {
            
                //get the figure in order to analyze (first - by color, then - by type for possible turns array)
                currentFigure = [self getFigureAtTag:(int)currentTag];
                currentFigureColor = [[NSString alloc] initWithString:[currentFigure listColor]];
                currentFigureType = [[NSString alloc] initWithString:[currentFigure listName]];
                NSLog(@"You chose a figure! (%@ %@)",currentFigureColor,currentFigureType);
            
            if ([currentFigure alive] == YES) {
            
                // check for player turn
                if ([currentFigureColor isEqualToString:playerTurn] == YES) {
                    NSLog(@"Current figure coordinates are: {%i; %i}",[currentFigure x],[currentFigure y]);
                
                    // checking for possible moves
                    possibleFigureMoves = [self getPossibleTurnCoordsForFigure:currentFigure];
                    for (unsigned long i = 0;i < [possibleFigureMoves count];i++) {
                        NSLog(@"possibleFigureMoves: %lu: x:%i, y:%i",i+1,[(myXYPoint*)possibleFigureMoves[i] x], [(myXYPoint*)possibleFigureMoves[i] y]);
                    }
                
                    // paint possible moves on board
                    [self showPossibleFigureMovesFromArray:possibleFigureMoves];
                
                    // setting this in order to proceed to the next click
                    if ([possibleFigureMoves count] > 0) {
                        imageTapTrigger = 1;
                        figureToMove = currentFigure;
                    }
                }
                else if ([currentFigureColor isEqualToString:playerTurn] == NO) {
                    NSLog(@"This is %@ player turn, you can't use selected figure.",playerTurn);
                }
            }
        }
        else if ([chosenCellState isEqualToString:@"noFigure"] == YES) {
            NSLog(@"You did not choose a figure! Nothing happens");
        }
        else {
            NSLog(@"Error! chosenCell = %@",chosenCellState);
        }
    }
    else if (imageTapTrigger == 1) {
        // here we see if the next cell tapped contains cells from possibleFigureMoves
        
        for (unsigned long i = 0;i<[possibleFigureMoves count];i++) {
            if (currentTag == [(myXYPoint*)possibleFigureMoves[i] convertToTag]) {
                NSString *cellState = [[NSString alloc] initWithString:[self getCellStateAtTag:currentTag]];
                
                if ([cellState isEqualToString:@"figure"] == YES) {
                    // get coords of the figure to kill
                    myXYPoint *coordsOfFigureToKill = [myXYPoint myInitWithTag:(int)currentTag];
                    
                    // kill a figure
                    Figure *figureAtTag = [self getFigureAtTag:(int)currentTag];
                    [figureAtTag kill];
                    
                    // move the killer to dead figure's place
                    //[figureToMove moveTo:[coordsOfFigureToKill x] y:[coordsOfFigureToKill y]];
                    [self moveFigureAndLogX:[coordsOfFigureToKill x] andY:[coordsOfFigureToKill y]];
                    
                    // prepare variables/triggers for next turn of opposing player
                    imageTapTrigger = 0;
                    
                    [self updateBoard];
                    [self checkKings];
                    
                    if (imageTapTrigger ==  2) {
                        break;
                    }
                    
                    if ([playerTurn isEqualToString:@"white"] == YES) {
                        [playerTurn setString:@"black"];
                        [myDisplay setText:@"Black player turn"];
                        }
                    else if ([playerTurn isEqualToString:@"black"] == YES) {
                        [playerTurn setString:@"white"];
                        [myDisplay setText:@"White player turn"];
                    }
                    break;
                }
                else if ([cellState isEqualToString:@"noFigure"] == YES) {

                    myXYPoint *coordsOfCellToMoveTo = [myXYPoint myInitWithTag:(int)currentTag];
                    //[figureToMove moveTo:[coordsOfCellToMoveTo x] y:[coordsOfCellToMoveTo y]];
                    [self moveFigureAndLogX:[coordsOfCellToMoveTo x] andY:[coordsOfCellToMoveTo y]];
                    
                    imageTapTrigger = 0;
                    
                    [self updateBoard];
                    [self checkKings];
                    
                    if (imageTapTrigger == 2) {
                        break;
                    }
                        
                    if ([playerTurn isEqualToString:@"white"] == YES) {
                        [playerTurn setString:@"black"];
                        [myDisplay setText:@"Black player turn"];
                    }
                    else if ([playerTurn isEqualToString:@"black"] == YES) {
                        [playerTurn setString:@"white"];
                        [myDisplay setText:@"White player turn"];
                    }
                    break;
                }
                else {
                    NSLog(@"Weird kind of error, this should not happen (imageTapFunc, imageTapTrigger=1");
                }
            }
        }
        if (imageTapTrigger == 1) {
            NSLog(@"Restarting this player's turn");
            imageTapTrigger = 0;
            [self updateBoard];
        }
        if (imageTapTrigger == 2) {
            NSLog(@"Everything's finished, waiting for the game restart");
        }
    }
}

-(void)showPossibleFigureMovesFromArray:(NSArray *)arrayWithPossibleMoves
{
    //NSLog(@"Showing possible moves");
    long currentTag;
    for (unsigned long i = 0;i<[arrayWithPossibleMoves count];i++) {
        Figure *currentFigure = [[Figure alloc]init];
        currentTag = [(myXYPoint*)arrayWithPossibleMoves[i] convertToTag];
        currentFigure = [self getFigureAtTag:(int)currentTag];
        NSString *colorOfCurrentFigure;
        NSString *nameOfCurrentFigure;
        
        if (currentFigure == nil) {
            NSLog(@"Cell {%i;%i} is empty",[(myXYPoint*)arrayWithPossibleMoves[i] x],[(myXYPoint*)arrayWithPossibleMoves[i] y]);
            [(UIImageView*)cells[(currentTag-1)] setImage:[UIImage imageNamed:@"emptyCellChecked.png"]];
        }
        else {
            NSLog(@"Cell {%i;%i} contains %@ %@",[currentFigure x],[currentFigure y],[currentFigure listColor],[currentFigure listName]);
            colorOfCurrentFigure = [currentFigure listColor];
            nameOfCurrentFigure = [currentFigure listName];
            
            if ([currentFigure alive] == YES) {
                if ([colorOfCurrentFigure isEqualToString:@"white"] == YES) {
                    
                    if ([nameOfCurrentFigure isEqualToString:@"Pawn"] == YES) {
                        [(UIImageView*)cells[(currentTag-1)] setImage:[UIImage imageNamed:@"PawnChecked.png"]];
                    }
                    else if ([nameOfCurrentFigure isEqualToString:@"Rook"] == YES) {
                        [(UIImageView*)cells[(currentTag-1)] setImage:[UIImage imageNamed:@"RookChecked.png"]];
                    }
                    else if ([nameOfCurrentFigure isEqualToString:@"Knight"] == YES) {
                        [(UIImageView*)cells[(currentTag-1)] setImage:[UIImage imageNamed:@"KnightChecked.png"]];
                    }
                    else if ([nameOfCurrentFigure isEqualToString:@"Bishop"] == YES) {
                        [(UIImageView*)cells[(currentTag-1)] setImage:[UIImage imageNamed:@"BishopChecked.png"]];
                    }
                    else if ([nameOfCurrentFigure isEqualToString:@"Queen"] == YES) {
                        [(UIImageView*)cells[(currentTag-1)] setImage:[UIImage imageNamed:@"QueenChecked.png"]];
                    }
                    else if ([nameOfCurrentFigure isEqualToString:@"King"] == YES) {
                        [(UIImageView*)cells[(currentTag-1)] setImage:[UIImage imageNamed:@"KingChecked.png"]];
                    }
                    else {
                        NSLog(@"Error while updating board! No such name of figure: %@",nameOfCurrentFigure);
                    }
                }
                else if ([colorOfCurrentFigure isEqualToString:@"black"] == YES) {
                    
                    if ([nameOfCurrentFigure isEqualToString:@"Pawn"] == YES) {
                        [(UIImageView*)cells[(currentTag-1)] setImage:[UIImage imageNamed:@"PawnBlackChecked.png"]];
                    }
                    else if ([nameOfCurrentFigure isEqualToString:@"Rook"] == YES) {
                        [(UIImageView*)cells[(currentTag-1)] setImage:[UIImage imageNamed:@"RookBlackChecked.png"]];
                    }
                    else if ([nameOfCurrentFigure isEqualToString:@"Knight"] == YES) {
                        [(UIImageView*)cells[(currentTag-1)] setImage:[UIImage imageNamed:@"KnightBlackChecked.png"]];
                    }
                    else if ([nameOfCurrentFigure isEqualToString:@"Bishop"] == YES) {
                        [(UIImageView*)cells[(currentTag-1)] setImage:[UIImage imageNamed:@"BishopBlackChecked.png"]];
                    }
                    else if ([nameOfCurrentFigure isEqualToString:@"Queen"] == YES) {
                        [(UIImageView*)cells[(currentTag-1)] setImage:[UIImage imageNamed:@"QueenBlackChecked.png"]];
                    }
                    else if ([nameOfCurrentFigure isEqualToString:@"King"] == YES) {
                        [(UIImageView*)cells[(currentTag-1)] setImage:[UIImage imageNamed:@"KingBlackChecked.png"]];
                    }
                    else {
                        NSLog(@"Error while updating board! No such name of figure: %@",nameOfCurrentFigure);
                    }
                }
                else {
                    NSLog(@"Error while updating board! No such color of figure: %@",colorOfCurrentFigure);
                }
            }
            else {
                NSLog(@"Not marking %@ as checked because it's not alive",nameOfCurrentFigure);
            }
        }
    }
}

- (void)getPossibleTurnCoordsForPawn:(NSString*)currentFigureColor array:(NSMutableArray *)currentArray x:(int)currentX y:(int)currentY
{
    myXYPoint *tempXYCoords = [[myXYPoint alloc]init];
    [tempXYCoords setToX:currentX andY:currentY];

    if ([currentFigureColor isEqualToString:@"white"] == YES) {
        //NSLog(@"White Pawn under review");
        [tempXYCoords setToX:(currentX) andY:(currentY + 1)];
        
        if ([self arrayDoesContainCoord:tempXYCoords inArray:figurePositionsWhite] == YES) {
            //NSLog(@"White figure ahead, can't go Y+1");
        }
        else if ([self arrayDoesContainCoord:tempXYCoords inArray:figurePositionsBlack] == YES) {
            //NSLog(@"Black figure ahead, can't go Y+1");
        }
        else {
            [self addToPossibleTurnCoordsArray:currentArray XYobj:tempXYCoords];
            [tempXYCoords setToX:currentX andY:(currentY+2)];
            if (currentY == 2 && [self arrayDoesContainCoord:tempXYCoords inArray:figurePositionsWhite] == NO && [self arrayDoesContainCoord:tempXYCoords inArray:figurePositionsBlack] == NO) {
                [self addToPossibleTurnCoordsArray:currentArray XYobj:tempXYCoords];
            }
        }
    }
    else if ([currentFigureColor isEqualToString:@"black"] == YES) {
        //NSLog(@"Black Pawn under review");
        [tempXYCoords setToX:(currentX) andY:(currentY - 1)];
        
        if ([self arrayDoesContainCoord:tempXYCoords inArray:figurePositionsBlack] == YES) {
            //NSLog(@"Black figure ahead, can't go Y-1");
        }
        else if ([self arrayDoesContainCoord:tempXYCoords inArray:figurePositionsWhite] == YES) {
            //NSLog(@"White figure ahead, can't go Y-1");
        }
        else {
            [self addToPossibleTurnCoordsArray:currentArray XYobj:tempXYCoords];
            [tempXYCoords setToX:currentX andY:(currentY-2)];
            if (currentY == 7 && [self arrayDoesContainCoord:tempXYCoords inArray:figurePositionsBlack] == NO && [self arrayDoesContainCoord:tempXYCoords inArray:figurePositionsWhite] == NO) {
                [self addToPossibleTurnCoordsArray:currentArray XYobj:tempXYCoords];
            }
        }
    }
    
    if ([currentFigureColor isEqualToString:@"white"] == YES) {
        [tempXYCoords setToX:(currentX-1) andY:(currentY+1)];
        if ([self arrayDoesContainCoord:tempXYCoords inArray:figurePositionsBlack] == YES) {
            [self addToPossibleTurnCoordsArray:currentArray XYobj:tempXYCoords];
        }
        [tempXYCoords setToX:(currentX+1) andY:(currentY+1)];
        if ([self arrayDoesContainCoord:tempXYCoords inArray:figurePositionsBlack] == YES) {
            [self addToPossibleTurnCoordsArray:currentArray XYobj:tempXYCoords];
        }
    }
    else if ([currentFigureColor isEqualToString:@"black"] == YES) {
        [tempXYCoords setToX:(currentX-1) andY:(currentY-1)];
        if ([self arrayDoesContainCoord:tempXYCoords inArray:figurePositionsWhite] == YES) {
            [self addToPossibleTurnCoordsArray:currentArray XYobj:tempXYCoords];
        }
        [tempXYCoords setToX:(currentX+1) andY:(currentY-1)];
        if ([self arrayDoesContainCoord:tempXYCoords inArray:figurePositionsWhite] == YES) {
            [self addToPossibleTurnCoordsArray:currentArray XYobj:tempXYCoords];
        }
    }
}

-(BOOL)getPossibleTurnCoordsAssistFunc:(NSString *)currentFigureColor array:(NSMutableArray *)currentArray xyObj:(myXYPoint *)tempXYCoords figureType:(NSString *)type
{
    if ([currentFigureColor isEqualToString:@"white"] == YES) {
        if ([self arrayDoesContainCoord:tempXYCoords inArray:figurePositionsWhite] == YES) {
            //NSLog(@"White %@ stumbled on another white figure, can't proceed further",type);
            return NO;
        }
        else if ([self arrayDoesContainCoord:tempXYCoords inArray:figurePositionsBlack] == YES) {
            //NSLog(@"White %@ is able to kill a black figure at %i;%i, no more moves further",type,[tempXYCoords x],[tempXYCoords y]);
            [self addToPossibleTurnCoordsArray:currentArray XYobj:tempXYCoords];
            return NO;
        }
        else {
            [self addToPossibleTurnCoordsArray:currentArray XYobj:tempXYCoords];
        }
    }
    else if ([currentFigureColor isEqualToString:@"black"] == YES) {
        if ([self arrayDoesContainCoord:tempXYCoords inArray:figurePositionsBlack] == YES) {
            //NSLog(@"Black %@ stumbled on another black figure, can't proceed further",type);
            return NO;
        }
        else if ([self arrayDoesContainCoord:tempXYCoords inArray:figurePositionsWhite] == YES) {
            //NSLog(@"Black %@ is able to kill a white figure at %i;%i, no more moves further",type,[tempXYCoords x],[tempXYCoords y]);
            [self addToPossibleTurnCoordsArray:currentArray XYobj:tempXYCoords];
            return NO;
        }
        else {
            [self addToPossibleTurnCoordsArray:currentArray XYobj:tempXYCoords];
        }
    }
    return YES;
}

- (void)getPossibleTurnCoordsForRook:(NSString*)currentFigureColor array:(NSMutableArray *)currentArray x:(int)currentX y:(int)currentY
{
    //NSLog(@"Rook under review");
    int helpfulInt;

    helpfulInt = currentY;
    while (helpfulInt < 8) {
        myXYPoint *tempXYCoords = [[myXYPoint alloc]init];
        helpfulInt++;
        [tempXYCoords setToX:currentX andY:helpfulInt];
        if ([self getPossibleTurnCoordsAssistFunc:currentFigureColor array:currentArray xyObj:tempXYCoords figureType:@"Rook"] == NO) {
            break;
        }
    }
    helpfulInt = currentX;
    while (helpfulInt < 8) {
        myXYPoint *tempXYCoords = [[myXYPoint alloc]init];
        helpfulInt++;
        [tempXYCoords setToX:helpfulInt andY:currentY];
        if ([self getPossibleTurnCoordsAssistFunc:currentFigureColor array:currentArray xyObj:tempXYCoords figureType:@"Rook"] == NO) {
            break;
        }
    }
    helpfulInt = currentX;
    while (helpfulInt > 1) {
        myXYPoint *tempXYCoords = [[myXYPoint alloc]init];
        helpfulInt--;
        [tempXYCoords setToX:helpfulInt andY:currentY];
        if ([self getPossibleTurnCoordsAssistFunc:currentFigureColor array:currentArray xyObj:tempXYCoords figureType:@"Rook"] == NO) {
            break;
        }
    }
    helpfulInt = currentY;
    while (helpfulInt > 1) {
        myXYPoint *tempXYCoords = [[myXYPoint alloc]init];
        helpfulInt--;
        [tempXYCoords setToX:currentX andY:helpfulInt];
        if ([self getPossibleTurnCoordsAssistFunc:currentFigureColor array:currentArray xyObj:tempXYCoords figureType:@"Rook"] == NO) {
            break;
        }
    }
}

-(void)getPossibleTurnCoordsAssistFunc2:(NSString *)currentFigureColor array:(NSMutableArray *)currentArray xyObj:(myXYPoint *)tempXYCoords figureType:(NSString *)type
{
    if ([currentFigureColor isEqualToString:@"white"] == YES) {
        if ([self arrayDoesContainCoord:tempXYCoords inArray:figurePositionsWhite] == YES) {
            //NSLog(@"White %@ can't go to point {%i;%i}, because there's a white figure",type,[tempXYCoords x],[tempXYCoords y]);
        }
        else {
            [self addToPossibleTurnCoordsArray:currentArray XYobj:tempXYCoords];
        }
    }
    else if ([currentFigureColor isEqualToString:@"black"] == YES) {
        if ([self arrayDoesContainCoord:tempXYCoords inArray:figurePositionsBlack] == YES) {
            //NSLog(@"Black %@ can't go to point {%i;%i}, because there's a black figure",type,[tempXYCoords x],[tempXYCoords y]);
        }
        else {
            [self addToPossibleTurnCoordsArray:currentArray XYobj:tempXYCoords];
        }
    }
}

- (void)getPossibleTurnCoordsForKnight:(NSString*)currentFigureColor array:(NSMutableArray *)currentArray x:(int)currentX y:(int)currentY
{
    //NSLog(@"%@ knight under review",currentFigureColor);
    myXYPoint *tempXYCoords = [[myXYPoint alloc]init];
    
    [tempXYCoords setToX:currentX andY:currentY];
    if (([tempXYCoords x]+2) < 9 && ([tempXYCoords y]+1) < 9) {
        [tempXYCoords setToX:([tempXYCoords x]+2) andY:([tempXYCoords y]+1)];
        [self getPossibleTurnCoordsAssistFunc2:currentFigureColor array:currentArray xyObj:tempXYCoords figureType:@"Knight"];
    }
    [tempXYCoords setToX:currentX andY:currentY];
    if (([tempXYCoords x]+1) < 9 && ([tempXYCoords y]+2) < 9) {
        [tempXYCoords setToX:([tempXYCoords x]+1) andY:([tempXYCoords y]+2)];
        [self getPossibleTurnCoordsAssistFunc2:currentFigureColor array:currentArray xyObj:tempXYCoords figureType:@"Knight"];
    }
    
    [tempXYCoords setToX:currentX andY:currentY];
    if (([tempXYCoords x]-2) > 0 && ([tempXYCoords y]+1) < 9) {
        [tempXYCoords setToX:([tempXYCoords x]-2) andY:([tempXYCoords y]+1)];
        [self getPossibleTurnCoordsAssistFunc2:currentFigureColor array:currentArray xyObj:tempXYCoords figureType:@"Knight"];
    }
    [tempXYCoords setToX:currentX andY:currentY];
    if (([tempXYCoords x]-1) > 0 && ([tempXYCoords y]+2) < 9) {
        [tempXYCoords setToX:([tempXYCoords x]-1) andY:([tempXYCoords y]+2)];
        [self getPossibleTurnCoordsAssistFunc2:currentFigureColor array:currentArray xyObj:tempXYCoords figureType:@"Knight"];
    }
    
    [tempXYCoords setToX:currentX andY:currentY];
    if (([tempXYCoords x]-2) > 0 && ([tempXYCoords y]-1) > 0) {
        [tempXYCoords setToX:([tempXYCoords x]-2) andY:([tempXYCoords y]-1)];
        [self getPossibleTurnCoordsAssistFunc2:currentFigureColor array:currentArray xyObj:tempXYCoords figureType:@"Knight"];
    }
    [tempXYCoords setToX:currentX andY:currentY];
    if (([tempXYCoords x]-1) > 0 && ([tempXYCoords y]-2) > 0) {
        [tempXYCoords setToX:([tempXYCoords x]-1) andY:([tempXYCoords y]-2)];
        [self getPossibleTurnCoordsAssistFunc2:currentFigureColor array:currentArray xyObj:tempXYCoords figureType:@"Knight"];
    }
    
    [tempXYCoords setToX:currentX andY:currentY];
    if (([tempXYCoords x]+2) < 9 && ([tempXYCoords y]-1) > 0) {
        [tempXYCoords setToX:([tempXYCoords x]+2) andY:([tempXYCoords y]-1)];
        [self getPossibleTurnCoordsAssistFunc2:currentFigureColor array:currentArray xyObj:tempXYCoords figureType:@"Knight"];
    }
    [tempXYCoords setToX:currentX andY:currentY];
    if (([tempXYCoords x]+1) < 9 && ([tempXYCoords y]-2) > 0) {
        [tempXYCoords setToX:([tempXYCoords x]+1) andY:([tempXYCoords y]-2)];
        [self getPossibleTurnCoordsAssistFunc2:currentFigureColor array:currentArray xyObj:tempXYCoords figureType:@"Knight"];
    }
}

- (void)getPossibleTurnCoordsForBishop:(NSString*)currentFigureColor array:(NSMutableArray *)currentArray x:(int)currentX y:(int)currentY
{
    //NSLog(@"%@ bishop under review",currentFigureColor);
    int helpfulX,helpfulY;
    myXYPoint *tempXYCoords = [[myXYPoint alloc]init];
    [tempXYCoords setToX:currentX andY:currentY];
    
    helpfulX = currentX;
    helpfulY = currentY;
    while (helpfulX < 8 && helpfulY < 8) {
        helpfulX++;
        helpfulY++;
        [tempXYCoords setToX:helpfulX andY:helpfulY];
        if ([self getPossibleTurnCoordsAssistFunc:currentFigureColor array:currentArray xyObj:tempXYCoords figureType:@"Bishop"] == NO) {
            break;
        }
    }
    
    helpfulX = currentX;
    helpfulY = currentY;
    while (helpfulX > 1 && helpfulY < 8) {
        helpfulX--;
        helpfulY++;
        [tempXYCoords setToX:helpfulX andY:helpfulY];
        if ([self getPossibleTurnCoordsAssistFunc:currentFigureColor array:currentArray xyObj:tempXYCoords figureType:@"Bishop"] == NO) {
            break;
        }
    }
    
    helpfulX = currentX;
    helpfulY = currentY;
    while (helpfulX > 1 && helpfulY > 1) {
        helpfulX--;
        helpfulY--;
        [tempXYCoords setToX:helpfulX andY:helpfulY];
        if ([self getPossibleTurnCoordsAssistFunc:currentFigureColor array:currentArray xyObj:tempXYCoords figureType:@"Bishop"] == NO) {
            break;
        }
    }
    
    helpfulX = currentX;
    helpfulY = currentY;
    while (helpfulX < 8 && helpfulY > 1) {
        helpfulX++;
        helpfulY--;
        [tempXYCoords setToX:helpfulX andY:helpfulY];
        if ([self getPossibleTurnCoordsAssistFunc:currentFigureColor array:currentArray xyObj:tempXYCoords figureType:@"Bishop"] == NO) {
            break;
        }
    }
}

- (void)getPossibleTurnCoordsForQueen:(NSString*)currentFigureColor array:(NSMutableArray *)currentArray x:(int)currentX y:(int)currentY
{
    //NSLog(@"%@ queen under review",currentFigureColor);
    int helpfulX,helpfulY;
    myXYPoint *tempXYCoords = [[myXYPoint alloc]init];
    [tempXYCoords setToX:currentX andY:currentY];
    
    helpfulX = currentX;
    helpfulY = currentY;
    while (helpfulX < 8 && helpfulY < 8) {
        helpfulX++;
        helpfulY++;
        [tempXYCoords setToX:helpfulX andY:helpfulY];
        if ([self getPossibleTurnCoordsAssistFunc:currentFigureColor array:currentArray xyObj:tempXYCoords figureType:@"Queen"] == NO) {
            break;
        }
    }
    
    helpfulX = currentX;
    while (helpfulX < 8) {
        helpfulX++;
        [tempXYCoords setToX:helpfulX andY:currentY];
        if ([self getPossibleTurnCoordsAssistFunc:currentFigureColor array:currentArray xyObj:tempXYCoords figureType:@"Queen"] == NO) {
            break;
        }
    }
    
    helpfulX = currentX;
    helpfulY = currentY;
    while (helpfulX > 1 && helpfulY < 8) {
        helpfulX--;
        helpfulY++;
        [tempXYCoords setToX:helpfulX andY:helpfulY];
        if ([self getPossibleTurnCoordsAssistFunc:currentFigureColor array:currentArray xyObj:tempXYCoords figureType:@"Queen"] == NO) {
            break;
        }
    }
    
    helpfulY = currentY;
    while (helpfulY > 1) {
        helpfulY--;
        [tempXYCoords setToX:currentX andY:helpfulY];
        if ([self getPossibleTurnCoordsAssistFunc:currentFigureColor array:currentArray xyObj:tempXYCoords figureType:@"Queen"] == NO) {
            break;
        }
    }
    
    helpfulX = currentX;
    helpfulY = currentY;
    while (helpfulX > 1 && helpfulY > 1) {
        helpfulX--;
        helpfulY--;
        [tempXYCoords setToX:helpfulX andY:helpfulY];
        if ([self getPossibleTurnCoordsAssistFunc:currentFigureColor array:currentArray xyObj:tempXYCoords figureType:@"Queen"] == NO) {
            break;
        }
    }
    
    helpfulX = currentX;
    while (helpfulX > 1) {
        helpfulX--;
        [tempXYCoords setToX:helpfulX andY:currentY];
        if ([self getPossibleTurnCoordsAssistFunc:currentFigureColor array:currentArray xyObj:tempXYCoords figureType:@"Queen"] == NO) {
            break;
        }
    }
    
    helpfulX = currentX;
    helpfulY = currentY;
    while (helpfulX < 8 && helpfulY > 1) {
        helpfulX++;
        helpfulY--;
        [tempXYCoords setToX:helpfulX andY:helpfulY];
        if ([self getPossibleTurnCoordsAssistFunc:currentFigureColor array:currentArray xyObj:tempXYCoords figureType:@"Queen"] == NO) {
            break;
        }
}
    
    helpfulY = currentY;
    while (helpfulY < 8) {
        helpfulY++;
        [tempXYCoords setToX:currentX andY:helpfulY];
        if ([self getPossibleTurnCoordsAssistFunc:currentFigureColor array:currentArray xyObj:tempXYCoords figureType:@"Queen"] == NO) {
            break;
        }
    }
}

- (void)getPossibleTurnCoordsForKing:(NSString*)currentFigureColor array:(NSMutableArray *)currentArray x:(int)currentX y:(int)currentY
{
    myXYPoint *tempXYCoords = [[myXYPoint alloc]init];
    [tempXYCoords setToX:currentX andY:currentY];
    
    if ((currentX+1) < 9) {
        [tempXYCoords setToX:(currentX+1) andY:currentY];
        [self getPossibleTurnCoordsAssistFunc:currentFigureColor array:currentArray xyObj:tempXYCoords figureType:@"King"];
    }
    if ((currentX+1) < 9 && (currentY+1) < 9) {
        [tempXYCoords setToX:(currentX+1) andY:(currentY+1)];
        [self getPossibleTurnCoordsAssistFunc:currentFigureColor array:currentArray xyObj:tempXYCoords figureType:@"King"];
    }
    if ((currentY+1) < 9) {
        [tempXYCoords setToX:currentX andY:(currentY+1)];
        [self getPossibleTurnCoordsAssistFunc:currentFigureColor array:currentArray xyObj:tempXYCoords figureType:@"King"];
    }
    if ((currentX-1) > 0 && (currentY+1) < 9) {
        [tempXYCoords setToX:(currentX-1) andY:(currentY+1)];
        [self getPossibleTurnCoordsAssistFunc:currentFigureColor array:currentArray xyObj:tempXYCoords figureType:@"King"];
    }
    if ((currentX-1) > 0) {
        [tempXYCoords setToX:(currentX-1) andY:currentY];
        [self getPossibleTurnCoordsAssistFunc:currentFigureColor array:currentArray xyObj:tempXYCoords figureType:@"King"];
    }
    if ((currentX-1) > 0 && (currentY-1) > 0) {
        [tempXYCoords setToX:(currentX-1) andY:(currentY-1)];
        [self getPossibleTurnCoordsAssistFunc:currentFigureColor array:currentArray xyObj:tempXYCoords figureType:@"King"];
    }
    if ((currentY-1) > 0) {
        [tempXYCoords setToX:currentX andY:(currentY-1)];
        [self getPossibleTurnCoordsAssistFunc:currentFigureColor array:currentArray xyObj:tempXYCoords figureType:@"King"];
    }
    if ((currentX+1) < 9 && (currentY-1) > 0) {
        [tempXYCoords setToX:(currentX+1) andY:(currentY-1)];
        [self getPossibleTurnCoordsAssistFunc:currentFigureColor array:currentArray xyObj:tempXYCoords figureType:@"King"];
    }
}

-(BOOL)arrayDoesContainCoord:(myXYPoint *)coord inArray:(NSMutableArray *)positionsArray
{
    for (unsigned long i=0;i<[positionsArray count];i++) {
        if ([coord x] == [(myXYPoint*)positionsArray[i] x] && [coord y] == [(myXYPoint*)positionsArray[i] y]) {
            return YES;
        }
    }
    return NO;
}

-(NSMutableArray*)getPossibleTurnCoordsForFigure:(Figure *)currentFigure
{
    NSString *currentFigureColor = [currentFigure listColor];
    [self updateFigurePositions];

    NSMutableArray *coordsForFigureMoves = [[NSMutableArray alloc] init];
    int currentX = [currentFigure x];
    int currentY = [currentFigure y];
    
    if ([[currentFigure listName] isEqualToString:@"Pawn"] == YES) {
    //    NSLog(@"calculating possible moves for pawn"); //don't forget to delete
        [self getPossibleTurnCoordsForPawn:currentFigureColor array:coordsForFigureMoves x:currentX y:currentY];
    }
    else if ([[currentFigure listName] isEqualToString:@"Rook"] == YES) {
        [self getPossibleTurnCoordsForRook:currentFigureColor array:coordsForFigureMoves x:currentX y:currentY];
    }
    else if ([[currentFigure listName] isEqualToString:@"Knight"] == YES) {
        [self getPossibleTurnCoordsForKnight:currentFigureColor array:coordsForFigureMoves x:currentX y:currentY];
    }
    else if ([[currentFigure listName] isEqualToString:@"Bishop"] == YES) {
        [self getPossibleTurnCoordsForBishop:currentFigureColor array:coordsForFigureMoves x:currentX y:currentY];
    }
    else if ([[currentFigure listName] isEqualToString:@"Queen"] == YES) {
        [self getPossibleTurnCoordsForQueen:currentFigureColor array:coordsForFigureMoves x:currentX y:currentY];
    }
    else if ([[currentFigure listName] isEqualToString:@"King"] == YES) {
        [self getPossibleTurnCoordsForKing:currentFigureColor array:coordsForFigureMoves x:currentX y:currentY];
    }
    else {
        NSLog(@"No such figure: %@",[currentFigure listName]);
    }
    return coordsForFigureMoves;
}

-(void)updateFigurePositions
{
    figurePositionsWhite = [[NSMutableArray alloc]init];
    figurePositionsBlack = [[NSMutableArray alloc]init];
    int Xholder,Yholder;
    
    for (int i = 0;i<32;i++) {
        Xholder = [(Figure*)figures[i] x];
        Yholder = [(Figure*)figures[i] y];
        myXYPoint *temporaryXYPoint = [myXYPoint myInit:Xholder :Yholder];
        if (i < 16) {
            [figurePositionsWhite addObject:temporaryXYPoint];
        }
        else if (i >= 16) {
            [figurePositionsBlack addObject:temporaryXYPoint];
        }
    }
}

-(void)addToPossibleTurnCoordsArray:(NSMutableArray *)array XYobj:(myXYPoint *)objectToStore
{
    myXYPoint *tempPoint = [myXYPoint myInit:[objectToStore x] :[objectToStore y]];
    [array addObject:tempPoint];
}

-(Figure*)getFigureAtCoords:(int)x andY:(int)y
{
    myXYPoint *tempXYObj = [myXYPoint myInit:x :y];
    Figure *tempFigure;
    
    for (int i = 0;i<32;i++) {
        if ([tempXYObj x] == [(Figure*)figures[i] x] && [tempXYObj y] == [(Figure*)figures[i] y]) {
            tempFigure = figures[i];
        }
    }
    return tempFigure;
}

-(Figure*)getFigureAtTag:(int)currentTag
{
    myXYPoint *tempXYObj = [myXYPoint myInitWithTag:currentTag];
    Figure *tempFigure;
    
    for (int i = 0;i<32;i++) {
        if ([tempXYObj x] == [(Figure*)figures[i] x] && [tempXYObj y] == [(Figure*)figures[i] y]) {
            tempFigure = figures[i];
        }
    }
    return tempFigure;
}

-(NSString*)getCellStateAtTag:(long int)currentTag
{
    NSMutableString *typeOFCellContent = [[NSMutableString alloc]initWithString:@"empty"];
    myXYPoint *tempXYObj = [myXYPoint myInitWithTag:(int)currentTag];
    int chosenCellX = [tempXYObj x];
    int chosenCellY = [tempXYObj y];
    
    for (int i = 0;i<32;i++) {
        if (chosenCellX == [(Figure*)figures[i] x] && chosenCellY == [(Figure*)figures[i] y]) {
            [typeOFCellContent setString:@"figure"];
        }
    }
    if ([typeOFCellContent isEqualToString:@"empty"] == YES) {
        [typeOFCellContent setString:@"noFigure"];
    }
    return typeOFCellContent;
}

-(void)returnFiguresToBasicPositions
{
    NSLog(@"Returning figures to basic positions and setting alive to 'YES'");
    [pawn1 moveTo:1 y:2];
    [pawn2 moveTo:2 y:2];
    [pawn3 moveTo:3 y:2];
    [pawn4 moveTo:4 y:2];
    [pawn5 moveTo:5 y:2];
    [pawn6 moveTo:6 y:2];
    [pawn7 moveTo:7 y:2];
    [pawn8 moveTo:8 y:2];
    [pawnBlack1 moveTo:1 y:7];
    [pawnBlack2 moveTo:2 y:7];
    [pawnBlack3 moveTo:3 y:7];
    [pawnBlack4 moveTo:4 y:7];
    [pawnBlack5 moveTo:5 y:7];
    [pawnBlack6 moveTo:6 y:7];
    [pawnBlack7 moveTo:7 y:7];
    [pawnBlack8 moveTo:8 y:7];
    [rook1 moveTo:1 y:1];
    [rook2 moveTo:8 y:1];
    [rookBlack1 moveTo:1 y:8];
    [rookBlack2 moveTo:8 y:8];
    [knight1 moveTo:2 y:1];
    [knight2 moveTo:7 y:1];
    [knightBlack1 moveTo:2 y:8];
    [knightBlack2 moveTo:7 y:8];
    [bishop1 moveTo:3 y:1];
    [bishop2 moveTo:6 y:1];
    [bishopBlack1 moveTo:3 y:8];
    [bishopBlack2 moveTo:6 y:8];
    [queen moveTo:4 y:1];
    [queenBlack moveTo:4 y:8];
    [king moveTo:5 y:1];
    [kingBlack moveTo:5 y:8];
    
    for (int i = 0;i<32;i++) {
        [figures[i] setAlive:YES];
    }
    
    NSLog(@"Moved all figures to their starting positions!");
    
    [self updateFigurePositions]; //here just in case
}

-(int)convertCoordsToTag:(int)x y:(int)y
{
    return (8*(y-1) + x);
}

-(void)clearCells
{
    for (int i = 0;i < 64; i++) {
        [(UIImageView*)cells[i] setImage:nil];
    }
}

-(void)updateBoard
{
    // clear all cells
    [self clearCells];
    
    // assign tags based on coords
    // analyze figures and color of according cells and set images
    for (int i = 0;i < 32;i++) {
        NSString *colorOfCurrentFigure = [figures[i] listColor];
        NSString *nameOfCurrentFigure = [figures[i] listName];
        int cellX = [(Figure*)figures[i] x];
        int cellY = [(Figure*)figures[i] y];
        long int cellToFill = [self convertCoordsToTag:cellX y:cellY] - 1;
        //= [(UIView*)figures[i] tag] - 1;
        BOOL creatureIsAlive = [figures[i] alive];
        
        if (creatureIsAlive == YES) {
            if ([colorOfCurrentFigure isEqualToString:@"white"] == YES) {
                if ([nameOfCurrentFigure isEqualToString:@"Pawn"] == YES) {
                    [(UIImageView*)cells[cellToFill] setImage:[UIImage imageNamed:@"Pawn.png"]];
                }
                else if ([nameOfCurrentFigure isEqualToString:@"Rook"] == YES) {
                    [(UIImageView*)cells[cellToFill] setImage:[UIImage imageNamed:@"Rook.png"]];
                }
                else if ([nameOfCurrentFigure isEqualToString:@"Knight"] == YES) {
                    [(UIImageView*)cells[cellToFill] setImage:[UIImage imageNamed:@"Knight.png"]];
                }
                else if ([nameOfCurrentFigure isEqualToString:@"Bishop"] == YES) {
                    [(UIImageView*)cells[cellToFill] setImage:[UIImage imageNamed:@"Bishop.png"]];
                }
                else if ([nameOfCurrentFigure isEqualToString:@"Queen"] == YES) {
                    [(UIImageView*)cells[cellToFill] setImage:[UIImage imageNamed:@"Queen.png"]];
                }
                else if ([nameOfCurrentFigure isEqualToString:@"King"] == YES) {
                    [(UIImageView*)cells[cellToFill] setImage:[UIImage imageNamed:@"King.png"]];
                }
                else {
                    NSLog(@"Error while updating board! No such name of figure: %@",nameOfCurrentFigure);
                }
            }
            else if ([colorOfCurrentFigure isEqualToString:@"black"] == YES) {
                
                if ([nameOfCurrentFigure isEqualToString:@"Pawn"] == YES) {
                    [(UIImageView*)cells[cellToFill] setImage:[UIImage imageNamed:@"PawnBlack.png"]];
                }
                else if ([nameOfCurrentFigure isEqualToString:@"Rook"] == YES) {
                    [(UIImageView*)cells[cellToFill] setImage:[UIImage imageNamed:@"RookBlack.png"]];
                }
                else if ([nameOfCurrentFigure isEqualToString:@"Knight"] == YES) {
                    [(UIImageView*)cells[cellToFill] setImage:[UIImage imageNamed:@"KnightBlack.png"]];
                }
                else if ([nameOfCurrentFigure isEqualToString:@"Bishop"] == YES) {
                    [(UIImageView*)cells[cellToFill] setImage:[UIImage imageNamed:@"BishopBlack.png"]];
                }
                else if ([nameOfCurrentFigure isEqualToString:@"Queen"] == YES) {
                    [(UIImageView*)cells[cellToFill] setImage:[UIImage imageNamed:@"QueenBlack.png"]];
                }
                else if ([nameOfCurrentFigure isEqualToString:@"King"] == YES) {
                    [(UIImageView*)cells[cellToFill] setImage:[UIImage imageNamed:@"KingBlack.png"]];
                }
                else {
                    NSLog(@"Error while updating board! No such name of figure: %@",nameOfCurrentFigure);
                }
            }
            else {
                NSLog(@"Error while updating board! No such color of figure: %@",colorOfCurrentFigure);
            }
        }
        else if (creatureIsAlive == NO) {
            NSLog(@"Not updating %@, because it's not alive",nameOfCurrentFigure);
        }
    }
    NSLog(@"Board updated");
}

- (NSMutableArray*)createImageViewArray
{
    NSMutableArray *tempArray;
    tempArray = [[NSMutableArray alloc] initWithObjects:ImageView1, ImageView2, ImageView3, ImageView4, ImageView5, ImageView6, ImageView7, ImageView8, ImageView9, ImageView10, ImageView11, ImageView12, ImageView13, ImageView14, ImageView15, ImageView16, ImageView17, ImageView18, ImageView19, ImageView20, ImageView21, ImageView22, ImageView23, ImageView24, ImageView25, ImageView26, ImageView27, ImageView28, ImageView29, ImageView30, ImageView31, ImageView32, ImageView33, ImageView34, ImageView35, ImageView36, ImageView37, ImageView38, ImageView39, ImageView40, ImageView41, ImageView42, ImageView43, ImageView44, ImageView45, ImageView46, ImageView47, ImageView48, ImageView49, ImageView50, ImageView51, ImageView52, ImageView53, ImageView54, ImageView55, ImageView56, ImageView57, ImageView58, ImageView59, ImageView60, ImageView61, ImageView62, ImageView63, ImageView64, nil];
    return tempArray;
}

- (NSMutableArray*)createGestureRecognizerArray
{
    NSMutableArray *tempArray;
    // gesture recognizer variables for array (because one recognizer can only be assigned to one view)
    UITapGestureRecognizer *myTap1, *myTap2, *myTap3, *myTap4, *myTap5, *myTap6, *myTap7, *myTap8, *myTap9, *myTap10, *myTap11, *myTap12, *myTap13, *myTap14, *myTap15, *myTap16, *myTap17, *myTap18, *myTap19, *myTap20, *myTap21, *myTap22, *myTap23, *myTap24, *myTap25, *myTap26, *myTap27, *myTap28, *myTap29, *myTap30, *myTap31, *myTap32, *myTap33, *myTap34, *myTap35, *myTap36, *myTap37, *myTap38, *myTap39, *myTap40, *myTap41, *myTap42, *myTap43, *myTap44, *myTap45, *myTap46, *myTap47, *myTap48, *myTap49, *myTap50, *myTap51, *myTap52, *myTap53, *myTap54, *myTap55, *myTap56, *myTap57, *myTap58, *myTap59, *myTap60, *myTap61, *myTap62, *myTap63, *myTap64;
    tempArray = [[NSMutableArray alloc] initWithObjects:myTap1,myTap2,myTap3,myTap4,myTap5,myTap6,myTap7,myTap8,myTap9,myTap10,myTap11,myTap12,myTap13,myTap14,myTap15,myTap16,myTap17,myTap18,myTap19,myTap20,myTap21,myTap22,myTap23,myTap24,myTap25,myTap26,myTap27,myTap28,myTap29,myTap30,myTap31,myTap32,myTap33,myTap34,myTap35,myTap36,myTap37,myTap38,myTap39,myTap40,myTap41,myTap42,myTap43,myTap44,myTap45,myTap46,myTap47,myTap48,myTap49,myTap50,myTap51,myTap52,myTap53,myTap54,myTap55,myTap56,myTap57,myTap58,myTap59,myTap60,myTap61,myTap62,myTap63,myTap64,nil];
    return tempArray;
}

-(void)initFigures
{
    pawn1 = [Figure myInit:1 y:2 type:0 color:@"white"];
    pawn2 = [Figure myInit:2 y:2 type:0 color:@"white"];
    pawn3 = [Figure myInit:3 y:2 type:0 color:@"white"];
    pawn4 = [Figure myInit:4 y:2 type:0 color:@"white"];
    pawn5 = [Figure myInit:5 y:2 type:0 color:@"white"];
    pawn6 = [Figure myInit:6 y:2 type:0 color:@"white"];
    pawn7 = [Figure myInit:7 y:2 type:0 color:@"white"];
    pawn8 = [Figure myInit:8 y:2 type:0 color:@"white"];
    pawnBlack1 = [Figure myInit:1 y:7 type:0 color:@"black"];
    pawnBlack2 = [Figure myInit:2 y:7 type:0 color:@"black"];
    pawnBlack3 = [Figure myInit:3 y:7 type:0 color:@"black"];
    pawnBlack4 = [Figure myInit:4 y:7 type:0 color:@"black"];
    pawnBlack5 = [Figure myInit:5 y:7 type:0 color:@"black"];
    pawnBlack6 = [Figure myInit:6 y:7 type:0 color:@"black"];
    pawnBlack7 = [Figure myInit:7 y:7 type:0 color:@"black"];
    pawnBlack8 = [Figure myInit:8 y:7 type:0 color:@"black"];
    rook1 = [Figure myInit:1 y:1 type:1 color:@"white"];
    rook2 = [Figure myInit:8 y:1 type:1 color:@"white"];
    rookBlack1 = [Figure myInit:1 y:8 type:1 color:@"black"];
    rookBlack2 = [Figure myInit:8 y:8 type:1 color:@"black"];
    knight1 = [Figure myInit:2 y:1 type:2 color:@"white"];
    knight2 = [Figure myInit:7 y:1 type:2 color:@"white"];
    knightBlack1 = [Figure myInit:2 y:8 type:2 color:@"black"];
    knightBlack2 = [Figure myInit:7 y:8 type:2 color:@"black"];
    bishop1 = [Figure myInit:3 y:1 type:3 color:@"white"];
    bishop2 = [Figure myInit:6 y:1 type:3 color:@"white"];
    bishopBlack1 = [Figure myInit:3 y:8 type:3 color:@"black"];
    bishopBlack2 = [Figure myInit:6 y:8 type:3 color:@"black"];
    queen = [Figure myInit:4 y:1 type:4 color:@"white"];
    queenBlack = [Figure myInit:4 y:8 type:4 color:@"black"];
    king = [Figure myInit:5 y:1 type:5 color:@"white"];
    kingBlack = [Figure myInit:5 y:8 type:5 color:@"black"];
}

-(void)checkKings { // This function must ONLY be used after a player turn!!
    [self updateFigurePositions];
    
    // check white king
    NSMutableArray *blackSidePossibleMoves = [[NSMutableArray alloc]init];
    Figure *tempFig = [[Figure alloc]init];
    for (int i=0;i<16;i++) {
        tempFig = [self getFigureAtTag:[[figurePositionsBlack objectAtIndex:i] convertToTag]];
        blackSidePossibleMoves = [self mergeArrays:blackSidePossibleMoves and:[self getPossibleTurnCoordsForFigure:tempFig]];
    }
    // compare all black possible moves with white king's position
    myXYPoint *whiteKingPoint = [[myXYPoint alloc]init];
    [whiteKingPoint setToX:[king x] andY:[king y]];

    for (unsigned long i=0;i<[blackSidePossibleMoves count];i++) {
        if ([king x] == [(myXYPoint*)blackSidePossibleMoves[i] x] && [king y] == [(myXYPoint*)blackSidePossibleMoves[i] y]) {
            if ([playerTurn  isEqualToString: @"white"]) {
                [(UIImageView*)cells[([whiteKingPoint convertToTag]-1)] setImage:[UIImage imageNamed:@"kingCheckedRed.png"]];
                myDisplay.text = @"Black player wins!"; // need to find a way how to terminate session... (!)
                NSLog(@"BLACK WON!!!");
                imageTapTrigger = 2;
                log.text = [log.text stringByAppendingString:@"\rFinish"];
            }
        }
    }

    // check black king
    NSMutableArray *whiteSidePossibleMoves = [[NSMutableArray alloc]init];
    for (int i=0;i<16;i++) {
        tempFig = [self getFigureAtTag:[[figurePositionsWhite objectAtIndex:i] convertToTag]];
        whiteSidePossibleMoves = [self mergeArrays:whiteSidePossibleMoves and:[self getPossibleTurnCoordsForFigure:tempFig]];
    }
    // compare all white possible moves with black king's position
    myXYPoint *blackKingPoint = [[myXYPoint alloc]init];
    [blackKingPoint setToX:[kingBlack x] andY:[kingBlack y]];
    
    for (unsigned long i=0;i<[whiteSidePossibleMoves count];i++) {
        if ([kingBlack x] == [(myXYPoint*)whiteSidePossibleMoves[i] x] && [kingBlack y] == [(myXYPoint*)whiteSidePossibleMoves[i] y]) {
            if ([playerTurn isEqualToString: @"black"]) {
                [(UIImageView*)cells[([blackKingPoint convertToTag]-1)] setImage:[UIImage imageNamed:@"kingBlackCheckedRed.png"]];
                myDisplay.text = @"White player wins!"; // ...same thing applies...
                NSLog(@"WHITE WON!!!");
                imageTapTrigger = 2;
                log.text = [log.text stringByAppendingString:@"\rFinish"];
            }
        }
    }
}

-(NSMutableArray*)mergeArrays:(NSMutableArray*)array1 and:(NSMutableArray*)array2 {
    for (long int i=0;i<[array2 count];i++) {
        [array1 addObject:[array2 objectAtIndex:i]];
    }
    return array1;
}

- (void)logTurnWithCoordsX:(int)x andY:(int)y {
    NSString* tempString = [NSString stringWithFormat:@"\r(%@ %@): [%i:%i] to [%i:%i]",[figureToMove listColor],[figureToMove listName],[figureToMove x],[figureToMove y],x,y];
    log.text = [log.text stringByAppendingString:tempString];
    NSRange range = NSMakeRange(log.text.length - 1, 1);
    [log scrollRangeToVisible:range];
}

- (void) moveFigureAndLogX:(int)x andY:(int)y { //make a more suitable function name
    [self logTurnWithCoordsX:x andY:y];
    [figureToMove moveTo:x y:y];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    initializationTrigger = 0;
    imageTapTrigger = 0;
    playerTurn = [[NSMutableString alloc] initWithString:@"white"];
    turnProgress = 0;
    log.editable = NO;
    NSLog(@"Initializations at 'viewDidLoad' completed");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation {
    return NO;
}

@end
