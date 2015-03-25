//
//  PlateauScene.m
//  GangOfFourV2
//
//  Created by etudiant-mac-02 on 05/03/2015.
//  Copyright (c) 2015 etudiant-mac-02. All rights reserved.
//

#import "PlateauScene.h"
#import "BoutonPerso1.h"
#import "BoutonPerso2.h"
#include "BoutonPlateau.h"
#import "DemarrageSKscene.h"
#import "Combinaisons.h"
#import "LabelTexte.h"
#import "TestCombinaison.h"


@interface PlateauScene ()

@property BOOL contentCreated;
@property BOOL senseGame;
@property int numerosJoueur;
@property (nonatomic, strong) TestCombinaison * test;
@property (nonatomic, strong) SKSpriteNode* senseGameIcon;
@property (nonatomic, strong) NSMutableArray * derniereCombinaison;
@property (nonatomic, strong) NSMutableArray * proposition;
@property (nonatomic, strong) NSMutableArray* derniereCarte;
@property (nonatomic, strong) NSMutableArray* scores;
@property (nonatomic, strong) UIAlertView *cancelPopUp;
@property (nonatomic, strong) UIAlertView *vueCombinaisons;
@property (nonatomic, strong) UIAlertView *validerSansCarte;


@end

@implementation PlateauScene

-(id)initWithSize:(CGSize)size{
    if(self = [super initWithSize:size]){
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"fond_ecran.jpg"];
        background.size = CGSizeMake(self.frame.size.width, self.frame.size.height/2.2);
        background.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:background];
        
    }
    
    
    
    BoutonPerso2 *buttonRetour = [BoutonPerso2 new];
    [buttonRetour initSpriteNodeWithX:-132 Y:85 textLabel:@"Quitter" name:@"Retour" frame:self.frame width:40 heigth:22 fontsize:8];
    
    [self addChild:buttonRetour.button];
    
    
    
    BoutonPlateau *buttonCarte = [BoutonPlateau new];
    [buttonCarte initSpriteNodeWithX:120 Y:-60 nameImage:@"bouttonCarte.gif" name:@"Carte" frame:self.frame width:25 heigth:10];
    
    [self addChild:buttonCarte.button];
    
    
    
    BoutonPlateau *buttonCombinaison = [BoutonPlateau new];
    [buttonCombinaison initSpriteNodeWithX:120 Y:-78 nameImage:@"bouttonCombinaison.gif" name:@"Combinaison"  frame:self.frame width:40 heigth:10];
    
    [self addChild:buttonCombinaison.button];
    
    
    BoutonPlateau *bouttonValider = [BoutonPlateau new];
    [bouttonValider initSpriteNodeWithX:78 Y:-35 nameImage:@"bouttonValider.gif" name:@"Valider"  frame:self.frame width:21 heigth:8];
    [self addChild:bouttonValider.button];
    
    
    BoutonPlateau *bouttonPasser = [BoutonPlateau new];
    [bouttonPasser initSpriteNodeWithX:78 Y:-45 nameImage:@"bouttonPasser.gif" name:@"Passer"  frame:self.frame width:21 heigth:8];
    [self addChild:bouttonPasser.button];
    
    
    
    BoutonPlateau *antiCarteJ2 = [BoutonPlateau new];
    [antiCarteJ2 initSpriteNodeWithX:-83 Y:28 nameImage:@"bouttonAnti.gif" name:@"Anti-CarteJ2"  frame:self.frame width:28 heigth:10];
    [self addChild:antiCarteJ2.button];
    
    
    
    BoutonPlateau *antiCarteJ3 = [BoutonPlateau new];
    [antiCarteJ3 initSpriteNodeWithX:83 Y:28 nameImage:@"bouttonAnti.gif" name:@"Anti-CarteJ3"  frame:self.frame width:28 heigth:10];
    [self addChild:antiCarteJ3.button];
    
    return self;
}


- (void)didMoveToView: (SKView *) view

