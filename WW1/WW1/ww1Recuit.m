//
//  ww1Recuit.m
//  WW1
//
//  Created by Rajaâ et Pierre on 27/09/2014.
//  Copyright (c) 2014 Rajaâ et Pierre. All rights reserved.
//

#import "ww1Recuit.h"
@interface ww1Recuit()

@property (nonatomic,strong)ww1Brain*brain;
@end


@implementation ww1Recuit
#define ARC4RANDOM_MAX      0x100000000
@synthesize brain=_brain;
-(ww1Brain*)brain
{
    if (!_brain)
    {
        _brain=[[ww1Brain alloc]init];
    }
    return _brain;
}

-(NSMutableDictionary*)retro:(NSArray*)testSample : (NSMutableDictionary*)layers;
{
    NSMutableDictionary*newLayers=[[NSMutableDictionary alloc]initWithDictionary:layers];
    NSLog(@"retro start");
    for (int characterNumber=1; characterNumber<=[testSample count];characterNumber++)
    {
        NSNumber*character=[[testSample objectAtIndex:characterNumber-1]objectAtIndex:0];
        
        //NSLog([character stringValue]);
        
        NSArray*sample=[[testSample objectAtIndex:characterNumber-1]objectAtIndex:1];
        NSArray*feedback=[self.brain networkOutputs:sample :[layers objectForKey:@"layer1"] :[layers objectForKey:@"layer2"] :[layers objectForKey:@"outputLayer"]    ];
       // NSLog(@"start");
        NSMutableArray*diArray=[[NSMutableArray alloc]init];
        for (int outputNumber=1; outputNumber<=[feedback count]; outputNumber++)
        {
            float expectedOutput=0;
            if([character intValue]==outputNumber)
                {expectedOutput=0.99;}
            else
                { expectedOutput=0.01;}
            //erreur=expectedOutput-[[feedback objectAtIndex:j-1]floatValue];
            
            NSMutableDictionary* outputLayer=[[NSMutableDictionary alloc]initWithDictionary:[layers objectForKey:@"outputLayer"]];
            NSMutableDictionary*    layer1=[[NSMutableDictionary alloc]initWithDictionary:[layers objectForKey:@"layer1"]];
            NSMutableDictionary*    layer2=[[NSMutableDictionary alloc]initWithDictionary:[layers objectForKey:@"layer2"]];
            float epsilon =0.5;
            float si=expectedOutput;
            float yi=[[feedback objectAtIndex:outputNumber-1]floatValue];
            float di = si*(1-si)*(yi-si);
            /*
            NSLog(@"outputNumber= %@",[[NSNumber numberWithInt:outputNumber]stringValue]);
            NSLog(@"yi= %@",[[NSNumber numberWithFloat:yi]stringValue]);
            NSLog(@"si= %@",[[NSNumber numberWithFloat:si]stringValue]);
            NSLog(@"di= %@",[[NSNumber numberWithFloat:di]stringValue]);
            */
            
            
            [diArray addObject:[NSNumber numberWithFloat:di]];
            //for (int outputNeuronNumber=1; outputNeuronNumber<=[outputLayer count]; outputNeuronNumber++)
            //{
                NSMutableArray*thisNeuron=[outputLayer objectForKey:[[NSNumber numberWithInt:outputNumber]stringValue] ];
                
                for (int thisNeuronsWeightIndex=1; thisNeuronsWeightIndex<=[thisNeuron count]; thisNeuronsWeightIndex++)
                {
                    
                    
                    float weight;
                    float wi=[[[self.brain secondLayerOutput:sample :layer1 :layer2]objectAtIndex:thisNeuronsWeightIndex-1]floatValue];
                    weight= [[thisNeuron objectAtIndex:thisNeuronsWeightIndex-1]floatValue];
                    /*
                    NSLog(@"characterNumber= %@",[[NSNumber numberWithInt:characterNumber]stringValue]  );
                    NSLog(@"outputNumber= %@",[[NSNumber numberWithInt:outputNumber]stringValue]);
                    NSLog(@"thisNeuronsWeightIndex= %@", [[NSNumber numberWithInt:thisNeuronsWeightIndex]stringValue]);
                    NSLog(@"old weight= %@",[[NSNumber numberWithFloat:weight]stringValue]);
                    NSLog(@"epsilon= %@",[[NSNumber numberWithFloat:epsilon]stringValue]);
                    NSLog(@"di= %@",[[NSNumber numberWithFloat:di]stringValue]);
                    NSLog(@"wi= %@",[[NSNumber numberWithFloat:wi]stringValue]);
                    */
                    weight=weight+ epsilon * di*wi;
                    //NSLog(@"weight= %@",[[NSNumber numberWithFloat:weight]stringValue]);
                    [[[newLayers objectForKey:@"outputLayer"]objectForKey:[[NSNumber numberWithInt:outputNumber ]stringValue] ] setObject:[NSNumber numberWithFloat:weight] atIndex:thisNeuronsWeightIndex-1];
                    
               // }
                
            }
         //   NSLog(@"outputLayer done");
            NSMutableArray*di1Array=[[NSMutableArray alloc]init];
            for (int layer2NeuronNumber=1; layer2NeuronNumber<=[layer2 count]; layer2NeuronNumber++)
            {
                
                NSMutableArray*thisNeuron=[layer2 objectForKey:[[NSNumber numberWithInt:layer2NeuronNumber]stringValue] ];
                float di;
                float somme=0;
                float oi=[[[self.brain secondLayerOutput:sample :layer1 :layer2]objectAtIndex:layer2NeuronNumber-1]floatValue];
                for (int nextLayerNeuron=1; nextLayerNeuron<=[diArray count]; nextLayerNeuron++)
                {
                    float dk=[[diArray objectAtIndex:nextLayerNeuron-1]floatValue];
                    
                    
                    
                    float wki=[[[outputLayer objectForKey:[[NSNumber numberWithInt:nextLayerNeuron]stringValue]]objectAtIndex:layer2NeuronNumber-1 ] floatValue];
                    somme=somme+dk*wki;
                    
                }
                di=oi*(1-oi)*somme;
                [di1Array addObject:[NSNumber numberWithFloat:di]];

                for (int thisNeuronWeightIndex=1; thisNeuronWeightIndex<=[thisNeuron count]; thisNeuronWeightIndex++)
                {
                    
                    float weight;
                    weight=[[thisNeuron objectAtIndex:thisNeuronWeightIndex-1]floatValue] + epsilon * di*[[[self.brain firstLayerOutput:sample :layer1]objectAtIndex:layer2NeuronNumber-1]floatValue];
                    [[[newLayers objectForKey:@"layer2"]objectForKey:[[NSNumber numberWithInt:layer2NeuronNumber]stringValue] ] setObject:[NSNumber numberWithFloat:weight] atIndex:thisNeuronWeightIndex-1];
                    
                }
                
            }
           // NSLog(@"layer2 done");
            
            for (int layer1NeuronNumber=1; layer1NeuronNumber<=[layer1 count]; layer1NeuronNumber++)
            {
                
                NSMutableArray*thisNeuron=[layer1 objectForKey:[[NSNumber numberWithInt:layer1NeuronNumber]stringValue] ];
                float di;
                float somme=0;
                float oi=[[[self.brain firstLayerOutput:sample :layer1]objectAtIndex:layer1NeuronNumber-1]floatValue];
               // NSLog(@"ici %@",[[NSNumber numberWithInt:layer1NeuronNumber]stringValue]);
                for (int nextLayerNeuron=1; nextLayerNeuron<=[di1Array count]; nextLayerNeuron++)
                {   float dk=[[di1Array objectAtIndex:nextLayerNeuron-1] floatValue];
                    float wki=[[[layer2 objectForKey:[[NSNumber numberWithInt:nextLayerNeuron]stringValue]]objectAtIndex:layer1NeuronNumber-1] floatValue];
                    somme=somme+dk*wki;
                  //  NSLog(@"là %@", [[NSNumber numberWithInt:nextLayerNeuron]stringValue]);
                }
                di=oi*(1-oi)*somme;

                for (int thisNeuronWeightIndex=1; thisNeuronWeightIndex<=[thisNeuron count]; thisNeuronWeightIndex++)
                {
                    
                    float weight;
                    weight=[[thisNeuron objectAtIndex:thisNeuronWeightIndex-1]floatValue] + epsilon * di*[[sample objectAtIndex:thisNeuronWeightIndex-1]floatValue];
                    [[[newLayers objectForKey:@"layer1"]objectForKey:[[NSNumber numberWithInt:layer1NeuronNumber ]stringValue] ] setObject:[NSNumber numberWithFloat:weight] atIndex:thisNeuronWeightIndex-1];
                    
                }
                
            }

            
            
            
            
            
    }
    }
    
    
    
    //NSLog(@"done");
    return newLayers;
                           
}


