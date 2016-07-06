//
//  BASudokuView.m
//  JSBPro
//
//  Created by donghai cheng on 13-6-20.
//  Copyright (c) 2013年 asiainfo-linkage. All rights reserved.
//

#import "BASudokuView.h"

#define pageControl_Height 15

@interface BASudokuView(Private)

-(void)initLayoutView;
-(void)layoutHorizontalPageModeViewWithCurrentPage:(NSInteger)currentPage__ prePage:(NSInteger)prePage__;
- (void)layoutPageControl;

-(void)layoutVerticalPageModeView;
-(void)layoutGridView:(UIView*)contentView atIndexPath:(BAIndexPath)indexPath;
- (UIImage *) createImageWithColor: (UIColor *) color;



@end

@interface BASudokuView()

@property(nonatomic,assign) BOOL initialized;
@property(nonatomic,assign) NSInteger max_row ;
@property(nonatomic,assign) NSInteger max_column ;
@property(nonatomic,assign) NSInteger numberOfPages ;
@property(nonatomic,assign) NSInteger numberOfGrids ;
@property(nonatomic,assign) CGFloat horizontalSpacing;
@property(nonatomic,assign) CGFloat verticalSpacing;
@property(nonatomic,assign) CGFloat leftMargin;
@property(nonatomic,assign) CGFloat topMargin;
@property(nonatomic,assign) CGFloat rightMargin;
@property(nonatomic,assign) CGFloat bottomMargin;

@property (nonatomic, strong) NSMutableArray *contentViewArr;
@property (nonatomic, strong) NSMutableArray *reuseContentViewArr;

@end
@implementation BASudokuView
@synthesize delegate;
@synthesize dataSource;
@synthesize pageMode;
@synthesize cScrollView;
@synthesize pageViewControl;
@synthesize accessMode;

#define GRID_VIEW_TAG 801
#define BABUTTON_TAG 802

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initLayoutView];
    }
    return self;
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initLayoutView];
    }
    return self;
}
- (id)init
{
    CGRect defaultFrame = CGRectMake(13, 0, 999, 686 + pageControl_Height);
    self = [super initWithFrame:defaultFrame];
    if (self) {
        [self initLayoutView];
    }
    return self;
}
- (void)dealloc
{
    self.dataSource = nil;
    self.delegate = nil;
    
    self.cScrollView = nil;
    self.pageViewControl = nil;
    
    
}
-(void)initLayoutView
{
    self.initialized = NO;
    self.pageMode = BASudokuViewPageModeHorizontal;
    self.accessMode = BASudokuGridViewAccessModeGray;
    self.max_row = 3;
    self.max_column = 3;
    self.numberOfPages = 0;
    self.numberOfGrids = 0;
    
    self.leftMargin = 0;
    self.topMargin = 0;
    self.rightMargin = 0;
    self.bottomMargin = 0;

    cScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - pageControl_Height)];
   
    cScrollView.showsHorizontalScrollIndicator = NO;
    cScrollView.showsVerticalScrollIndicator = NO;
    cScrollView.backgroundColor = [UIColor clearColor];
    cScrollView.delegate = self;
    cScrollView.pagingEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:cScrollView];
    
}
#pragma mark- ContentView 重用

-(NSMutableArray *)reuseContentViewArr
{
    if (_reuseContentViewArr == nil) {
        _reuseContentViewArr = [[NSMutableArray alloc]init];
    }
    return _reuseContentViewArr;
}

-(NSMutableArray *)contentViewArr
{
    if (_contentViewArr == nil) {
        _contentViewArr = [[NSMutableArray alloc]init];
    }
    return _contentViewArr;
}
/**
 *  移除不需要的contentview
 * @param startPage 开始位置
 * @param number contentview个数
 */