{
    
    if (!self.contentCreated)
        self.contentCreated = YES;
        
    
    self.nombresJoueurs = [[self.userData objectForKey:@"nombreJoueurs" ] intValue];
    NSLog(@"nombres de joueurs %i" , [[self.userData objectForKey:@"nombreJoueurs" ] intValue]);
    
    self.numerosJoueur = 0;
    
    self.nameJoueurArray = [NSMutableArray array];
    self.joueursAndCartes = [[NSMutableDictionary alloc]init];
    self.carte = [[CarteSKSpriteNode alloc] init];
    [self.carte initWithAllcarte];
    self.derniereCombinaison = [NSMutableArray array];
    self.proposition = [NSMutableArray array];
    self.derniereCarte = [[NSMutableArray alloc]initWithCapacity:4];
    self.scores = [[NSMutableArray alloc]initWithCapacity:4];
    self.senseGame = YES;
    
    
    
    for (int i = 0; i<4; i++)
        [self.scores addObject:[NSNumber numberWithInt:0]];
    

    for (int i = 0; i<4; i++)
        [self.derniereCarte addObject:[NSString stringWithFormat:@"NO"]];

    if(self.nombresJoueurs == 4){
        BoutonPlateau *antiCarte4 = [BoutonPlateau new];
        [antiCarte4 initSpriteNodeWithX:30 Y:45 nameImage:@"bouttonAnti.gif" name:@"Anti-CarteJ4" frame:self.frame width:28 heigth:10];
        [self addChild:antiCarte4.button];
    }
    
    [self DistributionWithNombreJoueur:self.nombresJoueurs];
    
    [self AfficherJoueurs];
    [self AfficherScoreJoueur];
    [self AfficherLesCartes];
    [self createGameSense];
    
}

-(void) DistributionWithNombreJoueur:(int) nbJ{
    for (int i = 0; i<nbJ; i++) {
        [self.nameJoueurArray addObject:[self.userData objectForKey:[NSString stringWithFormat:@"Joueur%i", i+1] ] ];
        [self.joueursAndCartes setValue:[self.carte Extract16CartesForJoueur:i+1] forKey:[self.userData objectForKey:[NSString stringWithFormat:@"Joueur%i", i+1] ]];
    }
}


-(void) createGameSense{
    
    if (self.senseGame == NO) {
        
        [self.senseGameIcon removeFromParent];
        
        self.senseGameIcon = [SKSpriteNode spriteNodeWithImageNamed:@"sens_montre.gif"];
        self.senseGameIcon.size = CGSizeMake(45, 45);
        self.senseGameIcon.position = CGPointMake(self.size.width/9.5, self.size.height/2.8);
        
        [self addChild:self.senseGameIcon];
    }
    
    if (self.senseGame == YES) {
        
        [self.senseGameIcon removeFromParent];
        
        self.senseGameIcon = [SKSpriteNode spriteNodeWithImageNamed:@"sens_anti-montre.gif"];
        self.senseGameIcon.size = CGSizeMake(45, 45);
        self.senseGameIcon.position = CGPointMake(self.size.width/9.5, self.size.height/2.8);
        
        [self addChild:self.senseGameIcon];
    }
}


-(void) createLabelScoreJoueurWithX:(int) posX Y:(int)posY textLabel:(NSString *)text frame:(CGRect) rect width:(float)largeur height:(float)hauteur{
 
    SKSpriteNode *label = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(largeur, hauteur)];
    
    SKLabelNode *score = [[SKLabelNode alloc]init];
    score.text = text;
    score.fontSize = 6;
    score.fontName = @"Zapfino";
    score.fontColor = [UIColor redColor];
    
    [label addChild:score];
    label.position = CGPointMake(CGRectGetMidX(rect)+posX, CGRectGetMidY(rect)+posY);;
    
    [self addChild:label];
    
}

-(void) createLabeljoueurWithX:(int) posX Y:(int)posY textLabel:(NSString *) text Name:(NSString *) nom {
    BoutonPerso1 *Joueur = [BoutonPerso1 new];
    [Joueur initSpriteNodeWithX:posX Y:posY textLabel:text name:nom frame:self.frame width:50 heigth:50 fontsize:7];
    [self addChild:Joueur.button];
}

-(void)AfficheMainJoueurFromArrayWithName:(NSString *) name CarteArray:(NSMutableArray *) cartes posX:(int) x posY:(int) y {
    for (int i = 0; i<cartes.count; i++) {
        [self.carte CarteSpriteNodeWithX:x Y:y Image:[NSString stringWithFormat:@"carte%i.jpg", [[cartes objectAtIndex:i]integerValue ]] name:  [NSString stringWithFormat:@"%@.%i.%i",name,i ,[[cartes objectAtIndex:i]integerValue ]] frame:self.frame faceCacher:false];
        [self addChild:self.carte.carte];
        x+=10;
    }
}

