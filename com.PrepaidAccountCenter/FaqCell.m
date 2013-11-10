//
//  DemoTableViewCell.m
//  RTLabelProject
//
//  Created by honcheng on 5/1/11.
//  Copyright 2011 honcheng. All rights reserved.
//

#import "FaqCell.h"
#import "UIColor+Hex.h"

@implementation FaqCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        // Initialization code.
//		_rtLabel = [FaqCell textLabel];
//		[self.contentView addSubview:_rtLabel];
//		[_rtLabel setBackgroundColor:[UIColor clearColor]];
//        
//        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    if (self) {
//        // Initialization code.
//		_rtLabel = [FaqCell textLabel];
//		[self.contentView addSubview:_rtLabel];
//		[_rtLabel setBackgroundColor:[UIColor clearColor]];
//        
//        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _CellWebView.scrollView.scrollEnabled = NO;
        _CellWebView.scrollView.bounces = NO;
       
    }
    return self;
}

//- (void)layoutSubviews
//{
//	[super layoutSubviews];
//	
//	CGSize optimumSize = [self.rtLabel optimumSize];
//	CGRect frame = [self.rtLabel frame];
//	frame.size.height = (int)optimumSize.height+5; // +5 to fix height issue, this should be automatically fixed in iOS5
//    frame.size.width = (int) self.contentView.frame.size.width;
//	[self.rtLabel setFrame:frame];
////    NSMutableDictionary *viewsDictionary = [NSMutableDictionary dictionary];
////    [viewsDictionary addEntriesFromDictionary:NSDictionaryOfVariableBindings(_rtLabel)];
////    
////    
////    
////    // disable translatesAutoresizingMaskIntoConstraints in views for auto layout
////    [viewsDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
////     {
////         [obj setTranslatesAutoresizingMaskIntoConstraints:NO];
////     }];
////     NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:
////                           @"|-[_rtLabel]-|"
////                                                                options:kNilOptions
////                                                              metrics:nil
////                                                              views:viewsDictionary];
////    
//   // [self.contentView addConstraints:constraints];
//}

//+ (RTLabel*)textLabel
//{
//	RTLabel *label = [[RTLabel alloc] initWithFrame:CGRectMake(10,10,300,100)];
//    [label sizeToFit];
//	//[label setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20]];
//    [label setParagraphReplacement:@""];
//  
//	return label;
//}
- (NSString*) GetCellData:(NSMutableDictionary*) dict isSelectedCell:(BOOL) isSelected forSerialNo:(int) index
{
    NSString* data  = @"";
    
    index = index + 1;
    if (isSelected == YES) {
        data = [NSString stringWithFormat:@"<html><head></head><body style=\"padding-top:10px; text-align:left; border-top: solid 2px gray;\"><div style=\"background-color:#9F9F9F;\"><div style=\"position:absolute;\">%i. </div><div style=\"padding-left:20px;\">%@</div><div style=\"padding-left:20px;\">%@</div></body></htmml>",index,[dict objectForKey:@"Question"],[dict objectForKey:@"Answer"]  ];
        
    }
    else
    {
        data = [NSString stringWithFormat:@"<html><head></head><body style=\"padding-top:10px; text-align:left; border-top: solid 2px gray;\"><div style=\"position:absolute;\">%i.</div><div style=\"padding-left:20px;\"> %@</div></body></html>",index,[dict objectForKey:@"Question"]];
        
        
    }
    return data;
}


- (void) SetCellData:(NSMutableDictionary*) dict isSelectedCell:(BOOL) isSelected forSerialNo:(int) index
{
  
       [_CellWebView setBackgroundColor:[UIColor clearColor]];
    [_CellWebView setOpaque:NO];
   
    [_CellWebView loadHTMLString: [self GetCellData:dict isSelectedCell:isSelected forSerialNo:index] baseURL:nil];
    
    

}



- (CGFloat) getCellHeight: (NSMutableDictionary*) dict isSelectedCell:(BOOL) isSelected forSerialNo:(int) index
{
    
    
    NSString *text = [dict objectForKey:@"Question"];
    if(isSelected)
    {
          text =  [NSString stringWithFormat:@"%@ \n %@",[dict objectForKey:@"Question"],[dict objectForKey:@"Answer"]];
          }
   
        CGSize constraint = CGSizeMake(210, 20000.0f);
       CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica-Light" size:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat height = size.height;//MAX(size.height,60);

       return height + (25);
   }

//
//
//-(void)webViewDidFinishLoad:(UIWebView *)webView {
//    
//    CGFloat ht = webView.scrollView.contentSize.height;
//}
//
@end