-(void)removeContentViewFromSuperView:(NSInteger)startPage number:(NSInteger)number
{
    for (int page = 0; page < self.numberOfPages; page++) {
        //不属于这个范围的不移除
        if (page < startPage || page  >= (startPage + number)) {
            UIView *contentView = [cScrollView viewWithTag:page + 200];
            if (contentView) {
                [contentView removeFromSuperview];
            }
        }
    }
}
#pragma mark- layout
- (void)layoutPageControl
{
    if(nil != pageViewControl){
        [pageViewControl removeFromSuperview];
        self.pageViewControl = nil;
    }
    
    if(self.numberOfPages > 1){
        CGFloat heightTemp = CGRectGetHeight(cScrollView.frame);
        
        pageViewControl = [[StyledPageControl alloc] initWithFrame:CGRectMake(0, heightTemp, CGRectGetWidth(self.frame), pageControl_Height)];
        pageViewControl.delegate = self;
        [pageViewControl setDiameter:10];
        pageViewControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        pageViewControl.backgroundColor = [UIColor clearColor];
        PageControlStyle style = PageControlStyleDefault;
        [pageViewControl setPageControlStyle:style];
        
        [pageViewControl setCoreNormalColor:[UIColor lightGrayColor]];
        [pageViewControl setCoreSelectedColor:[UIColor blueColor]];
        [pageViewControl setNumberOfPages:self.numberOfPages];
        [pageViewControl setCurrentPage:0];
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(sudokuView:styleOfPageControl:)]) {
            style = [self.dataSource sudokuView:self styleOfPageControl:pageViewControl];
            pageViewControl.pageControlStyle = style;
        }
        if (style == PageControlStyleDefault || style == PageControlStyleSquare) {
            if (self.dataSource){
                if( [self.dataSource respondsToSelector:@selector(sudokuView:normalColorInPageControl:)]) {
                   [pageViewControl setCoreNormalColor:[self.dataSource sudokuView:self normalColorInPageControl:pageViewControl]];
                }
                if( [self.dataSource respondsToSelector:@selector(sudokuView:selectedColorInPageControl:)]) {
                   [pageViewControl setCoreSelectedColor:[self.dataSource sudokuView:self selectedColorInPageControl:pageViewControl]];
                }
            
            }
        } else if(style == PageControlStyleThumb) {
            
            if (self.dataSource){
                if( [self.dataSource respondsToSelector:@selector(sudokuView:thumbNormalImageInPageControl:)]) {
                    [pageViewControl setThumbImage:[self.dataSource sudokuView:self thumbNormalImageInPageControl:pageViewControl]];
                }
               if( [self.dataSource respondsToSelector:@selector(sudokuView:thumbSelectedImageInPageControl:)]) {
                    [pageViewControl setSelectedThumbImage:[self.dataSource sudokuView:self thumbSelectedImageInPageControl:pageViewControl]];
               }
                
            }
        }
        
        
        
        [self addSubview:pageViewControl];
    } else {
        cScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    }
}

-(void)layoutSubviews
{
    if (self.initialized == NO) {
        self.initialized = YES;
        if(self.dataSource) {
            if ([self.dataSource respondsToSelector:@selector(numberOfMaxRowsInSudokuView:)]) {
                self.max_row = [self.dataSource numberOfMaxRowsInSudokuView:self];
            }
            if (self.max_row == 0) {
                return;
            }
            if ([self.dataSource respondsToSelector:@selector(numberOfMaxColumnInSudokuView:)]) {
                self.max_column = [self.dataSource numberOfMaxColumnInSudokuView:self];
            }
            if (self.max_column == 0) {
                return;
            }
            if ([self.dataSource respondsToSelector:@selector(numberOfGridViewInSudokuView:)]) {
                self.numberOfGrids = [self.dataSource numberOfGridViewInSudokuView:self];
            }
            if (self.numberOfGrids == 0) {
                return;
            }
            if ([self.dataSource respondsToSelector:@selector(horizontalSpacingBetweenGrid:)]) {
                self.horizontalSpacing = [self.dataSource horizontalSpacingBetweenGrid:self];
            }
            if ([self.dataSource respondsToSelector:@selector(verticalSpacingBetweenGrid:)]) {
                self.verticalSpacing = [self.dataSource verticalSpacingBetweenGrid:self];
            }
            if ([self.dataSource respondsToSelector:@selector(leftMarginOfGrid:)]) {
                self.leftMargin = [self.dataSource leftMarginOfGrid:self];
            }
            if ([self.dataSource respondsToSelector:@selector(rightMarginOfGrid:)]) {
                self.rightMargin = [self.dataSource rightMarginOfGrid:self];
            }
            if ([self.dataSource respondsToSelector:@selector(bottomMarginOfGrid:)]) {
                self.bottomMargin = [self.dataSource bottomMarginOfGrid:self];
            }
            if ([self.dataSource respondsToSelector:@selector(topMarginOfGrid:)]) {
                self.topMargin = [self.dataSource topMarginOfGrid:self];
            }
            
            self.numberOfPages = (self.numberOfGrids + self.max_row * self.max_column -1) / (self.max_row * self.max_column);
    
        }
        
        if (self.pageMode == BASudokuViewPageModeHorizontal) {
            [self layoutPageControl];
            [self layoutHorizontalPageModeViewWithCurrentPage:0 prePage:0];
        } else if(self.pageMode == BASudokuViewPageModeVertical) {
            self.cScrollView.pagingEnabled = NO;
            [self layoutVerticalPageModeView];
        } else if(self.pageMode == BASudokuViewPageModeHorizontalNoPaging) {
            self.cScrollView.pagingEnabled = NO;
            [self layoutVerticalPageModeView];
        }
         
    }
}
/**
 *  根据index获取contentview
 *
 *  @param index index
 *
 *  @return contentview
 */