-(void)AfficheMainJoueurFromArrayWithName:(NSString *) name CarteArray:(NSMutableArray *) cartes posInArray:(int) index posX:(int) x posY:(int) y {
    for (int i = index; i<cartes.count; i++) {
        [self.carte CarteSpriteNodeWithX:x Y:y Image:[NSString stringWithFormat:@"carte%i.jpg", [[cartes objectAtIndex:i]integerValue ]] name:  [NSString stringWithFormat:@"%@.%i.%i",name,i ,[[cartes objectAtIndex:i]integerValue ]] frame:self.frame faceCacher:false];
        [self addChild:self.carte.carte];
        x+=10;
    }
}

-(void) AfficherMainJoueurFaceCacherFromName:(NSString *) name Array:(NSMutableArray *) cartes posX:(int) x posY:(int) y{
    for (int i = 0; i<cartes.count; i++) {
        [self.carte CarteSpriteNodeWithX:x Y:y Image:@"carte0.jpg" name: [NSString stringWithFormat:@"%@.%i.%i",name,i ,[[cartes objectAtIndex:i]integerValue ]] frame:self.frame faceCacher:true];
        [self addChild:self.carte.carte];
        x+=5;
    }
}

-(void) AfficherMainJoueurActuelFaceCacherFromName:(NSString *) name Array:(NSMutableArray *) cartes posX:(int) x posY:(int) y{
	for (int i = 0; i<cartes.count; i++) {
        [self.carte CarteSpriteNodeWithX:x Y:y Image:@"carte0.jpg" name: [NSString stringWithFormat:@"%@.%i.%i",name,i ,[[cartes objectAtIndex:i]integerValue ]] frame:self.frame faceCacher:false];
        [self addChild:self.carte.carte];
        x+=10;
	}
}

-(void) AfficherCarteWithRotationEffetWithName:(NSString *) name CarteArray:(NSArray *)array posX:(int) x posY:(int) y moveUp:(int) up{
    for (int i = 0; i<array.count ; i++) {
        [self.carte CarteSpriteNodeWithX:x Y:y Image:[NSString stringWithFormat:@"carte%i.jpg", [[array objectAtIndex:i] integerValue] ] name: [NSString stringWithFormat:@"%@.%i",name,i] frame:self.frame faceCacher:false];
        [self addChild:self.carte.carte];
        x+=10;
        
        SKAction *moveup = [SKAction moveByX:(x*-1)+((i - self.derniereCombinaison.count/2)*20) y:60 duration:0.25];
        SKAction * tounicoton = [SKAction rotateByAngle:360 duration:0.25];
        SKAction *moveSequence = [SKAction sequence:@[moveup, tounicoton]];
        
        [self.carte.carte runAction: moveSequence ];
    }
}

-(void) AfficherLesCartesJoueurSens1{
    [self AfficheMainJoueurFromArrayWithName:[NSString stringWithFormat:@"Joueur%i", self.numerosJoueur] CarteArray:[self.joueursAndCartes objectForKey:[self.nameJoueurArray objectAtIndex:self.numerosJoueur]] posX:-75 posY:-70];
    
    [self AfficherMainJoueurFaceCacherFromName:[NSString stringWithFormat:@"Joueur%i", (self.numerosJoueur + 1)%self.nombresJoueurs]  Array:[self.joueursAndCartes objectForKey:[self.nameJoueurArray objectAtIndex:(self.numerosJoueur + 1)%self.nombresJoueurs]] posX:-150 posY:5];
    
    if (self.nombresJoueurs ==3){
        
        [self AfficherMainJoueurFaceCacherFromName:[NSString stringWithFormat:@"Joueur%i", (self.numerosJoueur + 2)%self.nombresJoueurs]  Array:[self.joueursAndCartes objectForKey:[self.nameJoueurArray objectAtIndex:(self.numerosJoueur + 2)%self.nombresJoueurs]] posX:75 posY:5];
    }
    
    else if (self.nombresJoueurs ==4){
        
        [self AfficherMainJoueurFaceCacherFromName:[NSString stringWithFormat:@"Joueur%i", (self.numerosJoueur + 2)%self.nombresJoueurs] Array:[self.joueursAndCartes objectForKey:[self.nameJoueurArray objectAtIndex:(self.numerosJoueur + 2)%self.nombresJoueurs]] posX:-38  posY:65];
        
        [self AfficherMainJoueurFaceCacherFromName:[NSString stringWithFormat:@"Joueur%i", (self.numerosJoueur + 3)%self.nombresJoueurs] Array:[self.joueursAndCartes objectForKey:[self.nameJoueurArray objectAtIndex:(self.numerosJoueur + 3)%self.nombresJoueurs]] posX:75 posY:5];
    }
    
    [self AfficherCarteWithRotationEffetWithName:@"derniereCombi" CarteArray:self.derniereCombinaison posX:-60 posY:-35 moveUp:70];
}