-(float)process:(NSArray*)testSample :(NSMutableDictionary*)layers;
{
    
    float result=0.0;
   // NSLog(@"NEW ITERATION ##########");
    for(int i=0;i<[testSample count];i++)
    {
        NSNumber*character=[[testSample objectAtIndex:i]objectAtIndex:0];
        
        //NSLog([character stringValue]);
        
        
        
        NSArray*sample=[[testSample objectAtIndex:i]objectAtIndex:1];
        /*for (int i=0; i<[sample count]; i++)
        {
             if([[sample objectAtIndex:i]intValue]==1)
             {
             NSLog([[NSNumber numberWithInt:i+1]stringValue]);
             }
            
            //NSLog([[d2InputsArray objectAtIndex:i]stringValue]);
        }*/
        NSArray*feedback=[self.brain networkOutputs:sample :[layers objectForKey:@"layer1"] :[layers objectForKey:@"layer2"] :[layers objectForKey:@"outputLayer"]    ];
       // NSLog([[NSNumber numberWithInt:[feedback count]]stringValue]);
        //NSLog(@"new character");
        
        for (int j=1; j<=[feedback count]; j++)
        {
            if([character intValue]==j)
                
            {
                //NSLog(@"character");
                int overWeight=[[NSNumber numberWithInteger:[feedback count]]intValue]-1;
                //NSLog(@"overweight = %@",[[NSNumber numberWithInt:overWeight]stringValue]);
                result=result+overWeight*(1-[[feedback objectAtIndex:j-1]floatValue]);//*(1-[[feedback objectAtIndex:j-1]floatValue]);
            }
            else
            {   //NSLog(@"not character");
                result=result+[[feedback objectAtIndex:j-1]floatValue];//*[[feedback objectAtIndex:j-1]floatValue];
            }
        
            //NSLog([[feedback objectAtIndex:j-1]stringValue]);
            //NSLog(@"result");
            // NSLog([[NSNumber numberWithFloat:result]stringValue]);
        }
        
    }
    //NSLog([[NSNumber numberWithFloat:result]stringValue]);
    result=result*100;
    return result;
}