-(UIView *)getContentViewByIndex:(NSInteger)index
{
    if (self.contentViewArr == nil || index >= [self.contentViewArr count] || index < 0) {
        return nil;
    } else {
        return [self.contentViewArr objectAtIndex:index];
    }
}
-(void)reloadDataAndView
{
    [self.reuseContentViewArr removeAllObjects];
    [self.contentViewArr removeAllObjects];
    for (UIView *view in cScrollView.subviews ) {
        if ([view isKindOfClass:[UIImageView class]] || [view isKindOfClass:[UILabel class]]) {
            continue;
        }
        [view removeFromSuperview];
    }
    self.initialized = NO;
    [self setNeedsLayout];
}

-(void)layoutHorizontalPageModeViewWithCurrentPage:(NSInteger)currentPage__ prePage:(NSInteger)prePage__
{
    if (self.numberOfPages > 0) {
        
        //首次最多加载两张页面
        NSInteger startPage = 0;
        NSInteger number = 0;
        
        if (currentPage__ <= 0) {
            startPage = 0;
            number = 2;
        } else if (currentPage__ >= self.numberOfPages-1) {
            startPage = (self.numberOfPages-2);
            number = 2;
        } else {
            startPage = currentPage__ - 1;
            number = 3;
        }
        
        if (number > (self.numberOfPages - startPage)) {
            number = (self.numberOfPages - startPage);
        }
        [self.reuseContentViewArr removeAllObjects];
        for (NSInteger page = startPage; page < number + startPage; page++) {
            UIView *contentView = nil;
            
            if ([self.contentViewArr count] <= 2) {
                if(currentPage__ > prePage__) {
                    contentView = [self getContentViewByIndex:(page - startPage) + (currentPage__ - prePage__) - 1];
                } else if(prePage__ > currentPage__){
                    if ((page - startPage) >= (prePage__ - currentPage__)) {
                       contentView = [self getContentViewByIndex:(page - startPage) + (currentPage__ - prePage__)];
                    } else {
                       contentView = nil;
                    }
                    
                }
            } else {
                contentView = [self getContentViewByIndex:(page - startPage + (currentPage__ - prePage__))];
            }
            
            if (contentView == nil) {
                contentView = [[UIView alloc]init];
                contentView.tag = page + 200;
                UIView *tempview = [cScrollView viewWithTag:200+page];
                if (tempview != nil) {
                    [tempview removeFromSuperview];
                }
                [cScrollView addSubview:contentView];
            }
            
            [self.reuseContentViewArr addObject:contentView];
            
            contentView.frame = CGRectMake(page * CGRectGetWidth(cScrollView.frame), 0 , CGRectGetWidth(cScrollView.frame),CGRectGetHeight(cScrollView.frame));
            
            UIView *grid = [contentView viewWithTag:GRID_VIEW_TAG];
            if (grid == nil) {
                for (int row = 0;  row < self.max_row; row++) {
                    
                    for (int column = 0; column < self.max_column; column ++) {
                        BAIndexPath indexPath;
                        indexPath.row = row;
                        indexPath.column = column;
                        indexPath.page = page;
                        if (row  * self.max_column + column + page * (self.max_column * self.max_row) < self.numberOfGrids) {
                            [self layoutGridView:contentView atIndexPath:indexPath];
                        }
                        
                    }
                    
                    
                }
            }

        }
        [self removeContentViewFromSuperView:startPage number:number];
        [self.contentViewArr removeAllObjects];
        [self.contentViewArr addObjectsFromArray:self.reuseContentViewArr];
    
        [cScrollView setContentSize:CGSizeMake(CGRectGetWidth(cScrollView.frame) * self.numberOfPages, CGRectGetHeight(cScrollView.frame))];
    }

}

