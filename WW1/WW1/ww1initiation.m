//
//  ww1initiation.m
//  WW1
//
//  Created by Rajaâ et Pierre on 28/09/2014.
//  Copyright (c) 2014 Rajaâ et Pierre. All rights reserved.
//

#import "ww1initiation.h"
@interface ww1initiation()
@property (nonatomic,strong)ww1Recuit*recuit;
@property(nonatomic,strong)ww1Brain*brain;
@end
@implementation ww1initiation
@synthesize recuit=_recuit;
@synthesize brain=_brain;
@synthesize layers=_layers;

-(ww1Brain*)brain
{
    if (!_brain)
    {
        _brain=[[ww1Brain alloc]init];
    }
    return _brain;
}

-(ww1Recuit*)recuit
{
    if (!_recuit)
    {
        _recuit=[[ww1Recuit alloc]init];
    }
    return _recuit;
}

-(NSMutableDictionary*)layers
{
    if (!_layers)
    {
        _layers=[[NSMutableDictionary alloc]init];
    }
    return _layers;
}

-(void)setTheLayers:(NSMutableDictionary *)startLayers
{
    self.layers=[startLayers copy];
}


-(NSMutableArray*)convertToArray:(const int[])inputs
{
    
    NSMutableArray*arrayOfResults=[[NSMutableArray alloc]init];
    for (int i=1; i<=49; i++)
    {
        int flag=0;
        
        for (int j=0; j<17; j++)
        {
            //NSLog([[NSNumber numberWithInt:j]stringValue]);
            
                if(inputs[j]==i & flag==0)
                {
                    /*
                    NSLog(@"valeur");
                    NSLog([[NSNumber numberWithInt:j]stringValue]);
                    NSLog([[NSNumber numberWithInt:inputs[j]]stringValue]);
                    NSLog([[NSNumber numberWithInt:i]stringValue]);
                    */
                     flag=1;
                }
            
            
        }
        if (flag==1)
        {
            
            [arrayOfResults addObject:[NSNumber numberWithInt:1]];
        }
        else
        {
            [arrayOfResults addObject:[NSNumber numberWithInt:0]];
        }
        
    }
    //NSLog(@"new");
    /*
    for (int i=0; i<[arrayOfResults count]; i++)
    {
        if([[arrayOfResults objectAtIndex:i]intValue]==1)
        {
            NSLog([[NSNumber numberWithInt:i+1]stringValue]);
        }
    }
    */
    
    return arrayOfResults;
}

-(int)numberOfDifferentOutputsInTestSample:(NSMutableArray*)testSample
{
    int numberOfOutputs=0;
    NSNumber*thisCharacter=[[NSNumber alloc]init];
    NSMutableArray*currentCharacters=[[NSMutableArray alloc]init];
    for (int i=1; i<=[testSample count]; i++)
    {
        thisCharacter=[[testSample objectAtIndex:i-1]objectAtIndex:0];
        if(![currentCharacters containsObject:thisCharacter])
        {
            numberOfOutputs++;
            [currentCharacters addObject:thisCharacter];
        }
    }
    
    
    return numberOfOutputs;
    
}

-(NSMutableArray*)allAtOne:(int)entries
{
    NSMutableArray*array=[[NSMutableArray alloc]init];
    for (int i=1; i<=entries; i++)
    {
        [array addObject:[NSNumber numberWithFloat:0]];
    }
    return array;
    
}