-(NSString*)layerToModify:layers
{
    NSString*layerToModify;
    
    
    NSMutableDictionary*layer1=[[NSMutableDictionary alloc]initWithDictionary:[layers objectForKey:@"layer1"]];
    NSMutableDictionary*layer2=[[NSMutableDictionary alloc]initWithDictionary:[layers objectForKey:@"layer2"]];
    NSMutableDictionary*outputLayer=[[NSMutableDictionary alloc]initWithDictionary:[layers objectForKey:@"outputLayer"]];
    float layer1Count=[layer1 count];
    float layer1WeightsCount=[[layer1 objectForKey:@"1"]count];
    float layer2Count=[layer1 count];
    float layer2WeightsCount=[[layer2 objectForKey:@"1"]count];
    float outputLayerCount=[outputLayer count];
    float outputLayerWeightsCount=[[outputLayer objectForKey:@"1"]count];
    float layer1TotalWeightCount=layer1Count*layer1WeightsCount;
    float layer2TotalWeightCount=layer2Count*layer2WeightsCount;
    float outputLayerTotalWeightCount=outputLayerCount*outputLayerWeightsCount;
    float totalWeightCount=layer1TotalWeightCount+layer2TotalWeightCount+outputLayerTotalWeightCount;
    float randomLayer=arc4random();
    float percentageOfNeuronsInLayer1=layer1TotalWeightCount/totalWeightCount;
    float percentageOfNeuronsInLayers1and2=(layer1TotalWeightCount+layer2TotalWeightCount)/totalWeightCount;
    randomLayer=randomLayer/ARC4RANDOM_MAX;
    
    if (randomLayer<percentageOfNeuronsInLayer1)
    {   //NSLog(@"layer 1");
        layerToModify=@"layer1";
    }
    else if (randomLayer<percentageOfNeuronsInLayers1and2)
    {   //NSLog(@"layer 2");
        layerToModify=@"layer2";
    }
    else
    {   //NSLog(@"output layer");
        layerToModify=@"outputLayer";
    }

    
    return layerToModify;
}
-(NSString*)neuronToModify:layer
{
    
    float randomNumber=arc4random();
    
    NSString* randomNeuron=[[NSNumber numberWithInt:ceilf(randomNumber*[layer count]/ARC4RANDOM_MAX)]stringValue];
    
    return randomNeuron;
}
-(int)weightToModify:neuron
{
    
    float randomNumber=arc4random();
    
    int randomWeight=ceilf(randomNumber*[neuron count]/ARC4RANDOM_MAX)-1;
    
    return randomWeight;
}
-(float)increment
{
    
    float increments=3;
    float randomNumber0=arc4random();
    randomNumber0=randomNumber0/ARC4RANDOM_MAX;
    //NSLog([[NSNumber numberWithFloat:randomNumber0]stringValue]);
    if (randomNumber0<0.5)
    {
        increments=-increments;
    }

    
    return increments;
}
-(int)numberOfWeights:(NSMutableDictionary*)layers
{
    int numberOfWeights=0;
    NSMutableDictionary*layer1=[[NSMutableDictionary alloc]initWithDictionary:[layers objectForKey:@"layer1"]];
    NSMutableDictionary*layer2=[[NSMutableDictionary alloc]initWithDictionary:[layers objectForKey:@"layer2"]];
    NSMutableDictionary*outputLayer=[[NSMutableDictionary alloc]initWithDictionary:[layers objectForKey:@"outputLayer"]];
    float layer1Count=[layer1 count];
    float layer1WeightsCount=[[layer1 objectForKey:@"1"]count];
    float layer2Count=[layer1 count];
    float layer2WeightsCount=[[layer2 objectForKey:@"1"]count];
    float outputLayerCount=[outputLayer count];
    float outputLayerWeightsCount=[[outputLayer objectForKey:@"1"]count];
    float layer1TotalWeightCount=layer1Count*layer1WeightsCount;
    float layer2TotalWeightCount=layer2Count*layer2WeightsCount;
    float outputLayerTotalWeightCount=outputLayerCount*outputLayerWeightsCount;
    numberOfWeights=layer1TotalWeightCount+layer2TotalWeightCount+outputLayerTotalWeightCount;
    
    
    
    return numberOfWeights;
}