-(void) AfficherLesCartesJoueurSens2{
    [self AfficheMainJoueurFromArrayWithName:[NSString stringWithFormat:@"Joueur%i", self.numerosJoueur] CarteArray:[self.joueursAndCartes objectForKey:[self.nameJoueurArray objectAtIndex:self.numerosJoueur]] posX:-75 posY:-70];
    
     [self AfficherMainJoueurFaceCacherFromName:[NSString stringWithFormat:@"Joueur%i", (self.numerosJoueur + 1)%self.nombresJoueurs] Array:[self.joueursAndCartes objectForKey:[self.nameJoueurArray objectAtIndex:(self.numerosJoueur + 1)%self.nombresJoueurs]] posX:75 posY:5];
    
    [self AfficherMainJoueurFaceCacherFromName:[NSString stringWithFormat:@"Joueur%i", (self.numerosJoueur + 1)%self.nombresJoueurs]  Array:[self.joueursAndCartes objectForKey:[self.nameJoueurArray objectAtIndex:(self.numerosJoueur + 2)%self.nombresJoueurs]] posX:75 posY:5];
    
    if (self.nombresJoueurs ==3)
        [self AfficherMainJoueurFaceCacherFromName:[NSString stringWithFormat:@"Joueur%i", (self.numerosJoueur + 2)%self.nombresJoueurs]  Array:[self.joueursAndCartes objectForKey:[self.nameJoueurArray objectAtIndex:(self.numerosJoueur + 1)%self.nombresJoueurs]] posX:-150 posY:5];
        
    else if (self.nombresJoueurs ==4){
        [self AfficherMainJoueurFaceCacherFromName:[NSString stringWithFormat:@"Joueur%i", (self.numerosJoueur + 2)%self.nombresJoueurs] Array:[self.joueursAndCartes objectForKey:[self.nameJoueurArray objectAtIndex:(self.numerosJoueur + 2)%self.nombresJoueurs]] posX:-38  posY:65];
        [self AfficherMainJoueurFaceCacherFromName:[NSString stringWithFormat:@"Joueur%i", (self.numerosJoueur + 3)%self.nombresJoueurs]  Array:[self.joueursAndCartes objectForKey:[self.nameJoueurArray objectAtIndex:(self.numerosJoueur + 1)%self.nombresJoueurs]] posX:-150 posY:5];
    }
    
    
}

-(void) AfficherLesCartes{
    if (self.senseGame) {
        [self AfficherLesCartesJoueurSens1];
    }
    else
        [self AfficherLesCartesJoueurSens2];
    
    [self AfficherCarteWithRotationEffetWithName:@"derniereCombi" CarteArray:self.derniereCombinaison posX:-60 posY:-35 moveUp:70];

    
}



-(void) removeAllCartesJoueurs{
    [self RemoveCarteNodeFromName:self.numerosJoueur];
    [self RemoveCarteNodeFromName:(self.numerosJoueur + 1)%self.nombresJoueurs];
    
    if (self.nombresJoueurs ==3)
        [self RemoveCarteNodeFromName:(self.numerosJoueur + 2)%self.nombresJoueurs];

    else if (self.nombresJoueurs ==4){
        [self RemoveCarteNodeFromName:(self.numerosJoueur + 2)%self.nombresJoueurs];
        [self RemoveCarteNodeFromName:(self.numerosJoueur + 3)%self.nombresJoueurs];
    }
}


-(void) AfficherJoueurs{
    [self RemoveNodefromName:@"JoueurActuel"];
    [self RemoveNodefromName:@"JoueurPrecedent"];
    [self RemoveNodefromName:@"JoueurEnAttente"];
    [self RemoveNodefromName:@"JoueurSuivant"];
    
    if (self.senseGame)
        [self AfficherJoueurSens1];
    else
        [self AfficherJoueurSens2];
}