-(void)initiate:(NSMutableArray*)testSample
{
 /*
    const int a1Inputs[]={44,37,38,31,24,25,17,18,11,04,05,12,13,26,33,34,41};
    const int a2Inputs[]={38,31,24,25,18,11,19,26,33,40,00,00,00,00,00,00,00};
    const int a3Inputs[]={44,37,30,24,25,26,17,10,03,04,11,18,32,33,40,47,00};
    const int b1Inputs[]={38,39,31,32,24,25,17,18,10,11,12,19,00,00,00,00,00};
    const int b2Inputs[]={31,32,24,25,17,18,10,11,03,04,00,00,00,00,00,00,00};
    const int b3Inputs[]={37,38,39,30,31,32,23,24,25,17,18,10,11,03,04,00,00};
    const int d1Inputs[]={10,11,17,19,18,24,26,31,33,38,39,00,00,00,00,00,00};
    const int d2Inputs[]={38,31,24,17,18,11,19,26,33,40,39,00,00,00,00,00,00};
    const int d3Inputs[]={10,17,24,31,38,39,40,33,26,19,12,11,00,00,00,00,00};
    
    NSMutableArray*a1InputsArray=[[NSMutableArray alloc]initWithArray:[self convertToArray:a1Inputs]];
    NSMutableArray*a2InputsArray=[[NSMutableArray alloc]initWithArray:[self convertToArray:a2Inputs]];
    NSMutableArray*a3InputsArray=[[NSMutableArray alloc]initWithArray:[self convertToArray:a3Inputs]];
    NSMutableArray*b1InputsArray=[[NSMutableArray alloc]initWithArray:[self convertToArray:b1Inputs]];
    NSMutableArray*b2InputsArray=[[NSMutableArray alloc]initWithArray:[self convertToArray:b2Inputs]];
    NSMutableArray*b3InputsArray=[[NSMutableArray alloc]initWithArray:[self convertToArray:b3Inputs]];
    NSMutableArray*d1InputsArray=[[NSMutableArray alloc]initWithArray:[self convertToArray:d1Inputs]];
    NSMutableArray*d2InputsArray=[[NSMutableArray alloc]initWithArray:[self convertToArray:d2Inputs]];
    NSMutableArray*d3InputsArray=[[NSMutableArray alloc]initWithArray:[self convertToArray:d3Inputs]];
   
    NSMutableArray*A1=[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInt:1],a1InputsArray ,nil];
    NSMutableArray*A2=[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInt:1],a2InputsArray ,nil];
    NSMutableArray*A3=[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInt:1],a3InputsArray ,nil];
    NSMutableArray*B1=[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInt:2],b1InputsArray ,nil];
    NSMutableArray*B2=[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInt:2],b2InputsArray ,nil];
    NSMutableArray*B3=[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInt:2],b3InputsArray ,nil];
    NSMutableArray*D1=[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInt:3],d1InputsArray ,nil];
    NSMutableArray*D2=[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInt:3],d2InputsArray ,nil];
    NSMutableArray*D3=[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInt:3],d3InputsArray ,nil];
    
    NSMutableArray*testSample=[[NSMutableArray alloc]initWithObjects:A1,A2,A3,B1,B2,B3,D1,D2,D3, nil];
  */
  
    int inputsCount=[[NSNumber numberWithInteger:[[[testSample lastObject]objectAtIndex:1]count] ]intValue ];
    int layer1Count=21;
    int layer2Count=15;
    int outputLayerCount=[self numberOfDifferentOutputsInTestSample:testSample];
    
    NSMutableDictionary*layer1=[[NSMutableDictionary alloc]init];
    
    NSMutableDictionary*layer2=[[NSMutableDictionary alloc]init];
    
    NSMutableDictionary*outputLayer=[[NSMutableDictionary alloc]init];
    for (int i=0; i<layer1Count; i++)
    {
        [layer1 setObject:[self allAtOne:inputsCount] forKey:[[NSNumber numberWithInt:i+1]stringValue]];
    }
    for (int i=0; i<layer2Count; i++)
    {
        [layer2 setObject:[self allAtOne:layer1Count] forKey:[[NSNumber numberWithInt:i+1]stringValue]];
    }
    for (int i=0; i<outputLayerCount; i++)
    {
        [outputLayer setObject:[self allAtOne:layer2Count] forKey:[[NSNumber numberWithInt:i+1]stringValue]];
    }
    /*
    NSMutableDictionary*layer1=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[self allAtOne:49],@"1",[self allAtOne:49],@"2",[self allAtOne:49],@"3",[self allAtOne:49],@"4",[self allAtOne:49],@"5",[self allAtOne:49],@"6",[self allAtOne:49],@"7",[self allAtOne:49],@"8", nil];
    NSMutableDictionary*layer2=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[self allAtOne:8],@"1",[self allAtOne:8],@"2",[self allAtOne:8],@"3",[self allAtOne:8],@"4",[self allAtOne:8],@"5",[self allAtOne:8],@"6",[self allAtOne:8],@"7",[self allAtOne:8],@"8", nil];
    NSMutableDictionary*outputLayer=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[self allAtOne:8],@"1",[self allAtOne:8],@"2",[self allAtOne:8],@"3", nil];
    */
    NSMutableDictionary*network=[[NSMutableDictionary alloc]initWithObjectsAndKeys:layer1,@"layer1",layer2,@"layer2",outputLayer, @"outputLayer",nil];
    
    
    self.layers =[[self.recuit recuit:testSample :[network copy]]mutableCopy];
    //self.layers =[[self.recuit gradientRetroProgramming :testSample :[network copy]]mutableCopy];
    // NSLog(@"fin recuit");
    /*
    NSLog(@"A2");
    NSArray*response=[[NSArray alloc]initWithArray:[self.brain networkOutputs:a2InputsArray :[self.layers objectForKey:@"layer1"] :[self.layers objectForKey:@"layer2"] :[self.layers objectForKey:@"outputLayer"]]];
    NSLog([[response objectAtIndex:0]stringValue]);
    NSLog([[response objectAtIndex:1]stringValue]);
    NSLog([[response objectAtIndex:2]stringValue]);
    
    for (int i=0; i<[d2InputsArray count]; i++)
    {
        if([[d2InputsArray objectAtIndex:i]intValue]==1)
        {
            NSLog([[NSNumber numberWithInt:i+1]stringValue]);
        }
     
        NSLog([[a2InputsArray objectAtIndex:i]stringValue]);
    }
     
    
    NSLog(@"B2");
    NSArray*response1=[[NSArray alloc]initWithArray:[self.brain networkOutputs:b2InputsArray :[self.layers objectForKey:@"layer1"] :[self.layers objectForKey:@"layer2"] :[self.layers objectForKey:@"outputLayer"]]];
    NSLog([[response1 objectAtIndex:0]stringValue]);
    NSLog([[response1 objectAtIndex:1]stringValue]);
    NSLog([[response1 objectAtIndex:2]stringValue]);
    NSLog(@"D2");
    NSArray*response2=[[NSArray alloc]initWithArray:[self.brain networkOutputs:d2InputsArray :[self.layers objectForKey:@"layer1"] :[self.layers objectForKey:@"layer2"] :[self.layers objectForKey:@"outputLayer"]]];
    NSLog([[response2 objectAtIndex:0]stringValue]);
    NSLog([[response2 objectAtIndex:1]stringValue]);
    NSLog([[response2 objectAtIndex:2]stringValue]);
    */

/*
    NSLog(@"weights layer 1");
    for (int i=0; i<[[self.layers objectForKey:@"layer1"]count]; i++)
    {
        NSLog(@"neuron");
        NSLog([[NSNumber numberWithInt:i+1]stringValue]);
        for (int j=0; j<[[[self.layers objectForKey:@"layer1"]objectForKey:[[NSNumber numberWithInt:i+1]stringValue]]count]; j++)
        {
            NSLog([[[[self.layers objectForKey:@"layer1"]objectForKey:[[NSNumber numberWithInt:i+1]stringValue]]objectAtIndex:j]stringValue]);
        }
    }
    
    NSLog(@"weights layer 2");
    for (int i=0; i<[[self.layers objectForKey:@"layer2"]count]; i++)
    {
        NSLog(@"neuron");
        NSLog([[NSNumber numberWithInt:i+1]stringValue]);

        for (int j=0; j<[[[self.layers objectForKey:@"layer2"]objectForKey:[[NSNumber numberWithInt:i+1]stringValue]]count]; j++)
        {
            NSLog([[[[self.layers objectForKey:@"layer2"]objectForKey:[[NSNumber numberWithInt:i+1]stringValue]]objectAtIndex:j]stringValue]);
        }
    }
    NSLog(@"weights outputLayer");
    for (int i=0; i<[[self.layers objectForKey:@"outputLayer"]count]; i++)
    {
        NSLog(@"neuron");
        NSLog([[NSNumber numberWithInt:i+1]stringValue]);

        for (int j=0; j<[[[self.layers objectForKey:@"outputLayer"]objectForKey:[[NSNumber numberWithInt:i+1]stringValue]]count]; j++)
        {
            NSLog([[[[self.layers objectForKey:@"outputLayer"]objectForKey:[[NSNumber numberWithInt:i+1]stringValue]]objectAtIndex:j]stringValue]);
        }
    }
*/
}


@end
