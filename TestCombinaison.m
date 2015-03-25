//
//  TestCombinaison.m
//  GangOfFourV2
//
//  Created by etudiant-mac-02 on 23/03/2015.
//  Copyright (c) 2015 etudiant-mac-02. All rights reserved.
//

#import "TestCombinaison.h"

@implementation TestCombinaison

 
-(int) ValeurCarte:(int) carte{
    if (carte <= 4)
        return 1;
    else
        return 1 + ((carte - 2)/3);
}


-(int) CouleurCarte:(int) carte{
    if (carte<=4)
        return carte -1;
    else
        return ((carte - 2)%3);
}


-(int) nombreCarte:(NSArray *) arraycarte{
    return arraycarte.count;
}


-(BOOL) checkSameCouleur:(NSArray *) arraycarte{
    int indexCarte = 1;

    while (indexCarte < arraycarte.count && [self CouleurCarte:[[arraycarte objectAtIndex:indexCarte] integerValue] ] == [self CouleurCarte:[[arraycarte objectAtIndex:indexCarte-1] integerValue] ])
        indexCarte++;
        
    if (indexCarte == arraycarte.count)
        return YES;

        
    return NO;
}

-(BOOL) checkSameValue:(NSArray *)arraycarte{
    int indexCarte = 1;

    while (indexCarte < arraycarte.count && [self ValeurCarte:[[arraycarte objectAtIndex:indexCarte] integerValue] ] == [self ValeurCarte:[[arraycarte objectAtIndex:indexCarte-1] integerValue] ]) {
        indexCarte++;
    }
    if (indexCarte == arraycarte.count) {
        return YES;
    }
    return NO;
}

-(BOOL) checkFull:(NSArray *) arraycarte{
    int count = 0;
    int iterator = 1;
    if ([arraycarte.lastObject integerValue] != 34 ) {

        for (int i = 1; i<arraycarte.count; i++) {
            if ([self ValeurCarte:[[arraycarte objectAtIndex:i] integerValue] ] != [self ValeurCarte:[[arraycarte objectAtIndex:i-1] integerValue] ] && iterator == 1)
                iterator = -1;
            else if ([self ValeurCarte:[[arraycarte objectAtIndex:i] integerValue] ] != [self ValeurCarte:[[arraycarte objectAtIndex:i-1] integerValue] ] && iterator == -1)
                iterator = 99;
        
            count += iterator;
        }
        return count*count == 1;
    }
    return NO;
}

-(BOOL) checkSuite:(NSArray *)arraycarte{
    int indexCarte = 0;
    int carteValeur1;
    int carteValeur2;

    
    do {
        indexCarte++;
        carteValeur2 = [self ValeurCarte:[[arraycarte objectAtIndex:indexCarte] integerValue] ] ;
        carteValeur1 = [self ValeurCarte:[[arraycarte objectAtIndex:indexCarte -1] integerValue] ] ;

    } while (indexCarte < arraycarte.count && carteValeur2<32 && carteValeur1 == carteValeur2-1);
    
    if (indexCarte == arraycarte.count)
        return YES;
    return NO;
}


-(BOOL) checkSuiteColor:(NSArray *)arraycarte{
    int indexCarte = 0;
    int carteValeur1;
    int carteValeur2;
    int couleurCarte1;
    int couleurCarte2;
    
    do {
        indexCarte++;
        carteValeur2 = [self ValeurCarte:[[arraycarte objectAtIndex:indexCarte] integerValue] ] ;
        carteValeur1 = [self ValeurCarte:[[arraycarte objectAtIndex:indexCarte -1] integerValue] ] ;
        couleurCarte1 = [self CouleurCarte:[[arraycarte objectAtIndex:indexCarte] integerValue] ] ;
        couleurCarte2 = [self CouleurCarte:[[arraycarte objectAtIndex:indexCarte -1] integerValue] ] ;
    } while (indexCarte < arraycarte.count && carteValeur2<32 && carteValeur1 == carteValeur2-1  && couleurCarte1== couleurCarte2);

    
    if (indexCarte == arraycarte.count)
        return YES;
    return NO;
}

-(BOOL)checkGangOf:(NSArray *)arraycarte{
    if (arraycarte.count >4)
        return [self checkSameValue:arraycarte];
    
    return NO;
}