-(void) AfficherJoueurSens1{
    [self createLabeljoueurWithX:-30 Y:-92 textLabel:[NSString stringWithFormat:@"%@",[self.nameJoueurArray objectAtIndex:self.numerosJoueur]]  Name:@"JoueurActuel"];
    
    [self createLabeljoueurWithX:-135 Y:-15 textLabel:[NSString stringWithFormat:@"%@",[self.nameJoueurArray objectAtIndex:(self.numerosJoueur+1)%self.nombresJoueurs]] Name:@"JoueurPrecedent"];
    
    if (self.nombresJoueurs == 3)
        [self createLabeljoueurWithX:+135 Y:-15 textLabel:[NSString stringWithFormat:@"%@",[self.nameJoueurArray objectAtIndex:(self.numerosJoueur+2)%self.nombresJoueurs]] Name:@"JoueurSuivant"];
    
    if (self.nombresJoueurs ==4){
        [self createLabeljoueurWithX:-30 Y:90 textLabel:[NSString stringWithFormat:@"%@",[self.nameJoueurArray objectAtIndex:(self.numerosJoueur+2)%self.nombresJoueurs]] Name:@"JoueurEnAttente"];
        [self createLabeljoueurWithX:+135 Y:-15 textLabel:[NSString stringWithFormat:@"%@",[self.nameJoueurArray objectAtIndex:(self.numerosJoueur+3)%self.nombresJoueurs]] Name:@"JoueurSuivant"];
        
        BoutonPlateau *antiCarte4 = [BoutonPlateau new];
        [antiCarte4 initSpriteNodeWithX:30 Y:45 nameImage:@"bouttonAnti.gif" name:@"Anti-CarteJ4"  frame:self.frame width:28 heigth:10];
        [self addChild:antiCarte4.button];
    }
}

-(void) AfficherJoueurSens2{
    [self createLabeljoueurWithX:-30 Y:-92 textLabel:[NSString stringWithFormat:@"%@",[self.nameJoueurArray objectAtIndex:self.numerosJoueur]]  Name:@"JoueurActuel"];
    
    [self createLabeljoueurWithX:+135 Y:-15 textLabel:[NSString stringWithFormat:@"%@",[self.nameJoueurArray objectAtIndex:(self.numerosJoueur+1)%self.nombresJoueurs]] Name:@"JoueurPrecedent"];

    if (self.nombresJoueurs == 3)
        [self createLabeljoueurWithX:-135 Y:-15 textLabel:[NSString stringWithFormat:@"%@",[self.nameJoueurArray objectAtIndex:(self.numerosJoueur+2)%self.nombresJoueurs]] Name:@"JoueurSuivant"];

    if (self.nombresJoueurs ==4){
        [self createLabeljoueurWithX:-30 Y:90 textLabel:[NSString stringWithFormat:@"%@",[self.nameJoueurArray objectAtIndex:(self.numerosJoueur+2)%self.nombresJoueurs]] Name:@"JoueurEnAttente"];
        [self createLabeljoueurWithX:-135 Y:-15 textLabel:[NSString stringWithFormat:@"%@",[self.nameJoueurArray objectAtIndex:(self.numerosJoueur+3)%self.nombresJoueurs]] Name:@"JoueurSuivant"];
        
        BoutonPlateau *antiCarte4 = [BoutonPlateau new];
        [antiCarte4 initSpriteNodeWithX:30 Y:45 nameImage:@"bouttonAnti.gif" name:@"Anti-CarteJ4"  frame:self.frame width:28 heigth:10];
        [self addChild:antiCarte4.button];
    }
}

-(void) AfficherScoreJoueur{
 
    if (self.senseGame) {
        [self AfficherScoreJoueurSens1];
    }
    else
        [self AfficherScoreJoueurSens2];
}

-(void) AfficherScoreJoueurSens1{
    [self createLabelScoreJoueurWithX:20 Y:-98 textLabel:[NSString stringWithFormat:@"Score : %@",[self.scores objectAtIndex:0]]frame:self.frame width:25 height:10];
    
    [self createLabelScoreJoueurWithX:-135 Y:-34 textLabel:[NSString stringWithFormat:@"Score : %@",[self.scores objectAtIndex:1]]frame:self.frame width:25 height:10];
    
    if (self.nombresJoueurs == 3) {
        [self createLabelScoreJoueurWithX:132 Y:-34 textLabel:[NSString stringWithFormat:@"Score : %@",[self.scores objectAtIndex:2]]frame:self.frame width:25 height:10];

    }
    
    if (self.nombresJoueurs == 4) {
        [self createLabelScoreJoueurWithX:132 Y:-34 textLabel:[NSString stringWithFormat:@"Score : %@",[self.scores objectAtIndex:3]]frame:self.frame width:25 height:10];
        [self createLabelScoreJoueurWithX:22 Y:81 textLabel:[NSString stringWithFormat:@"Score : %@",[self.scores objectAtIndex:2]]frame:self.frame width:25 height:10];
    }
}

