//
//  DemoTableViewCell.h
//  RTLabelProject
//
//  Created by honcheng on 5/1/11.
//  Copyright 2011 honcheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"

@interface FaqCell : UITableViewCell
//@property (nonatomic, strong) RTLabel *rtLabel;
@property (weak, nonatomic) IBOutlet UIWebView *CellWebView;
//+ (RTLabel*)textLabel;
- (void) SetCellData:(NSMutableDictionary*) dict isSelectedCell:(BOOL) isSelected;

@end
