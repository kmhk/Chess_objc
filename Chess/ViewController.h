//
//  ViewController.h
//  Chess
//
//  Created by Admin on 15/11/14.
//  Copyright (c) 2014 KMHK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Figure.h"
#import "myXYPoint.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *myDisplay;
@property (weak, nonatomic) IBOutlet UITextView *log;
@property (strong, nonatomic) IBOutlet UIImageView *ImageView1, *ImageView2, *ImageView3, *ImageView4, *ImageView5, *ImageView6, *ImageView7, *ImageView8, *ImageView9, *ImageView10, *ImageView11, *ImageView12, *ImageView13, *ImageView14, *ImageView15, *ImageView16, *ImageView17, *ImageView18, *ImageView19, *ImageView20, *ImageView21, *ImageView22, *ImageView23, *ImageView24, *ImageView25, *ImageView26, *ImageView27, *ImageView28, *ImageView29, *ImageView30, *ImageView31, *ImageView32, *ImageView33, *ImageView34, *ImageView35, *ImageView36, *ImageView37, *ImageView38, *ImageView39, *ImageView40, *ImageView41, *ImageView42, *ImageView43, *ImageView44, *ImageView45, *ImageView46, *ImageView47, *ImageView48, *ImageView49, *ImageView50, *ImageView51, *ImageView52, *ImageView53, *ImageView54, *ImageView55, *ImageView56, *ImageView57, *ImageView58, *ImageView59, *ImageView60, *ImageView61, *ImageView62, *ImageView63, *ImageView64;
@property (strong, nonatomic) Figure *pawn1, *pawn2, *pawn3, *pawn4, *pawn5, *pawn6, *pawn7, *pawn8, *pawnBlack1, *pawnBlack2, *pawnBlack3, *pawnBlack4, *pawnBlack5, *pawnBlack6, *pawnBlack7, *pawnBlack8, *rook1, *rook2, *rookBlack1, *rookBlack2, *knight1, *knight2, *knightBlack1, *knightBlack2, *bishop1, *bishop2, *bishopBlack1, *bishopBlack2, *queen, *queenBlack, *king, *kingBlack;
@property NSMutableArray *cells, *figures, *gestureArray, *figurePositionsWhite, *figurePositionsBlack, *possibleFigureMoves;
@property (nonatomic,retain)IBOutlet UIButton *mainButton;
@property NSMutableString *playerTurn;
@property int turnProgress,imageTapTrigger,initializationTrigger;
@property long tagOfCellToMoveFrom,tagOfCellToMoveTo;
@property myXYPoint *coordsOfFigureToMove;
@property Figure *figureToMove;

- (IBAction)click;
- (IBAction)DebugClick:(UIButton *)sender;

- (void)imageTap:(id)sender;
- (void)returnFiguresToBasicPositions;
- (void)clearCells;
- (void)updateBoard;
- (NSMutableArray*)createImageViewArray;
- (NSMutableArray*)createGestureRecognizerArray;
- (void)initFigures;
- (NSString*)getCellStateAtTag:(long)currentTag;
- (Figure*)getFigureAtTag:(int)currentTag;
- (Figure*)getFigureAtCoords:(int)x andY:(int)y;
- (NSMutableArray*)getPossibleTurnCoordsForFigure:(Figure*)currentFigure;
- (void)getPossibleTurnCoordsForPawn:(NSString*)currentFigureColor array:(NSMutableArray*)currentArray x:(int)currentX y:(int)currentY;
- (BOOL)getPossibleTurnCoordsAssistFunc:(NSString*)currentFigureColor array:(NSMutableArray*)currentArray xyObj:(myXYPoint*)tempXYCoords figureType:(NSString*)type;
- (void)getPossibleTurnCoordsForRook:(NSString*)currentFigureColor array:(NSMutableArray*)currentArray x:(int)currentX y:(int)currentY;
- (void)getPossibleTurnCoordsAssistFunc2:(NSString*)currentFigureColor array:(NSMutableArray*)currentArray xyObj:(myXYPoint*)tempXYCoords figureType:(NSString*)type;
- (void)getPossibleTurnCoordsForKnight:(NSString*)currentFigureColor array:(NSMutableArray*)currentArray x:(int)currentX y:(int)currentY;
- (void)getPossibleTurnCoordsForBishop:(NSString*)currentFigureColor array:(NSMutableArray*)currentArray x:(int)currentX y:(int)currentY;
- (void)getPossibleTurnCoordsForQueen:(NSString*)currentFigureColor array:(NSMutableArray*)currentArray x:(int)currentX y:(int)currentY;
- (void)getPossibleTurnCoordsForKing:(NSString*)currentFigureColor array:(NSMutableArray*)currentArray x:(int)currentX y:(int)currentY;
- (void)addToPossibleTurnCoordsArray:(NSMutableArray*)array XYobj:(myXYPoint*)objectToStore;
- (int)convertCoordsToTag:(int)x y:(int)y;
- (void)updateFigurePositions;
- (BOOL)arrayDoesContainCoord:(myXYPoint*)coord inArray:(NSMutableArray*)positionsArray;
- (void)showPossibleFigureMovesFromArray:(NSArray*)arrayWithPossibleMoves;
- (void)checkKings;
- (NSMutableArray*)mergeArrays:(NSMutableArray*)array1 and:(NSMutableArray*)array2;
- (void)logTurnWithCoordsX:(int)x andY:(int)y;
- (void)moveFigureAndLogX:(int)x andY:(int)y;

@end
