//
//  ww1Brain.m
//  WW1
//
//  Created by Rajaâ et Pierre on 23/09/2014.
//  Copyright (c) 2014 Rajaâ et Pierre. All rights reserved.
//

#import "ww1Brain.h"
@interface ww1Brain()
@property(nonatomic,strong)NSMutableArray*points;

@end


@implementation ww1Brain

@synthesize state=_state;
@synthesize points=_points;
@synthesize lastLetter=_lastLetter;

CGPoint position;
int screenSize=160;
bool alreadyLearnedFlag=YES;


-(NSMutableArray*)lastLetter
{
    if (!_lastLetter)
    {
        _lastLetter=[[NSMutableArray alloc]init];
    }
    return _lastLetter;
}

-(NSMutableArray*)points
{
    if (!_points)
    {
        _points=[[NSMutableArray alloc]init];
    }
    return _points;
}

-(NSNumber*)response:(NSArray *)entries :(NSArray*)weights
{
    if ([entries count]!=[weights count])
    {
        NSLog(@"ENTRIES AND WEIGHTS NOT EQUAL");
    }
    NSNumber* response;
    float total=0;
    float limitFloat=0;//[entries count]/4;
    for (int i=0;i<[entries count];i++)
    {   //NSLog(@"######################");
        //if ([entries objectAtIndex:i])
        //{
            NSNumber*lastEntry=[entries objectAtIndex:i];
            //NSLog(@"entry= %@",[lastEntry stringValue]);
            NSNumber*lastWeight=[weights objectAtIndex:i];
            //NSLog(@"weight= %@",[lastWeight stringValue]);
            float lastEntryFloat=[lastEntry floatValue];
            float lastWeightFloat=[lastWeight floatValue];
            total=total+lastEntryFloat*lastWeightFloat;
        //}
        //NSLog(@"total= %@",[[NSNumber numberWithFloat:total]stringValue]);
        response=[NSNumber numberWithFloat:1/(1+expf(-total+limitFloat))];
    }
    //NSLog(@"response= %@",[response stringValue]);
    return response;
    
}
-(NSNumber*)maximumInArray:(NSArray*)myArray
{
    float max=[[myArray objectAtIndex:1]floatValue];
    NSNumber*indexOfMax;
    for (int i=1; i<=[myArray count]; i++)
    {
        
        if ([[myArray objectAtIndex:i]floatValue]>max)
        {
            max=[[myArray objectAtIndex:1]floatValue];
            indexOfMax=[NSNumber numberWithInt:i];
        }
    }
    return indexOfMax;
}

-(BOOL)inputAndOutputMatch:(NSArray *)matrix :(NSDictionary *)firstLayer :(NSDictionary *)secondLayer :(NSDictionary *)outputLayer
{
    //method to check if the inputs in layer one match the matrix and same for all layers
    return YES;
}

-(NSArray*)networkOutputs:(NSArray *)matrix :(NSDictionary *)firstLayer :(NSDictionary *)secondLayer :(NSDictionary *)outputLayer
{   alreadyLearnedFlag=YES;
    if (![self inputAndOutputMatch:(NSArray *)matrix :(NSDictionary *)firstLayer :(NSDictionary *)secondLayer :(NSDictionary *)outputLayer])
    {
        NSLog(@"pas le bon nombre d'entrées");
        return nil;
    }
    NSMutableArray*firstLayerOutputs=[[NSMutableArray alloc]init];
    
    for (int i=1;i<=[firstLayer count] ; i++)
    {
        NSArray*weights=[firstLayer objectForKey:[[NSNumber numberWithInt:i]stringValue]];
        [firstLayerOutputs addObject:[self response:matrix :weights]];
        
    }
    //NSLog([[NSNumber numberWithInt:[firstLayerOutputs count]]stringValue]);
    NSMutableArray*secondLayerOutputs=[[NSMutableArray alloc]init];
    for (int i=1;i<=[secondLayer count] ; i++)
    {
        NSArray*weights=[secondLayer objectForKey:[[NSNumber numberWithInt:i]stringValue]];
        [secondLayerOutputs addObject:[self response:firstLayerOutputs :weights]];
        
    }
    
    NSMutableArray*finalOutputs=[[NSMutableArray alloc]init ];
   
    for (int i=1;i<=[outputLayer count] ; i++)
    {
        NSArray*weights=[outputLayer objectForKey:[[NSNumber numberWithInt:i]stringValue]];
        [finalOutputs addObject:[self response:secondLayerOutputs :weights]];
        
    }
    //NSLog([[NSNumber numberWithInt:[finalOutputs count]]stringValue]);
    //NSNumber*answer=[self maximumInArray:finalOutputs];
    //return [answer stringValue];
    return finalOutputs;
    
}

