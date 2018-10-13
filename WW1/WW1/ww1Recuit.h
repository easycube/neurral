//
//  ww1Recuit.h
//  WW1
//
//  Created by Rajaâ et Pierre on 27/09/2014.
//  Copyright (c) 2014 Rajaâ et Pierre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ww1Brain.h"
@interface ww1Recuit : NSObject


-(NSDictionary*)recuit:(NSArray*)testSample :(NSMutableDictionary*)layers;

/*
 runs optimisation of network with a test sample: an NSArray of couples of an NSNumber of the right output Neuron and an NSArray of the inputs as NSNumbers(0 or 1)
 layers is a dictionnary of 3 dictionnaries of neurons with Neurons as NSStrings @"n" and NSArrays of weights as NSNumbers with keys being @"layer1", @"layer2" and @"outputLayer"
 
 */
-(NSDictionary*)gradientRetroProgramming:(NSArray*)testSample :(NSMutableDictionary*)layers;
@end