-(BOOL) checkGangOf:(NSArray *)arraycarteRef against: (NSArray *) arraycarteTest{
    if ([self checkGangOf:arraycarteRef] && [self checkGangOf:arraycarteTest]){
        if (arraycarteRef.count < arraycarteTest.count) {
            return YES;
        }
        else if (arraycarteTest.count == arraycarteRef.count){
            return [self CheckSommeCarteArray:arraycarteTest superiorAt:arraycarteRef];
        }
        return NO;
    }
    return NO;
}

-(int) SommeValueCarte:(NSArray *) arraycarte{
    int count =0;
    for (int i = 0; i<arraycarte.count; i++) {
        count+= [self ValeurCarte:[[arraycarte objectAtIndex:i] integerValue]];
    }
    return count;
}

-(BOOL) CheckSommeCarteArray:(NSArray *) carteArray1 superiorAt:(NSArray *)carteArray2{
    return [self SommeValueCarte:carteArray1] > [self SommeValueCarte:carteArray2];
}




-(BOOL) checkSameSizeArray:(NSArray *) arraycarteRef against:(NSArray *) arraycarteTest{
    return  arraycarteRef.count == arraycarteTest.count;
}


-(BOOL) checkSingle:(NSArray *)carteArray{
    return carteArray.count == 1;
}

-(BOOL) checkPaire:(NSArray *)carteArray{
    return carteArray.count == 2;
}

-(BOOL) checkBrelan:(NSArray *)carteArray{
    return carteArray.count == 3;
}




-(BOOL) comparePair:(NSArray *)carteArrayRef with:(NSArray *) carteArrayTest{
    
    if ([self checkSameCouleur:carteArrayTest]) {
        return [self SommeValueCarte:carteArrayRef] < [self SommeValueCarte:carteArrayTest];
    }
    return  NO;
}

-(BOOL) compareBrelan:(NSArray *)carteArrayRef with:(NSArray *) carteArrayTest{
    if ([self checkSameCouleur:carteArrayTest] &&  [carteArrayTest.lastObject integerValue] <32) {
        return [self SommeValueCarte:carteArrayRef] < [self SommeValueCarte:carteArrayTest];
    }
    return  NO;
}

-(int) checkCombinaisonOfFive:(NSArray *) cartearray{
    if ([self checkSuiteColor:cartearray])
        return 4;
    if ([self checkFull:cartearray])
        return 3;
    if ([self checkSameCouleur:cartearray])
        return 2;
    if ([self checkSuite:cartearray])
        return 1;
    return 0;
}

-(BOOL) compareCombinaisonOfFiveBetween:(NSArray *) carteArrayref AND:(NSArray * ) carteArrayTest{
    int combinaisonRef = [self checkCombinaisonOfFive:carteArrayref];
    int combinaisonTest = [self checkCombinaisonOfFive:carteArrayTest];

    if (combinaisonTest == combinaisonRef)
        return [self SommeValueCarte:carteArrayTest]>[self SommeValueCarte:carteArrayref];
    if (combinaisonTest>combinaisonRef)
        return  YES;
    return NO;
}

-(BOOL) presenceOfPhenixAndDragon:(NSArray *) arraycarte{
    int indexCarte = 1;
    while (indexCarte < arraycarte.count && [self CouleurCarte:[[arraycarte objectAtIndex:indexCarte] integerValue] ]<32) {
        indexCarte++;
    }
    if (indexCarte == arraycarte.count) {
        return YES;
    }
    return NO;
}

-(BOOL) checkIfReferenceCombianison:(NSArray *) arrayRef superiorAtProposiotion:(NSArray *) arraytest{
    if ([self checkGangOf:arraytest])
        return [self checkGangOf:arrayRef against:arraytest];
    else{
        if ([self checkSameSizeArray:arrayRef against:arraytest]) {
            if ([self checkSingle:arraytest])
                return [self SommeValueCarte:arraytest]>[self SommeValueCarte:arrayRef];
            else if ([self checkPaire:arraytest]){
                if ([arraytest.lastObject integerValue] != 34) {
                    return [self comparePair:arrayRef with:arraytest];
                }
            }
            
            else if ([self checkBrelan:arraytest])
                return [self compareBrelan:arraytest with:arraytest];
            else if (arraytest.count == 5){
                return [self compareCombinaisonOfFiveBetween:arrayRef AND:arraytest];
            }
            
        }
    }
    return NO;
}

@end