-(void) AfficherScoreJoueurSens2{
    [self createLabelScoreJoueurWithX:20 Y:-98 textLabel:[NSString stringWithFormat:@"Score : %@",[self.scores objectAtIndex:0]]frame:self.frame width:25 height:10];
    
    [self createLabelScoreJoueurWithX:132 Y:-34 textLabel:[NSString stringWithFormat:@"Score : %@",[self.scores objectAtIndex:1]]frame:self.frame width:25 height:10];

    if (self.nombresJoueurs == 3) {
        [self createLabelScoreJoueurWithX:-135 Y:-34 textLabel:[NSString stringWithFormat:@"Score : %@",[self.scores objectAtIndex:2]]frame:self.frame width:25 height:10];
        
    }
    
    if (self.nombresJoueurs == 4) {
        [self createLabelScoreJoueurWithX:-135 Y:-34 textLabel:[NSString stringWithFormat:@"Score : %@",[self.scores objectAtIndex:3]]frame:self.frame width:25 height:10];
        [self createLabelScoreJoueurWithX:22 Y:81 textLabel:[NSString stringWithFormat:@"Score : %@",[self.scores objectAtIndex:2]]frame:self.frame width:25 height:10];
    }
}


-(void)RemoveNodefromName:(NSString *) nameNode{
    SKNode *helloNode = [self childNodeWithName:nameNode];
    [helloNode removeFromParent];
    
    
}

-(void)RemoveCarteNodeFromName:(int) numJ{
    
    NSArray * cartes = [self.joueursAndCartes objectForKey:[self.nameJoueurArray objectAtIndex:numJ]];
    for (int i = 0; i<cartes.count; i++){
        SKNode * helloNode = [self childNodeWithName:[NSString stringWithFormat:@"Joueur%i.%i.%i",numJ, i ,[[cartes objectAtIndex:i]integerValue ]]];
        [helloNode removeFromParent];
    }
}



-(void)RemoveCarteNodeWithPositionFromName:(NSString *) name{
    
    for (int i = 0; i<self.derniereCombinaison.count; i++){
        [[self childNodeWithName:[NSString stringWithFormat:@"%@.%i",name, i]] removeFromParent];
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    NSArray * myArraynode= [node.name componentsSeparatedByString:@"."];
    // if next button touched, start transition to next scene
    NSLog(@"%@",node.name);

    if ([[myArraynode objectAtIndex:0] isEqualToString:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"Joueur%i", self.numerosJoueur]]]) {
        NSLog(@"Carte du joueur actuel");
        SKAction *dezoom = [SKAction scaleTo: 0.20 duration: 0];
        SKAction *fadeAway = [SKAction fadeOutWithDuration: 0];
        SKAction *moveSequence = [SKAction sequence:@[dezoom, fadeAway]];
        [node runAction: moveSequence  ];
        [self PlayCarteFromName:node.name];
    }
    
    else if ([[myArraynode objectAtIndex:0] isEqualToString:[NSString stringWithFormat:@"%@",@"proposition"]]){
        [self removeOneCarteFromArrayProposition:myArraynode];
        [self refaireApparaitreOneCarteFromArrayNode:myArraynode];

    }
    
    
    else if ([node.name isEqualToString:@"Retour"]) {
        NSLog(@"Retour select");
        self.view.paused = YES;
        self.cancelPopUp = [[UIAlertView alloc] initWithTitle:@"Quitter" message:@"Êtes-vous sûre de vouloir quitter la partie ?" delegate:self cancelButtonTitle:@"Oui" otherButtonTitles:@"Non", nil];
        self.cancelPopUp.tag = 1;
        [self.cancelPopUp show];
    }
    
    
    else if ([node.name isEqualToString:@"Carte"]){
        
        
        //TODO
        
        
    }
    
    else if ([node.name isEqualToString:@"Combinaison"]){
        self.view.paused = YES;
        self.vueCombinaisons = [[UIAlertView alloc]initWithTitle:@"Combinaisons Possibles" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 250, 200)];
        [imageView setImage:[UIImage imageNamed:@"combinaisons.jpg"]];
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 250, 200)];
        [v addSubview:imageView];
        [self.vueCombinaisons setValue:v forKey:@"accessoryView"];
        self.vueCombinaisons.tag = 2;
        [self.vueCombinaisons show];
    }
    
    else if ([node.name isEqualToString:@"Valider"]){
        
        //TODO
        
        if (self.proposition.count == 0) {
            self.view.paused = YES;
            
            self.validerSansCarte = [[UIAlertView alloc]initWithTitle:@"Attention" message:@"Aucune carte sélectionnée, voulez-vous passer votre tour ?" delegate:self cancelButtonTitle:@"Oui" otherButtonTitles:@"Non", nil];
            self.validerSansCarte.tag = 3;
            [self.validerSansCarte show];
        }
        else {
            [self removeAllCartesJoueurs];
            [self RemoveCarteNodeWithPositionFromName:@"derniereCombi"];
            [self.derniereCombinaison removeAllObjects];
            [self removeAllCarteFromProposition:true];
            
            
            self.numerosJoueur = (self.numerosJoueur+1)%self.nombresJoueurs;
            [self AfficherJoueurs];
            [self AfficherLesCartes];
        }

        
        
        
        
    }
    
    else if ([node.name isEqualToString:@"Anti-CarteJ2"]){
        
        
        //TODO
        
        //Pour tester le changement de l'icone du sens. Code à décplacer dans la future méthode "FinManche"
        if (self.senseGame == NO){
            self.senseGame = YES;
            [self createGameSense];
        }
        
        else if (self.senseGame == YES){
            self.senseGame = NO;
            [self createGameSense];
        }
        
    }
    
    else if ([node.name isEqualToString:@"Anti-CarteJ3"]){
        
        
        //TODO
        
    }
    
    else if ([node.name isEqualToString:@"Anti-CarteJ4"]){
        
        
        //TODO
        
    }
    
    
    else if ([node.name isEqualToString:@"Passer"]){
        
        [self removeAllCartesJoueurs];
        [self RemoveCarteNodeWithPositionFromName:@"derniereCombi"];
        [self.derniereCombinaison removeAllObjects];
        [self removeAllCarteFromProposition:true];
        
        
        self.numerosJoueur = (self.numerosJoueur+1)%self.nombresJoueurs;
        [self AfficherJoueurs];
        [self AfficherLesCartes];
        
    }

 
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0 && alertView.tag == 1){
        self.view.paused = NO;
        [self returnScene:[[DemarrageSKscene alloc] initWithSize:self.size]];
    }
    
    if (buttonIndex == 0 && alertView.tag == 3) {
        
        self.view.paused = NO;
        [self removeAllCartesJoueurs];
        [self removeAllCarteFromProposition:true];
        self.numerosJoueur = (self.numerosJoueur+1)%self.nombresJoueurs;
        [self AfficherJoueurs];
        [self AfficherLesCartes];
        
    }
    
    else
       self.view.paused = NO;
}


