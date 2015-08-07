//
//  HorizontalMenu.m
//  Swapp
//
//  Created by Yumen Cao on 8/2/15.
//  Copyright (c) 2015 Limao. All rights reserved.
//

#import "AppDelegate.h"
#import "CommonImports.h"
#import "HorizontalMenu.h"



@implementation HorizontalMenu

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame ButtonItems:(NSArray *)itemsArray
{
    self = [super initWithFrame:frame];
    if (self) {
        if (hmButtonArray == nil) {
            hmButtonArray = [[NSMutableArray alloc] init];
        }
        if (hmScrollView == nil) {
            hmScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, APPDELEGATE.SCREEN_WIDTH, APPDELEGATE.SCREEN_HEIGHT)];
            hmScrollView.showsHorizontalScrollIndicator = NO;
        }
        if (hmItemInfoArray == nil) {
            hmItemInfoArray = [[NSMutableArray alloc]init];
        }
        [hmItemInfoArray removeAllObjects];
        
        [self createMenuItems: itemsArray];
    }
    return self;
}


-(void)createMenuItems:(NSArray *) itemsArray{
    int i = 0;
    float menuWidth = 0.0;
    for (NSDictionary *lDic in itemsArray) {
        NSString *vNormalImageStr = [lDic objectForKey:NOMALKEY];
        NSString *vHeligtImageStr = [lDic objectForKey:HEIGHTKEY];
        NSString *vTitleStr = [lDic objectForKey:TITLEKEY];
        
        float vButtonWidth = [[lDic objectForKey:TITLEWIDTH] floatValue];
        UIButton *vButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [vButton setBackgroundImage:[UIImage imageNamed:vNormalImageStr] forState:UIControlStateNormal];
        [vButton setBackgroundImage:[UIImage imageNamed:vHeligtImageStr] forState:UIControlStateSelected];
        
        [vButton setTitle:vTitleStr forState:UIControlStateNormal];
        [vButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [vButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [vButton setTag:i];
        [vButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [vButton setFrame:CGRectMake(menuWidth, 0, vButtonWidth, self.frame.size.height)];
        
        // [vButton setBackgroundColor: [UIColor grayColor]];
        
        [hmScrollView addSubview:vButton];
        [hmButtonArray addObject:vButton];
        
        menuWidth += vButtonWidth;
        i++;
        
        //保存button资源信息，同时增加button.oringin.x的位置，方便点击button时，移动位置。
        NSMutableDictionary *vNewDic = [lDic mutableCopy];
        [vNewDic setObject:[NSNumber numberWithFloat:menuWidth] forKey:TOTALWIDTH];
        [hmItemInfoArray addObject:vNewDic];
    }
    
    [hmScrollView setContentSize:CGSizeMake(menuWidth, self.frame.size.height)];
    [self addSubview: hmScrollView];
    // 保存menu总长度，如果小于320则不需要移动，方便点击button时移动位置的判断
    hmTotalWidth = menuWidth;
}

#pragma mark - 其他辅助功能
#pragma mark 取消所有button点击状态
-(void)changeButtonsToNormalState{
    for (UIButton *vButton in hmButtonArray) {
        vButton.selected = NO;
    }
}

#pragma mark 模拟选中第几个button
-(void)clickButtonAtIndex:(NSInteger)aIndex{
    UIButton *vButton = [hmButtonArray objectAtIndex:aIndex];
    [self menuButtonClicked:vButton];
}

#pragma mark 改变第几个button为选中状态，不发送delegate
-(void)changeButtonStateAtIndex:(NSInteger)aIndex{
    UIButton *vButton = [hmButtonArray objectAtIndex:aIndex];
    [self changeButtonsToNormalState];
    vButton.selected = YES;
    [self moveScrolViewWithIndex:aIndex];
}

#pragma mark 移动button到可视的区域
-(void)moveScrolViewWithIndex:(NSInteger)aIndex{
    if (hmItemInfoArray.count < aIndex) {
        return;
    }
    //宽度小于320肯定不需要移动
    if (hmTotalWidth <= 320) {
        return;
    }
    NSDictionary *vDic = [hmItemInfoArray objectAtIndex:aIndex];
    float vButtonOrigin = [[vDic objectForKey:TOTALWIDTH] floatValue];
    if (vButtonOrigin >= 300) {
        if ((vButtonOrigin + 180) >= hmScrollView.contentSize.width) {
            [hmScrollView setContentOffset:CGPointMake(hmScrollView.contentSize.width - 320, hmScrollView.contentOffset.y) animated:YES];
            return;
        }
        
        float vMoveToContentOffset = vButtonOrigin - 180;
        if (vMoveToContentOffset > 0) {
            [hmScrollView setContentOffset:CGPointMake(vMoveToContentOffset, hmScrollView.contentOffset.y) animated:YES];
        }
        //        NSLog(@"scrollwOffset.x:%f,ButtonOrigin.x:%f,mscrollwContentSize.width:%f",mScrollView.contentOffset.x,vButtonOrigin,mScrollView.contentSize.width);
    }else{
        [hmScrollView setContentOffset:CGPointMake(0, hmScrollView.contentOffset.y) animated:YES];
        return;
    }
}

#pragma mark - 点击事件
-(void)menuButtonClicked:(UIButton *)aButton{
    [self changeButtonStateAtIndex:aButton.tag];
    if ([self.delegate respondsToSelector:@selector(didMenuHrizontalClickedButtonAtIndex:)]) {
        [self.delegate didMenuHrizontalClickedButtonAtIndex:aButton.tag];
    }
}

@end


