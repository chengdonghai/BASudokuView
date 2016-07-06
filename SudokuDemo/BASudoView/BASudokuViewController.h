//
//  RequireCenterIdxViewController.h
//  ASPITP
//
//  Created by donghai cheng on 13-10-13.
//  Copyright (c) 2013年 Donghai Cheng. All rights reserved.
//

#import "BASudokuView.h"


@interface BASudokuViewController : UIViewController<BASudokuViewDataSource,BASudokuViewDelegate>

@property(nonatomic,strong) NSArray *dataArray;
@property(nonatomic,strong) BASudokuView *sudokuView;
@property(nonatomic) CGFloat sudoKuViewHeight;

@property(nonatomic) BASudokuViewPageMode pageMode;
@property(nonatomic) BASudokuGridViewAccessMode accessMode;

@end