-(int) checkCaseVide:(NSMutableArray *)array{
    int indexmin =0;
    while (indexmin < array.count && ![[array objectAtIndex:indexmin]  isEqual: @"vide"]) {
        indexmin++;
    }
    return indexmin;
}

-(int) checkCaseMinimal:(NSMutableArray *)array valeur:(int) value{
    int indexmin =0;
    while (indexmin < array.count && [[array objectAtIndex:indexmin]integerValue ]< value) {
        indexmin++;
    }
    return indexmin;
}

-(void) PlayCarteFromName:(NSString *) nodeName{
    
    NSArray * myArraynode= [nodeName componentsSeparatedByString:@"."];
    TestCombinaison * test = [[TestCombinaison alloc] init];
    int valeur = [test ValeurCarte:[[myArraynode objectAtIndex:2] integerValue]];
    int couleur = [test CouleurCarte:[[myArraynode objectAtIndex:2] integerValue]];
    NSLog(@"valeur : %i ; couleur : %i", valeur, couleur);
    int position = [self checkCaseMinimal:self.proposition valeur:[[myArraynode objectAtIndex:2] integerValue]];
    [self moveCarteProposerAfterChoice:position];
    if (position < self.proposition.count) {
        [self.proposition insertObject:[myArraynode objectAtIndex:2] atIndex:position];
    }
    else
        [self.proposition addObject:[myArraynode objectAtIndex:2] ];
    
    // name :
    [self.carte CarteSpriteNodeWithX:-75+(10 * [[myArraynode objectAtIndex:1] integerValue]) Y:-70 Image:[NSString stringWithFormat:@"carte%i.jpg", [[myArraynode objectAtIndex:2] integerValue]  ] name: [NSString stringWithFormat:@"proposition.%i.%@", position,[myArraynode objectAtIndex:1]  ] frame:self.frame faceCacher:false];
    [self addChild:self.carte.carte];
    
    
    
    SKAction *dezoom = [SKAction scaleTo: 0.20 duration: 0.25];
    SKAction *moveUp = [SKAction moveByX: 30+((position-1
                                               )*20)-(10*[[myArraynode objectAtIndex:1] integerValue]) y: 40 duration: 0.5];
    SKAction *zoom = [SKAction scaleTo: 1 duration: 0.25];
    SKAction *moveSequence = [SKAction sequence:@[dezoom, moveUp, zoom]];
    [self.carte.carte runAction: moveSequence ];
    
    


}

