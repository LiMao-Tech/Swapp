//
//  HorizontalMenu.h
//  Swapp
//
//  Created by Yumen Cao on 8/2/15.
//  Copyright (c) 2015 Limao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MENUHEIHT (APPDELEGATE.SCREEN_HEIGHT/16)

#define NOMALKEY   @"normalKey"
#define HEIGHTKEY  @"helightKey"
#define TITLEKEY   @"titleKey"
#define TITLEWIDTH @"titleWidth"
#define TOTALWIDTH @"totalWidth"

@protocol HorizontalMenuDelegate <NSObject>

@optional
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex;

@end

@interface HorizontalMenu : UIView
{
    NSMutableArray        *hmButtonArray;
    NSMutableArray        *hmItemInfoArray;
    UIScrollView          *hmScrollView;
    float                 hmTotalWidth;
}

@property (nonatomic,assign) id <HorizontalMenuDelegate> delegate;

#pragma mark init the menu
- (id)initWithFrame:(CGRect)frame ButtonItems:(NSArray *)aItemsArray;

#pragma mark select button
-(void)clickButtonAtIndex:(NSInteger)aIndex;

#pragma mark 改变第几个button为选中状态，不发送delegate
-(void)changeButtonStateAtIndex:(NSInteger)aIndex;

@end