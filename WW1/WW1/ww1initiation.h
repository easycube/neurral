//
//  ww1initiation.h
//  WW1
//
//  Created by Rajaâ et Pierre on 28/09/2014.
//  Copyright (c) 2014 Rajaâ et Pierre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ww1recuit.h"
#import "ww1Brain.h"

@interface ww1initiation : NSObject
-(void)initiate:(NSMutableArray*)testSample;
-(void)setTheLayers:(NSMutableDictionary*)startLayers;
@property(nonatomic,strong) NSMutableDictionary*layers;
@end