-(void) removeOneCarteFromArrayProposition:(NSArray *) nodeArray{
    
    SKNode *newCarte = [self childNodeWithName:[NSString stringWithFormat:@"proposition.%@.%@", [nodeArray objectAtIndex:1],[nodeArray objectAtIndex:2]]];
    SKAction *dezoom = [SKAction scaleTo: 0.20 duration: 0.25];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *moveSequence = [SKAction sequence:@[dezoom,  remove]];
    [newCarte runAction: moveSequence ];
    [self removeFromArray:[[nodeArray objectAtIndex:1] integerValue]];
    [self.proposition removeObjectAtIndex:[[nodeArray objectAtIndex:1] integerValue]];
}


-(void) refaireApparaitreOneCarteFromArrayNode:(NSArray *) myArraynode{
    
    SKNode * oldcarte = [self childNodeWithName:[NSString stringWithFormat:@"%@.%@.%@",[NSString stringWithFormat:@"Joueur%i",self.numerosJoueur],[myArraynode objectAtIndex:2] ,[[self.joueursAndCartes objectForKey:[self.nameJoueurArray objectAtIndex:self.numerosJoueur]] objectAtIndex:[[myArraynode objectAtIndex:2] integerValue]]]];
    
    SKAction *fadeIn = [SKAction fadeInWithDuration: 0];
    SKAction * zoom = [SKAction scaleTo: 1 duration: 0.25];
    SKAction *moveSequence = [SKAction sequence:@[fadeIn, zoom]];
    
    [oldcarte runAction: moveSequence ];
}


// !!! à utiliser après avoir enlever les noeuds des cartes en mains
-(void) removeAllCarteFromProposition:(BOOL) propositionValider{
    int indexCarteEnMain =0;
    int carteEliminer = 0;
    for (int i = 0  ; i<self.proposition.count; i++) {
        while ([[[self.joueursAndCartes objectForKey:[self.nameJoueurArray objectAtIndex:self.numerosJoueur]] objectAtIndex:indexCarteEnMain] integerValue] != [[self.proposition objectAtIndex:i] integerValue])
            indexCarteEnMain++;
            
        for (int j = -1; j<2; j++) {
            NSString * nameCarte =  [NSString stringWithFormat:@"proposition.%i.%i", i ,indexCarteEnMain + j + carteEliminer];
            SKNode *newCarte = [self childNodeWithName:nameCarte];
            [newCarte removeFromParent];
        }
        if (propositionValider) {
            [self.derniereCombinaison addObject:[self.proposition objectAtIndex:i]];
            [[self.joueursAndCartes objectForKey:[self.nameJoueurArray objectAtIndex:self.numerosJoueur]] removeObjectAtIndex:indexCarteEnMain];
            carteEliminer++;
        }
    }
    [self.proposition removeAllObjects];
}


-(void) moveCarteProposerAfterChoice:(int) index {
    for (int i = self.proposition.count; i>=index; i--) {
        for (int j = 16 ; j>=index; j--) {
            NSString * nameCarte =  [NSString stringWithFormat:@"proposition.%i.%i", i ,j];
            SKNode *newCarte = [self childNodeWithName:nameCarte];
            
            [newCarte setName:[NSString stringWithFormat:@"proposition.%i.%i", i+1 ,j]];

            SKAction *left = [SKAction moveByX: +20 y: 0 duration: 0.5];
            [newCarte runAction: left ];
        }
    }
    
}

-(void) removeFromArray:(int) index{
    for (int i = index  ; i<self.proposition.count; i++) {
        for (int j = index ; j<16; j++) {
            NSString * nameCarte =  [NSString stringWithFormat:@"proposition.%i.%i", i ,j];
            SKNode *newCarte = [self childNodeWithName:nameCarte];
            
            [newCarte setName:[NSString stringWithFormat:@"proposition.%i.%i", i-1 ,j]];
            
            SKAction *left = [SKAction moveByX: -20 y: 0 duration: 0.5];
            [newCarte runAction: left ];
        }
    }
}

-(void) nextScene:(SKScene *)scene{
    
    NSLog(@"Next Scene");
    SKTransition *transition = [SKTransition fadeWithDuration:0.5];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:scene transition:transition];
}



-(void) returnScene:(SKScene *)scene {
    
    NSLog(@"Demarrage");
    SKTransition *transition = [SKTransition moveInWithDirection:SKTransitionDirectionLeft duration:0.5];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:scene transition:transition];
}



@end
