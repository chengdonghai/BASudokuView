//
//  RequireCenterIdxViewController.m
//  ASPITP
//
//  Created by donghai cheng on 13-10-13.
//  Copyright (c) 2013年 Donghai Cheng. All rights reserved.
//

#import "BASudokuViewController.h"

@interface BASudokuViewController ()


@end

@implementation BASudokuViewController
@synthesize sudokuView = _sudokuView;
@synthesize dataArray = _dataArray;
@synthesize sudoKuViewHeight = _sudoKuViewHeight;


-(BASudokuView *)sudokuView
{
    if (_sudokuView == nil) {
        _sudokuView = [[BASudokuView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), self.sudoKuViewHeight)];
        _sudokuView.backgroundColor =[UIColor lightGrayColor];
    }
    return _sudokuView;
    
}

-(CGFloat)sudoKuViewHeight
{
    if (_sudoKuViewHeight == 0 ) {
        _sudoKuViewHeight = 300;
    }
    return _sudoKuViewHeight;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.sudokuView.delegate = self;
    self.sudokuView.dataSource = self;
    self.sudokuView.pageMode = self.pageMode;
    self.sudokuView.accessMode = self.accessMode;
    
    [self.view addSubview:self.sudokuView];
    
	// Do any additional setup after loading the view.
}
#pragma mark -
#pragma mark -BASudokuViewDataSource

-(NSInteger)numberOfGridViewInSudokuView:(BASudokuView *)sudokuView
{
    return 9;
    
}

-(NSInteger)numberOfMaxColumnInSudokuView:(BASudokuView *)sudokuView
{
    if (self.pageMode == BASudokuViewPageModeHorizontalNoPaging) {
        return 5;
    }
    return 3;
}

-(NSInteger)numberOfMaxRowsInSudokuView:(BASudokuView *)sudokuView
{
    if (self.pageMode == BASudokuViewPageModeVertical) {
        return 3;
    }
    return 2;
}

-(CGFloat)leftMarginOfGrid:(BASudokuView *)sudokuView
{
    return 10.0;
}

-(CGFloat)topMarginOfGrid:(BASudokuView *)sudokuView
{
    return 10.0;
}

-(CGFloat)bottomMarginOfGrid:(BASudokuView *)sudokuView
{
    return 10.0;
}

-(CGFloat)rightMarginOfGrid:(BASudokuView *)sudokuView
{
    return 10.0;
}

-(CGFloat)horizontalSpacingBetweenGrid:(BASudokuView *)sudokuView
{
    return 10.0;
}

-(CGFloat)verticalSpacingBetweenGrid:(BASudokuView *)sudokuView
{
    return 10.0;
}

-(CGFloat)sudokuView:(BASudokuView *)sudokuView widthForGridAtIndexPath:(BAIndexPath)indexPath
{
     return 90;
}

-(CGFloat)sudokuView:(BASudokuView *)sudokuView heightForGridAtIndexPath:(BAIndexPath)indexPath
{
    return 100;
}

-(PageControlStyle)sudokuView:(BASudokuView *)sudokuView styleOfPageControl:(StyledPageControl *)pageControl
{
    pageControl.gapWidth = 1;
    pageControl.squareSize = CGSizeMake(10, 2);
    pageControl._strokeWidth = 0;
    
    return PageControlStyleSquare;
}

-(UIColor *)sudokuView:(BASudokuView *)sudokuView normalColorInPageControl:(StyledPageControl *)pageControl
{
    return [UIColor blueColor];
}
-(UIColor *)sudokuView:(BASudokuView *)sudokuView selectedColorInPageControl:(StyledPageControl *)pageControl
{
    return [UIColor orangeColor];
}


-(UIView *)sudokuView:(BASudokuView *)sudokuView gridViewAtPath:(BAIndexPath)indexPath
{
    NSInteger index = BAIndex(indexPath, self, sudokuView);
    UIView *gridView =[[UIView alloc]init];
    
    if (index % 3 == 0) {
        gridView.backgroundColor = [UIColor orangeColor];
    } else if (index % 3 == 1) {
        gridView.backgroundColor = [UIColor redColor];
    } else  {
        gridView.backgroundColor = [UIColor greenColor];
    }
    return gridView;
}

#pragma mark- BASudokuViewDelegate
-(void)sudokuView:(BASudokuView *)sudokuView didSelectGridAtIndexPath:(BAIndexPath)indexPath
{
    
    NSInteger row = indexPath.row;
    NSInteger column = indexPath.column;
    NSInteger page = indexPath.page;
    
    NSLog(@"row:%li,column:%li,page:%li", (long)row, (long)column, (long)page);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
