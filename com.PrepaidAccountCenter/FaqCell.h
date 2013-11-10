//
//  DemoTableViewCell.h
//  RTLabelProject
//
//  Created by honcheng on 5/1/11.
//  Copyright 2011 honcheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
@protocol FaqCellDelegate;

@interface FaqCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIWebView *CellWebView;
//@property (weak, nonatomic) IBOutlet UIWebView *CellWebView;

//+ (RTLabel*)textLabel;
- (void) SetCellData:(NSMutableDictionary*) dict isSelectedCell:(BOOL) isSelected forSerialNo:(int) index;
- (NSString*) GetCellData:(NSMutableDictionary*) dict isSelectedCell:(BOOL) isSelected forSerialNo:(int) index;
- (CGFloat) getCellHeight: (NSMutableDictionary*) dict isSelectedCell:(BOOL) isSelected forSerialNo:(int) index;
@end


