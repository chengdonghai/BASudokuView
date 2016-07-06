//
//  BASudokuView.h
//  JSBPro
//
//  Created by donghai cheng on 13-6-20.
//  Copyright (c) 2013年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StyledPageControl.h"
#import "BAButton.h"

typedef enum {
    BASudokuViewPageModeHorizontal = 1,
    BASudokuViewPageModeVertical = 2,
    BASudokuViewPageModeHorizontalNoPaging = 3
    
}BASudokuViewPageMode;
typedef enum {
    BASudokuGridViewAccessModeNone = 1,
    BASudokuGridViewAccessModeGray
}BASudokuGridViewAccessMode;


@protocol BASudokuViewDataSource;
@protocol BASudokuViewDelegate;

@interface BASudokuView : UIView<StyledPageControlDelegate,UIScrollViewDelegate>
{
    
}

@property(nonatomic,assign) BASudokuGridViewAccessMode accessMode;

@property(nonatomic,retain) StyledPageControl *pageViewControl;

@property(nonatomic,retain) UIScrollView *cScrollView;

@property(nonatomic,assign) id<BASudokuViewDataSource> dataSource;

@property(nonatomic,assign) id<BASudokuViewDelegate> delegate;

@property(nonatomic,assign) BASudokuViewPageMode pageMode;

@property(nonatomic,assign) BOOL clickDisabled;
-(void)reloadDataAndView;

@end



@protocol BASudokuViewDataSource <NSObject>

@required
- (UIView *)sudokuView:(BASudokuView *)sudokuView gridViewAtPath:(BAIndexPath)indexPath;
- (CGFloat)sudokuView:(BASudokuView *)sudokuView heightForGridAtIndexPath:(BAIndexPath)indexPath;
- (CGFloat)sudokuView:(BASudokuView *)sudokuView widthForGridAtIndexPath:(BAIndexPath)indexPath;

@optional

- (NSInteger)numberOfMaxRowsInSudokuView:(BASudokuView*)sudokuView;
- (NSInteger)numberOfMaxColumnInSudokuView:(BASudokuView*)sudokuView;
- (NSInteger)numberOfGridViewInSudokuView:(BASudokuView*)sudokuView;

- (CGFloat)horizontalSpacingBetweenGrid:(BASudokuView *)sudokuView ;
- (CGFloat)verticalSpacingBetweenGrid:(BASudokuView *)sudokuView ;
- (CGFloat)leftMarginOfGrid:(BASudokuView *)sudokuView ;
- (CGFloat)topMarginOfGrid:(BASudokuView *)sudokuView ;
- (CGFloat)rightMarginOfGrid:(BASudokuView *)sudokuView ;
- (CGFloat)bottomMarginOfGrid:(BASudokuView *)sudokuView ;

- (UIColor*)sudokuView:(BASudokuView *)sudokuView selectedColorInPageControl:(StyledPageControl*)pageControl;
- (UIColor*)sudokuView:(BASudokuView *)sudokuView normalColorInPageControl:(StyledPageControl*)pageControl;
- (UIImage*)sudokuView:(BASudokuView *)sudokuView thumbNormalImageInPageControl:(StyledPageControl*)pageControl;
- (UIImage*)sudokuView:(BASudokuView *)sudokuView thumbSelectedImageInPageControl:(StyledPageControl*)pageControl;
- (PageControlStyle)sudokuView:(BASudokuView *)sudokuView styleOfPageControl:(StyledPageControl*)pageControl;

@end


@protocol BASudokuViewDelegate <NSObject>

@required

@optional
- (void)sudokuView:(BASudokuView *)sudokuView didSelectGridAtIndexPath:(BAIndexPath)indexPath;
-(void)sudokuViewDidScroll:(BASudokuView *)sudokuView;
@end
