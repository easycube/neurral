//
//  ww1Brain.h
//  WW1
//
//  Created by Rajaâ et Pierre on 23/09/2014.
//  Copyright (c) 2014 Rajaâ et Pierre. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
static const int INPUTS_COUNT=49;
static const int FIRST_LAYER_COUNT=5;
static const int SECOND_LAYER_COUNT=4;
static const int OUTPUT_COUNT=3;
*/


@interface ww1Brain : NSObject

@property (nonatomic,strong) NSString*state;
@property (nonatomic,strong)NSMutableArray*lastLetter;
-(NSArray*)networkOutputs:(NSArray*)matrix :(NSDictionary*)firstLayer :(NSDictionary*)secondLayer :(NSDictionary*)outputLayer;
-(NSArray*)firstLayerOutput:(NSArray *)sample :(NSDictionary*)firstLayer;
-(NSArray*)secondLayerOutput:(NSArray *)sample :(NSDictionary*)firstLayer :(NSDictionary*)secondLayer;
-(void)getXY:(CGPoint)position :(CGPoint)move;



//-(void)getMovementState:(NSString*)state;
/*
returns an NSArray of NSNumbers between 0 and 1 representing the outputs of each output layer neuron.
 
 inputs are an NSArray of the inputs of the 1st layers as NSNumbers 0 or 1, and the weights of the neurons of every layer as NSDictionnaries of @"n" neuron adresses and NSArrays of weights as NSNumbers
*/

@end