-(NSDictionary*)recuit:(NSArray*)testSample :(NSMutableDictionary*)layers;
{
    NSMutableDictionary*bestLayers=[[NSMutableDictionary alloc]init];
    
    int maxIteration=30*[self numberOfWeights:layers];
    NSLog(@"iteration : %@",[[NSNumber numberWithInt:maxIteration]stringValue]);
    float InitialTemperature=25;
    float temperature=InitialTemperature;
    float distanceToZero=1000000;
    int bestDistanceToZero=distanceToZero;
    float previousDistanceToZero=distanceToZero;
    int showResult=0;
    
    for (int i=1; i<=maxIteration; i++)
    {
        showResult++;
        NSString*layerToModify0=[self layerToModify:layers];
        /*
        NSString*layerToModify1=[self layerToModify:layers];
        NSString*layerToModify2=[self layerToModify:layers];
        NSString*layerToModify3=[self layerToModify:layers];
        NSString*layerToModify4=[self layerToModify:layers];
        NSString*layerToModify5=[self layerToModify:layers];
        NSString*layerToModify6=[self layerToModify:layers];
        NSString*layerToModify7=[self layerToModify:layers];
        NSString*layerToModify8=[self layerToModify:layers];
        NSString*layerToModify9=[self layerToModify:layers];
        */
        NSString*neuronToModify0=[self neuronToModify:[layers objectForKey:layerToModify0]];
        /*
        NSString*neuronToModify1=[self neuronToModify:[layers objectForKey:layerToModify1]];
        NSString*neuronToModify2=[self neuronToModify:[layers objectForKey:layerToModify2]];
        NSString*neuronToModify3=[self neuronToModify:[layers objectForKey:layerToModify3]];
        NSString*neuronToModify4=[self neuronToModify:[layers objectForKey:layerToModify4]];
        NSString*neuronToModify5=[self neuronToModify:[layers objectForKey:layerToModify5]];
        NSString*neuronToModify6=[self neuronToModify:[layers objectForKey:layerToModify6]];
        NSString*neuronToModify7=[self neuronToModify:[layers objectForKey:layerToModify7]];
        NSString*neuronToModify8=[self neuronToModify:[layers objectForKey:layerToModify8]];
        NSString*neuronToModify9=[self neuronToModify:[layers objectForKey:layerToModify9]];
        */
         float increment;
        float weight;
        int weightToModify0=[self weightToModify:[[layers objectForKey:layerToModify0]objectForKey:neuronToModify0]];
        increment=[self increment];
        float previousWeight0=[[[[layers objectForKey:layerToModify0]objectForKey:neuronToModify0]objectAtIndex:weightToModify0] floatValue];
        weight=previousWeight0+increment;
        if (weight>9) {weight=previousWeight0-increment;}
        if (weight<-9) {weight=previousWeight0-increment;}
        
        [[[layers objectForKey:layerToModify0]objectForKey:neuronToModify0]setObject:[NSNumber numberWithFloat:weight] atIndex:weightToModify0];
        /*
        int weightToModify1=[self weightToModify:[[layers objectForKey:layerToModify1]objectForKey:neuronToModify1]];
        increment=[self increment];
        float previousWeight1=[[[[layers objectForKey:layerToModify1]objectForKey:neuronToModify1]objectAtIndex:weightToModify1] floatValue];
        weight=previousWeight1+increment;
        if (weight>9) {weight=previousWeight1-increment;}
        if (weight<-9) {weight=previousWeight1-increment;}
        
        [[[layers objectForKey:layerToModify1]objectForKey:neuronToModify1]setObject:[NSNumber numberWithFloat:weight] atIndex:weightToModify1];
        
        int weightToModify2=[self weightToModify:[[layers objectForKey:layerToModify2]objectForKey:neuronToModify2]];
        increment=[self increment];
        float previousWeight2=[[[[layers objectForKey:layerToModify2]objectForKey:neuronToModify2]objectAtIndex:weightToModify2] floatValue];
        weight=previousWeight2+increment;
        if (weight>9) {weight=previousWeight2-increment;}
        if (weight<-9) {weight=previousWeight2-increment;}
        
        [[[layers objectForKey:layerToModify2]objectForKey:neuronToModify2]setObject:[NSNumber numberWithFloat:weight] atIndex:weightToModify2];
        
        int weightToModify3=[self weightToModify:[[layers objectForKey:layerToModify3]objectForKey:neuronToModify3]];
        increment=[self increment];
        float previousWeight3=[[[[layers objectForKey:layerToModify3]objectForKey:neuronToModify3]objectAtIndex:weightToModify3] floatValue];
        weight=previousWeight0+increment;
        if (weight>9) {weight=previousWeight3-increment;}
        if (weight<-9) {weight=previousWeight3-increment;}
        
        [[[layers objectForKey:layerToModify3]objectForKey:neuronToModify3]setObject:[NSNumber numberWithFloat:weight] atIndex:weightToModify3];
        
        int weightToModify4=[self weightToModify:[[layers objectForKey:layerToModify4]objectForKey:neuronToModify4]];
        increment=[self increment];
        float previousWeight4=[[[[layers objectForKey:layerToModify4]objectForKey:neuronToModify4]objectAtIndex:weightToModify4] floatValue];
        weight=previousWeight4+increment;
        if (weight>9) {weight=previousWeight4-increment;}
        if (weight<-9) {weight=previousWeight4-increment;}
        
        [[[layers objectForKey:layerToModify4]objectForKey:neuronToModify4]setObject:[NSNumber numberWithFloat:weight] atIndex:weightToModify4];
        
        int weightToModify5=[self weightToModify:[[layers objectForKey:layerToModify5]objectForKey:neuronToModify5]];
        increment=[self increment];
        float previousWeight5=[[[[layers objectForKey:layerToModify5]objectForKey:neuronToModify5]objectAtIndex:weightToModify5] floatValue];
        weight=previousWeight5+increment;
        if (weight>9) {weight=previousWeight5-increment;}
        if (weight<-9) {weight=previousWeight5-increment;}
        
        [[[layers objectForKey:layerToModify5]objectForKey:neuronToModify5]setObject:[NSNumber numberWithFloat:weight] atIndex:weightToModify5];
        
        int weightToModify6=[self weightToModify:[[layers objectForKey:layerToModify6]objectForKey:neuronToModify6]];
        increment=[self increment];
        float previousWeight6=[[[[layers objectForKey:layerToModify6]objectForKey:neuronToModify6]objectAtIndex:weightToModify6] floatValue];
        weight=previousWeight6+increment;
        if (weight>9) {weight=previousWeight6-increment;}
        if (weight<-9) {weight=previousWeight6-increment;}
        
        [[[layers objectForKey:layerToModify6]objectForKey:neuronToModify6]setObject:[NSNumber numberWithFloat:weight] atIndex:weightToModify6];
        
        int weightToModify7=[self weightToModify:[[layers objectForKey:layerToModify7]objectForKey:neuronToModify7]];
        increment=[self increment];
        float previousWeight7=[[[[layers objectForKey:layerToModify7]objectForKey:neuronToModify7]objectAtIndex:weightToModify7] floatValue];
        weight=previousWeight7+increment;
        if (weight>9) {weight=previousWeight7-increment;}
        if (weight<-9) {weight=previousWeight7-increment;}
        
        [[[layers objectForKey:layerToModify7]objectForKey:neuronToModify7]setObject:[NSNumber numberWithFloat:weight] atIndex:weightToModify7];
        
        
        int weightToModify8=[self weightToModify:[[layers objectForKey:layerToModify8]objectForKey:neuronToModify8]];
        increment=[self increment];
        float previousWeight8=[[[[layers objectForKey:layerToModify8]objectForKey:neuronToModify8]objectAtIndex:weightToModify8] floatValue];
        weight=previousWeight8+increment;
        if (weight>9) {weight=previousWeight8-increment;}
        if (weight<-9) {weight=previousWeight8-increment;}
        
        [[[layers objectForKey:layerToModify8]objectForKey:neuronToModify8]setObject:[NSNumber numberWithFloat:weight] atIndex:weightToModify8];
        
        int weightToModify9=[self weightToModify:[[layers objectForKey:layerToModify9]objectForKey:neuronToModify9]];
        increment=[self increment];
        float previousWeight9=[[[[layers objectForKey:layerToModify9]objectForKey:neuronToModify9]objectAtIndex:weightToModify9] floatValue];
        weight=previousWeight9+increment;
        if (weight>9) {weight=previousWeight9-increment;}
        if (weight<-9) {weight=previousWeight9-increment;}
        
        [[[layers objectForKey:layerToModify9]objectForKey:neuronToModify9]setObject:[NSNumber numberWithFloat:weight] atIndex:weightToModify9];
        
        */
        
        
        
        
        
        distanceToZero=[self process:(NSArray*)testSample :(NSMutableDictionary*)layers];
        float testCheck=expf(-(distanceToZero-previousDistanceToZero)/temperature);
        float randomNumber=arc4random();
        
        
        randomNumber=randomNumber/ARC4RANDOM_MAX;
        //NSLog([[NSNumber numberWithFloat:previousDistanceToZero]stringValue]);
        //NSLog([[NSNumber numberWithFloat:testCheck]stringValue]);
        //NSLog([[NSNumber numberWithFloat:randomNumber]stringValue]);
        
    
        if (showResult==500)
        {
        
        //NSLog(@"Iteration : %@ - distance to zero : %@ - previous distance to zero : %@ - random number : %@ - testcheck : %@",[[NSNumber numberWithInt:i]stringValue],[[NSNumber numberWithFloat:distanceToZero]stringValue],[[NSNumber numberWithFloat:previousDistanceToZero]stringValue],[[NSNumber numberWithFloat:randomNumber]stringValue],[[NSNumber numberWithFloat:testCheck]stringValue]);
            NSLog(@"Iteration : %@ - distance to zero : %@ ",[[NSNumber numberWithInt:i]stringValue],[[NSNumber numberWithFloat:distanceToZero]stringValue]);
            showResult=0;
        }
        if (distanceToZero<previousDistanceToZero)
        {
            
            previousDistanceToZero=distanceToZero;
            //NSLog(@"newLayer lower distance");
            if (distanceToZero<bestDistanceToZero)
            {
                bestLayers=[layers copy];
                bestDistanceToZero=distanceToZero;
            }
            
        }
        else if (randomNumber<testCheck)
        {
            
            previousDistanceToZero=distanceToZero;
            //NSLog(@"newLayer random");
        }
        else
        {
            [[[layers objectForKey:layerToModify0]objectForKey:neuronToModify0]setObject:[NSNumber numberWithFloat:previousWeight0] atIndex:weightToModify0];
            /*
            [[[layers objectForKey:layerToModify1]objectForKey:neuronToModify1]setObject:[NSNumber numberWithFloat:previousWeight1] atIndex:weightToModify1];
            [[[layers objectForKey:layerToModify2]objectForKey:neuronToModify2]setObject:[NSNumber numberWithFloat:previousWeight2] atIndex:weightToModify2];
            [[[layers objectForKey:layerToModify3]objectForKey:neuronToModify3]setObject:[NSNumber numberWithFloat:previousWeight3] atIndex:weightToModify3];
            [[[layers objectForKey:layerToModify4]objectForKey:neuronToModify4]setObject:[NSNumber numberWithFloat:previousWeight4] atIndex:weightToModify4];
            [[[layers objectForKey:layerToModify5]objectForKey:neuronToModify5]setObject:[NSNumber numberWithFloat:previousWeight5] atIndex:weightToModify5];
            [[[layers objectForKey:layerToModify6]objectForKey:neuronToModify6]setObject:[NSNumber numberWithFloat:previousWeight6] atIndex:weightToModify6];
            [[[layers objectForKey:layerToModify7]objectForKey:neuronToModify7]setObject:[NSNumber numberWithFloat:previousWeight7] atIndex:weightToModify7];
            [[[layers objectForKey:layerToModify8]objectForKey:neuronToModify8]setObject:[NSNumber numberWithFloat:previousWeight8] atIndex:weightToModify8];
            [[[layers objectForKey:layerToModify9]objectForKey:neuronToModify9]setObject:[NSNumber numberWithFloat:previousWeight9] atIndex:weightToModify9];
            */
            
            
            
            
            
            //NSLog(@"oldLayer");
        }
        temperature=temperature-InitialTemperature/maxIteration;
        //NSLog([[NSNumber numberWithFloat:temperature]stringValue]);

        
        
    }
    
    [self logLayers:bestLayers];
    
    
    return bestLayers;
}