-(NSArray*)firstLayerOutput:(NSArray *)sample :(NSDictionary *)firstLayer
{
    NSMutableArray*firstLayerOutputs=[[NSMutableArray alloc]init];
    
    for (int i=1;i<=[firstLayer count] ; i++)
    {
        NSArray*weights=[firstLayer objectForKey:[[NSNumber numberWithInt:i]stringValue]];
        [firstLayerOutputs addObject:[self response:sample :weights]];
        
    }
    return firstLayerOutputs;
}
-(NSArray*)secondLayerOutput:(NSArray *)sample :(NSDictionary *)firstLayer :(NSDictionary *)secondLayer
{
    NSMutableArray*firstLayerOutputs=[[NSMutableArray alloc]init];
    
    for (int i=1;i<=[firstLayer count] ; i++)
    {
        NSArray*weights=[firstLayer objectForKey:[[NSNumber numberWithInt:i]stringValue]];
        [firstLayerOutputs addObject:[self response:sample :weights]];
        
    }
    //NSLog([[NSNumber numberWithInt:[firstLayerOutputs count]]stringValue]);
    NSMutableArray*secondLayerOutputs=[[NSMutableArray alloc]init];
    for (int i=1;i<=[secondLayer count] ; i++)
    {
        NSArray*weights=[secondLayer objectForKey:[[NSNumber numberWithInt:i]stringValue]];
        [secondLayerOutputs addObject:[self response:firstLayerOutputs :weights]];
        
    }
    return secondLayerOutputs;
}

-(float)findLeftPoint
{
    float leftPoint=screenSize;
    for (int i=0;i<[self.points count];i++)
                    {
                       for (int j=0; j<[[self.points objectAtIndex:i]count]; j+=2)
                       {
                           if ([[[self.points objectAtIndex:i]objectAtIndex:j]floatValue]<leftPoint)
                           {
                               leftPoint=[[[self.points objectAtIndex:i]objectAtIndex:j]floatValue];
                           }
                       }
                    }
    
    
    return leftPoint;
    
}
-(float)findRightPoint
{
    float rightPoint=0;
    for (int i=0;i<[self.points count];i++)
    {
        for (int j=0; j<[[self.points objectAtIndex:i]count]; j+=2)
        {
            if ([[[self.points objectAtIndex:i]objectAtIndex:j]floatValue]>rightPoint)
            {
                rightPoint=[[[self.points objectAtIndex:i]objectAtIndex:j]floatValue];
            }
        }
    }
    
    
    return rightPoint;
    
}
-(float)findTopPoint
{
    float topPoint=screenSize;
    for (int i=0;i<[self.points count];i++)
    {
        for (int j=1; j<[[self.points objectAtIndex:i]count]; j+=2)
        {
            if ([[[self.points objectAtIndex:i]objectAtIndex:j]floatValue]<topPoint)
            {
                topPoint=[[[self.points objectAtIndex:i]objectAtIndex:j]floatValue];
            }
        }
    }
    
    
    return topPoint;
    
}
-(float)findBottomPoint
{
    float bottomPoint=0;
    for (int i=0;i<[self.points count];i++)
    {
        for (int j=1; j<[[self.points objectAtIndex:i]count]; j+=2)
        {
            if ([[[self.points objectAtIndex:i]objectAtIndex:j]floatValue]>bottomPoint)
            {
                bottomPoint=[[[self.points objectAtIndex:i]objectAtIndex:j]floatValue];
            }
        }
    }
    
    
    return bottomPoint;
    
}
-(float)centeredAndResizedValuefor:(float)current :(float)oneEnd :(float)otherEnd :(float)scaleFactor
{
    float future;
    float centeringFactor=(screenSize-(oneEnd +otherEnd))/2;
    future=current +centeringFactor;
    future=screenSize/2+(future-screenSize/2)*scaleFactor;
    
    
    /*
    oneEnd=oneEnd+centeringFactor;
    otherEnd=otherEnd+centeringFactor;
    future=(future-oneEnd)*scaleFactor;
    */
    return future;
}


