//
//  BAButton.h
//  ASPITP
//
//  Created by donghai cheng on 13-10-4.
//  Copyright (c) 2013年 Donghai Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#define BAIndex(indexPath,obj,sudokuView) indexPath.page *\
([obj numberOfMaxColumnInSudokuView:sudokuView] *[obj numberOfMaxRowsInSudokuView:sudokuView]) \
+ indexPath.row * [obj numberOfMaxColumnInSudokuView:sudokuView]\
+ indexPath.column

typedef struct _BAIndexPath{
    NSInteger row;
    NSInteger column;
    NSInteger page;
    
}BAIndexPath;

@interface BAButton : UIButton
{
    BAIndexPath indexPath;
}
@property(nonatomic,assign) BAIndexPath indexPath;
@end