-(void)layoutVerticalPageModeView
{
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectZero];
    
    for (int row = 0;  row < self.max_row; row++) {
        
        for (int column = 0; column <self.max_column; column ++) {
            BAIndexPath indexPath;
            indexPath.row = row;
            indexPath.column = column;
            indexPath.page = 0;
            if (row  * self.max_column + column < self.numberOfGrids) {
                [self layoutGridView:contentView atIndexPath:indexPath];
            }
        }
        
        
    }
    CGFloat gridHeight = 0;
    CGFloat gridWidth = 0;
    
    if ([self.dataSource respondsToSelector:@selector(sudokuView:heightForGridAtIndexPath:)]) {
        BAIndexPath indexPath;
        gridHeight = [self.dataSource sudokuView:self heightForGridAtIndexPath:indexPath];
    }
    if ([self.dataSource respondsToSelector:@selector(sudokuView:widthForGridAtIndexPath:)]) {
        BAIndexPath indexPath;
        gridWidth = [self.dataSource sudokuView:self widthForGridAtIndexPath:indexPath];
    }
    
    
    [cScrollView addSubview:contentView];
   
    if (self.pageMode == BASudokuViewPageModeHorizontalNoPaging) {
        contentView.frame = CGRectMake(0, 0,self.leftMargin + self.rightMargin +  self.max_column * (gridWidth + self.horizontalSpacing) - self.horizontalSpacing,
                                       CGRectGetHeight(cScrollView.frame));
        [cScrollView setContentSize:CGSizeMake(CGRectGetWidth(contentView.frame), CGRectGetHeight(cScrollView.frame))];
    } else if(self.pageMode == BASudokuViewPageModeVertical) {
        contentView.frame = CGRectMake(0, 0,CGRectGetWidth(cScrollView.frame),
                                       self.topMargin + self.bottomMargin + self.max_row * (gridHeight + self.verticalSpacing) - self.verticalSpacing);
        [cScrollView setContentSize:CGSizeMake(CGRectGetWidth(cScrollView.frame), CGRectGetHeight(contentView.frame))];
    }
    

}


-(void)layoutGridView:(UIView*)contentView atIndexPath:(BAIndexPath)indexPath
{
    UIView *gridView = nil;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(sudokuView:gridViewAtPath:)]){
        gridView = [self.dataSource sudokuView:self gridViewAtPath:indexPath ];
        CGFloat gridWidth = 0;
        CGFloat gridHeight = 0;
        
        if ([self.dataSource respondsToSelector:@selector(sudokuView:widthForGridAtIndexPath:)]) {
            gridWidth = [self.dataSource sudokuView:self widthForGridAtIndexPath:indexPath];
        }
        
        if ([self.dataSource respondsToSelector:@selector(sudokuView:heightForGridAtIndexPath:)]) {
            gridHeight = [self.dataSource sudokuView:self heightForGridAtIndexPath:indexPath];
        }
        
        gridView.frame = CGRectMake(self.leftMargin + indexPath.column * (gridWidth + self.horizontalSpacing), self.topMargin + indexPath.row * (gridHeight + self.verticalSpacing), gridWidth, gridHeight);
        gridView.tag = GRID_VIEW_TAG + indexPath.row * self.max_column + indexPath.column;
   
        if (gridView != nil) {
            [contentView addSubview:gridView];
            if (!self.clickDisabled) {
                if ([gridView isKindOfClass:[BAButton class]]) {
                    BAButton *button = (BAButton *)gridView;
                    button.indexPath = indexPath;
                    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                    
                } else {
                    BAButton *button = nil;
                    //                    button = (BAButton*)[contentView viewWithTag:BABUTTON_TAG+ indexPath.row * self.max_column + indexPath.column];
                    //                    if (button != nil) {
                    //                        [button removeFromSuperview];
                    //                        button = nil;
                    //                    }
                    button = [[BAButton alloc]initWithFrame:gridView.frame];
                    button.indexPath = indexPath;
                    button.tag = BABUTTON_TAG+ indexPath.row * self.max_column + indexPath.column;
                    if (self.accessMode == BASudokuGridViewAccessModeGray) {
                        [button setAlpha:0.5];
                        
                        [button setBackgroundImage:[self createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
                        [button setBackgroundImage:[self createImageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
                    }
                    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                    [contentView addSubview:button];
                    
                    
                }
            }
            
            
        }
        
        
    }
}

- (UIImage *) createImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(void)buttonAction:(id)sender
{
    BAButton *btn = (BAButton*)sender;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sudokuView:didSelectGridAtIndexPath:)]) {
        [self.delegate sudokuView:self didSelectGridAtIndexPath:btn.indexPath];
    }
}

#pragma mark -
#pragma mark StyledPageControlDelegate
-(void)actionPageControl
{
    if(nil != cScrollView && nil != pageViewControl){
        CGPoint offset = CGPointMake(pageViewControl.currentPage*cScrollView.frame.size.width, 0);
        [cScrollView setContentOffset:offset animated:YES];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate


// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
	NSInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if(nil != pageViewControl){
        if(pageViewControl.currentPage != page){
            NSInteger prePage = pageViewControl.currentPage;
            [pageViewControl setCurrentPage:page];
            [self layoutHorizontalPageModeViewWithCurrentPage:page prePage:prePage];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sudokuViewDidScroll:)]) {
        [self.delegate sudokuViewDidScroll:self];
    }
}
@end