-(NSDictionary*)gradientRetroProgramming:(NSArray *)testSample :(NSMutableDictionary *)layers
{
    NSLog(@"start");
    
    
    int maxIteration=1*[self numberOfWeights:layers];
    NSLog(@"iteration : %@",[[NSNumber numberWithInt:maxIteration]stringValue]);
    
    
    int showResult=0;
    
    for (int i=1; i<=maxIteration; i++)
    {
        showResult++;
        layers=[[self retro:testSample :layers]mutableCopy];
        
        
        if (showResult==1)
        {
            float distanceToZero=[self process:(NSArray*)testSample :(NSMutableDictionary*)layers];
            
            NSLog(@"Iteration : %@ - distance to zero : %@",[[NSNumber numberWithInt:i]stringValue],[[NSNumber numberWithFloat:distanceToZero]stringValue]);
            showResult=0;
        }
        
        
        
    }
    
    [self logLayers:layers];
    
    
    return layers;
}





-(void)logLayers:layers
{
    
    NSLog(@"weights layer 1");
    for (int i=0; i<[[layers objectForKey:@"layer1"]count]; i++)
    {
        NSLog(@"neuron %@",[[NSNumber numberWithInt:i+1]stringValue]);
        NSString*weightsString=[[NSString alloc]init];
        for (int j=0; j<[[[layers objectForKey:@"layer1"]objectForKey:[[NSNumber numberWithInt:i+1]stringValue]]count]; j++)
        {
            
            weightsString=[weightsString stringByAppendingString:@"#"];
            
            weightsString=[weightsString stringByAppendingString:[[[[layers objectForKey:@"layer1"]objectForKey:[[NSNumber numberWithInt:i+1]stringValue]]objectAtIndex:j]stringValue]];
           
        }
       // NSLog(weightsString);
    }
    
    NSLog(@"weights layer 2");
    for (int i=0; i<[[layers objectForKey:@"layer2"]count]; i++)
    {
        NSLog(@"neuron %@",[[NSNumber numberWithInt:i+1]stringValue]);
        NSString*weightsString=[[NSString alloc]init];
        for (int j=0; j<[[[layers objectForKey:@"layer2"]objectForKey:[[NSNumber numberWithInt:i+1]stringValue]]count]; j++)
        {
            
            weightsString=[weightsString stringByAppendingString:@"#"];
            
            weightsString=[weightsString stringByAppendingString:[[[[layers objectForKey:@"layer2"]objectForKey:[[NSNumber numberWithInt:i+1]stringValue]]objectAtIndex:j]stringValue]];
            
        }
       // NSLog(weightsString);
    }
    NSLog(@"weights outputLayer");
    for (int i=0; i<[[layers objectForKey:@"outputLayer"]count]; i++)
    {
        NSLog(@"neuron %@",[[NSNumber numberWithInt:i+1]stringValue]);
        NSString*weightsString=[[NSString alloc]init];
        for (int j=0; j<[[[layers objectForKey:@"outputLayer"]objectForKey:[[NSNumber numberWithInt:i+1]stringValue]]count]; j++)
        {
            
            weightsString=[weightsString stringByAppendingString:@"#"];
            
            weightsString=[weightsString stringByAppendingString:[[[[layers objectForKey:@"outputLayer"]objectForKey:[[NSNumber numberWithInt:i+1]stringValue]]objectAtIndex:j]stringValue]];
            
        }
      //  NSLog(weightsString);
    }

}




@end