-(void)endOfLetter
{
    
    int pixels=20;//pixels per line
    NSMutableArray*sample=[[NSMutableArray alloc]init];
    for (int i=1; i<=pixels*pixels; i++)
    {
        [sample addObject:[NSNumber numberWithFloat:0.0]];
    }
    NSLog(@"sample count= %@",[[NSNumber numberWithInteger:[sample count]]stringValue]);
    NSLog(@"endOfLetter");
    for (int i=0; i<[self.points count]; i++)
    {
        NSLog(@"line # = %@",[NSNumber numberWithInt:i+1]);
        for (int j=0; j<[[self.points objectAtIndex:i]count]; j+=2)
        {
            NSLog(@"X= %@ - Y= %@",[[[self.points objectAtIndex:i]objectAtIndex:j]stringValue],[[[self.points objectAtIndex:i]objectAtIndex:j+1]stringValue]);
        }
    }
    float leftX=[self findLeftPoint];
    float rightX=[self findRightPoint];
    float topY=[self findTopPoint];
    float bottomY=[self findBottomPoint];
    float scaleFactor=1;
    if (fabsf(leftX-rightX)>fabsf(topY-bottomY))
    {
        scaleFactor=screenSize/(rightX-leftX);
    }
    else
    {
        scaleFactor=screenSize/(bottomY-topY);
    }

    
    NSLog(@"leftX= %@ , rightX= %@ , topY= %@ , bottomY = %@",[[NSNumber numberWithFloat:leftX]stringValue],[[NSNumber numberWithFloat:rightX]stringValue],[[NSNumber numberWithFloat:topY]stringValue],[[NSNumber numberWithFloat:bottomY]stringValue]);
    NSLog(@"scaleFactor= %@",[[NSNumber numberWithFloat:scaleFactor]stringValue]);
    for (int i=0; i<[self.points count]; i++)
    {
        for (int j=0; j<[[self.points objectAtIndex:i]count]-2; j+=2)
        {
            float thisX=[self centeredAndResizedValuefor:[[[self.points objectAtIndex:i]objectAtIndex:j]floatValue] :leftX :rightX :scaleFactor];
            float thisY=[self centeredAndResizedValuefor:[[[self.points objectAtIndex:i]objectAtIndex:j+1]floatValue] :topY :bottomY :scaleFactor];
            float nextX=[self centeredAndResizedValuefor:[[[self.points objectAtIndex:i]objectAtIndex:j+2]floatValue] :leftX :rightX : scaleFactor];
            float nextY=[self centeredAndResizedValuefor:[[[self.points objectAtIndex:i]objectAtIndex:j+3]floatValue] :topY :bottomY :scaleFactor];
            NSLog(@"thisX= %@, thisY= %@, nextX= %@, nextY= %@",[[NSNumber numberWithFloat:thisX]stringValue],[[NSNumber numberWithFloat:thisY]stringValue],[[NSNumber numberWithFloat:nextX]stringValue],[[NSNumber numberWithFloat:nextY]stringValue]);
            float distance=sqrtf((nextX -thisX)*(nextX-thisX)+(nextY-thisY)*(nextY-thisY));
            NSLog(@"distance= %@",[[NSNumber numberWithFloat:distance]stringValue]);
            
            int numberOfPixels;
            if (distance==0)
                {numberOfPixels=1;}
            else
                {numberOfPixels=ceilf(distance*pixels/screenSize)+1;}
            NSLog(@"numberOfPixels= %@",[[NSNumber numberWithInt:numberOfPixels]stringValue]);
            for (int k=1; k<=numberOfPixels; k++)
            {
                int pixelX=ceilf(((nextX-thisX)*k/numberOfPixels+thisX)*pixels/screenSize);
                int pixelY=ceilf(((nextY-thisY)*k/numberOfPixels+thisY)*pixels/screenSize);
                if (pixelX==0) {pixelX=1;}
                if (pixelY==0) {pixelY=1;}
                [sample setObject:[NSNumber numberWithFloat:1.0] atIndexedSubscript:(pixelY-1)*pixels+pixelX-1];
                NSLog(@"pixelX= %@ , pixelY =%@",[[NSNumber numberWithInt:pixelX]stringValue],[[NSNumber numberWithInt:pixelY]stringValue]);
            }
        }
    }
   
    NSLog(@"sample count= %@",[[NSNumber numberWithInteger:[sample count]]stringValue]);
    [self.lastLetter removeAllObjects];
    [self.lastLetter addObjectsFromArray:sample];
    [self.points removeAllObjects];
    if (alreadyLearnedFlag)
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"endOfCharacter"
         object:self];
    }
    else
    {
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"characterToLearn"
         object:self];
    }
}

-(void)getXY:(CGPoint)position :(CGPoint)move
{
    //NSLog(self.state);
    
    if ([self.state isEqualToString:@"start"])
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endOfLetter) object:nil];
        NSMutableArray*thisLine=[[NSMutableArray alloc]init];
        [thisLine addObject:[NSNumber numberWithFloat:position.x]];
        [thisLine addObject:[NSNumber numberWithFloat:position.y]];
        [self.points addObject:thisLine];
    }
    if ([self.state isEqualToString:@"ongoing"])
    {
        float x=[[[self.points lastObject]objectAtIndex:[[self.points lastObject]count]-2]floatValue]+move.x;
        if (x<0) {x=0;}
        if (x>screenSize) {x=screenSize;}
        [[self.points lastObject]addObject:[NSNumber numberWithFloat:x]];
        
        float y=[[[self.points lastObject]objectAtIndex:[[self.points lastObject]count]-2]floatValue]+move.y;
        if (y<0) {y=0;}
        if (y>screenSize) {y=screenSize;}
        [[self.points lastObject]addObject:[NSNumber numberWithFloat:y]];
    }
    if ([self.state isEqualToString:@"end"])
    {
        float x=[[[self.points lastObject]objectAtIndex:[[self.points lastObject]count]-2]floatValue]+move.x;
        if (x<0) {x=0;}
        if (x>screenSize) {x=screenSize;}
        [[self.points lastObject]addObject:[NSNumber numberWithFloat:x]];
        
        float y=[[[self.points lastObject]objectAtIndex:[[self.points lastObject]count]-2]floatValue]+move.y;
        if (y<0) {y=0;}
        if (y>screenSize) {y=screenSize;}
        [[self.points lastObject]addObject:[NSNumber numberWithFloat:y]];
        
        [self performSelector:@selector(endOfLetter) withObject:nil afterDelay:1.0];
    }
    
        
}


@end
