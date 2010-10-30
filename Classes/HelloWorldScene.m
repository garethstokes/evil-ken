//
//  HelloWorldLayer.m
//  evil-ken
//
//  Created by gareth stokes on 28/10/10.
//  Copyright digital five 2010. All rights reserved.
//

// Import the interfaces
#import "HelloWorldScene.h"
#import "CCTouchDispatcher.h"

CCSprite* ken;
CCAnimation* idle;
CCAnimation* dragon;
BOOL _flag;
CCSpriteSheet *sheet;
CCAnimate* idleAction;
CCAnimate* dragonAction;
CCCallFunc *playIdleAction;


CCAnimation* getIdleFrames()
{
  NSMutableArray* idleFrames = [NSMutableArray array];
  for(int i = 1; i < 5; i++) {
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"idle%d.png",i]];
    [idleFrames addObject:frame];
  }
  return [CCAnimation animationWithName:@"dance" delay:0.1f frames:idleFrames]; 
}

CCAnimation* getDragonFrames()
{
  NSMutableArray* dragonFrames = [NSMutableArray array];
  for(int i = 1; i < 7; i++) {
    
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"dragon%d.png",i]];
    [dragonFrames addObject:frame];
  }
  return [CCAnimation animationWithName:@"dragon" delay:0.1f frames:dragonFrames]; 
}

// HelloWorld implementation
@implementation HelloWorld

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorld *layer = [HelloWorld node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
    // register to receive targeted touch events
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self
                                                     priority:0
                                              swallowsTouches:YES];
    
    CGSize s = [[CCDirector sharedDirector] winSize];
    
    
    _flag = YES;
    
		// Create a SpriteSheet -- just a big image which is prepared to 
    // be carved up into smaller images as needed
    sheet = [CCSpriteSheet spriteSheetWithFile:@"ken.png" capacity:50];
    
    // Load sprite frames, which are just a bunch of named rectangle 
    // definitions that go along with the image in a sprite sheet
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ken.plist"];
    
    // Finally, create a sprite, using the name of a frame in our frame cache.
    ken = [CCSprite spriteWithSpriteFrameName:@"idle1.png"];
    ken.position = ccp( s.width/2-80, s.height/2);
    
    // Add the sprite as a child of the sheet, so that it knows where to get its image data.
    [sheet addChild:ken];
    
    // Add sprite sheet to parent (it won't draw anything itself, but 
    // needs to be there so that it's in the rendering pipeline)
    [self addChild:sheet];
    
    
    
		idle = getIdleFrames();
    dragon = getDragonFrames();
    
    idleAction = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:idle]] retain];
    dragonAction = [[CCAnimate actionWithAnimation:dragon] retain];
    playIdleAction = [[CCCallFunc actionWithTarget:self selector:@selector(playIdle:)] retain];
    
		[ken runAction:[CCRepeatForever actionWithAction: idleAction]];
	}
	return self;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  return YES;
}

-(void) playIdle
{
  [ken stopAllActions];
  [ken runAction:idleAction];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
  [ken stopAllActions];
  
  [ken runAction:[CCSequence actions:
                  [[CCAnimate actionWithAnimation:dragon] retain], 
                  [[CCCallFunc actionWithTarget:self selector:@selector(playIdle)] retain], 
                  nil]];
  
  //[ken  runAction:dragonAction];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
  [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
  [playIdleAction dealloc];
  [dragonAction dealloc];
  [idleAction dealloc];
	[super dealloc];
}
@end
