//
//  TestCombinaison.h
//  GangOfFourV2
//
//  Created by etudiant-mac-02 on 23/03/2015.
//  Copyright (c) 2015 etudiant-mac-02. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TestCombinaison : SKSpriteNode

-(int) ValeurCarte:(int) carte;

-(int) CouleurCarte:(int) carte;

-(int) nombreCarte:(int) arraycarte;

-(BOOL) checkSameCouleur:(NSArray *) arraycarte;

-(BOOL) checkSameValue:(NSArray *)arraycarte;

-(BOOL) checkFull:(NSArray *) arraycarte;

-(BOOL) checkSuite:(NSArray *)arraycarte;

-(BOOL) checkSuiteColor:(NSArray *)arraycarte;

-(BOOL) checkGangOf:(NSArray *) arraycarte;
-(BOOL) checkGangOf:(NSArray *)arraycarteRef against: (NSArray *) arraycarteTest;

-(int) SommeValueCarte:(NSArray *) arraycarte;
-(BOOL) CheckSommeCarteArray:(NSArray *) carteArray1 superiorAt:(NSArray *)carteArray2;

-(BOOL) checkSingle:(NSArray *) carteArray;
-(BOOL) checkPaire:(NSArray *)carteArray;
-(BOOL) comparePair:(NSArray *) carteArrayRef with:(NSArray *) carteArrayTest;

-(BOOL) checkSameSizeArray:(NSArray *) arraycarteRef against:(NSArray *) arraycarteTest;

-(BOOL) checkIfReferenceCombianison:(NSArray *) arrayRef superiorAtProposiotion:(NSArray *) arraytest;


@end
