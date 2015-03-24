//
//  CarteSKSpriteNode.m
//  GangOfFourV2
//
//  Created by etudiant-mac-02 on 13/03/2015.
//  Copyright (c) 2015 etudiant-mac-02. All rights reserved.
//

#import "CarteSKSpriteNode.h"

@implementation CarteSKSpriteNode



-(void) initWithAllcarte{
    self.allCartes = [NSMutableArray array];
    NSNumber * carteValue = [NSNumber numberWithInt:1];
    
    do {
        [self.allCartes addObject:carteValue];
        
        if ([carteValue intValue] != 4 && [carteValue intValue] < 32) [self.allCartes addObject:carteValue];
        carteValue =[NSNumber numberWithInt:[carteValue intValue]+1];
    } while ([carteValue intValue] <=34);
       NSLog(@"coucou");
    for (int i = 0; i < 64; i++) {
        int nElements = 64 - i;
        int n = (arc4random() % nElements) + i;
        [self.allCartes exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
 
    
    
   
}

-(void) CarteSpriteNodeWithX:(float) posX Y:(float) posY color:(UIColor *) color name:(NSString *) name frame:(CGRect) rect{
    self.carte = [SKSpriteNode spriteNodeWithColor:color size:CGSizeMake(10, 35)];
    self.carte.position = CGPointMake(CGRectGetMidX(rect)+posX, CGRectGetMidY(rect)+posY);
    self.carte.name = name;
}

-(void) CarteSpriteNodeWithX:(float) posX Y:(float) posY Image:(NSString *) img name:(NSString *) name frame:(CGRect) rect faceCacher:(BOOL) cacher{
    
    
    self.carte = [SKSpriteNode spriteNodeWithImageNamed:img];
    
    if (cacher)
        self.carte.size = CGSizeMake(15, 25);
    else
        self.carte.size = CGSizeMake(20, 30);
    
    self.carte.position = CGPointMake(CGRectGetMidX(rect)+posX, CGRectGetMidY(rect)+posY);
    self.carte.name = name;
}

-(void) setPositionWithPosX:(CGFloat)posX PosY:(CGFloat)posY frame:(CGRect) rect{
     self.carte.position = CGPointMake(CGRectGetMidX(rect)+posX, CGRectGetMidY(rect)+posY);
}



-(NSMutableArray *) Extract16CartesForJoueur:(int) numJoueur{
    NSMutableArray * mainJoueur = [NSMutableArray array];
    for (int i = (numJoueur-1) * 16; i<(numJoueur*16); i++) {
        [mainJoueur addObject:[self.allCartes objectAtIndex:i]];
    }
    NSArray *sortedArray = [mainJoueur sortedArrayUsingComparator: ^(id obj1, id obj2) {
        if ([obj1 integerValue] > [obj2 integerValue])
            return (NSComparisonResult)NSOrderedDescending;

        if ([obj1 integerValue] < [obj2 integerValue])
            return (NSComparisonResult)NSOrderedAscending;
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    return [NSMutableArray arrayWithArray:sortedArray];
}



@end
