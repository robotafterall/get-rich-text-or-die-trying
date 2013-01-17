//
//  DemoTableViewController.m
//  iPhoneMeetupRichTextDemo
//
//  Created by Jeffrey Friesen on 2013-01-17.
//  Copyright (c) 2013 Jeffrey Friesen. All rights reserved.
//

#import "DemoTableViewController.h"
#import "RTLabel.h"
#import "JMImageCache.h"
#import <QuartzCore/QuartzCore.h>

#define MARGIN 10

@interface DemoTableViewController ()

@end

@implementation DemoTableViewController

- (NSString *)formattedStringForString:(NSString *)string atRow:(int)row{
    
    //Do Some Processing of the String
    
    if (row % 4 == 0) {
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@"<u> </u>"];
    }
    
    if (row % 2 == 0) {
        string = [string stringByAppendingString:@"\n<b> Winnipeg iPhone Developer Meetup!!!! </b>"];
    }
    
    if (row % 3 == 0) {
        string = [NSString stringWithFormat:@"<font size=17 color=#ff0000>%@</font>",string];
    }
    
    if (row % 5 == 0) {
        string = [@"<a href=\"http://www.meetup.com/Winnipeg-iPhone-Developer-Meetup\">MEETUP!!!</a>\niOS Developers Rule!!!\n" stringByAppendingString:string];
    }
    
    return string;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return myData.count;
}


//---------------------------------------------------------
//STEP ONE - Put RTLabel in UITableViewCell
//---------------------------------------------------------

- (void)viewDidLoad{
    [super viewDidLoad];
    if (myData == nil) {
        myData = [NSMutableArray new];
    }
    
    for (int i=0; i<100; i++) {
        [myData addObject:@"Get Rich(Text in TableViews) or Die Trying!"];
    }
    
    [self.tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifer = [NSString stringWithFormat:@"%d-%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    
    if (cell == nil) {
        cell = [UITableViewCell new];
        
        RTLabel *label = [RTLabel new];
        label.text = [self formattedStringForString:[myData objectAtIndex:indexPath.row] atRow:indexPath.row];
        [cell addSubview:label];
        label.frame = CGRectMake(MARGIN, MARGIN, self.view.frame.size.width - MARGIN*2, 1000);
        label.frame = CGRectMake(MARGIN, MARGIN, label.frame.size.width, label.optimumSize.height);
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    RTLabel *label = [RTLabel new];
    label.text = [self formattedStringForString:[myData objectAtIndex:indexPath.row] atRow:indexPath.row];
    label.frame = CGRectMake(MARGIN, MARGIN, self.view.frame.size.width - MARGIN*2, 100);
    return label.optimumSize.height + MARGIN*2;
}





//---------------------------------------------------------
//STEP TWO - Render in Background Thread - Refactor RTLabel
//---------------------------------------------------------

/*- (void)viewDidLoad{
    [super viewDidLoad];
    if (myData == nil) {
        myData = [NSMutableArray new];
    }
    
    for (int i=0; i<100; i++) {
        [myData addObject:@"Get Rich(Text in TableViews) or Die Trying!"];
    }
    
    [self.tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifer = [NSString stringWithFormat:@"%d-%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    
    if (cell == nil) {
        cell = [UITableViewCell new];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            RTLabel *label = [RTLabel new];
            label.text = [self formattedStringForString:[myData objectAtIndex:indexPath.row] atRow:indexPath.row];
            
            UIImage *image = [label renderToImageWithSize:CGSizeMake(cell.frame.size.width - MARGIN*2, cell.frame.size.height - MARGIN*2)];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                CALayer *layer = [CALayer layer];
                layer.position = CGPointMake(MARGIN, MARGIN);
                layer.contents = (id)image.CGImage;
                layer.anchorPoint = CGPointMake(0, 0);
                layer.bounds = CGRectMake(MARGIN, MARGIN, cell.frame.size.width - MARGIN*2, cell.frame.size.height - MARGIN*2);
                
                [cell.layer addSublayer:layer];
            });
        });
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    RTLabel *label = [RTLabel new];
    label.text = [self formattedStringForString:[myData objectAtIndex:indexPath.row] atRow:indexPath.row];
    label.frame = CGRectMake(0, 0, self.view.frame.size.width - MARGIN*2, 100);
    return label.optimumSize.height + MARGIN*2;
}*/



//---------------------------------------------------------
//STEP THREE - Pre Process Data for Render
//---------------------------------------------------------

/*- (void)viewDidLoad{
    [super viewDidLoad];
    if (myData == nil) {
        myData = [NSMutableArray new];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        for (int i=0; i<100; i++) {
            
            NSString *displayString = [self formattedStringForString:@"Get Rich(Text in TableViews) or Die Trying!" atRow:i];
            
            RTLabel *label = [RTLabel new];
            label.frame = CGRectMake(0, 0, self.view.frame.size.width-MARGIN*2, 1000);
            label.text = displayString;
            NSValue *size =  [NSValue valueWithCGSize:CGSizeMake(label.frame.size.width, label.optimumSize.height)];
            
            NSDictionary *newData = @{
                @"components":[RTLabel extractTextStyleFromText:displayString paragraphReplacement:@"\n"],
                @"size":size,
                @"displayText":displayString
            };
            
            [myData addObject:newData];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifer = [NSString stringWithFormat:@"%d-%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    
    if (cell == nil) {
        cell = [UITableViewCell new];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            NSDictionary *newData = [myData objectAtIndex:indexPath.row];
            NSValue *value = [[myData objectAtIndex:indexPath.row] objectForKey:@"size"];

            RTLabel *label = [RTLabel new];
            [label setText:[newData objectForKey:@"displayText"] extractedTextComponent:[newData objectForKey:@"components"]];
            
            UIImage *image = [label renderToImageWithSize:value.CGSizeValue];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                CALayer *layer = [CALayer layer];
                layer.position = CGPointMake(MARGIN, MARGIN);
                layer.contents = (id)image.CGImage;
                layer.anchorPoint = CGPointMake(0, 0);
                layer.bounds = CGRectMake(MARGIN, MARGIN, value.CGSizeValue.width, value.CGSizeValue.height);
                
                [cell.layer addSublayer:layer];
            });
        });
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSValue *value = [[myData objectAtIndex:indexPath.row] objectForKey:@"size"];
    return value.CGSizeValue.height + MARGIN*2;
}*/




//---------------------------------------------------------
//STEP THREE - Cache the Image 
//---------------------------------------------------------

/*- (void)viewDidLoad{
    [super viewDidLoad];
    if (myData == nil) {
        myData = [NSMutableArray new];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        for (int i=0; i<100; i++) {
            
            NSString *displayString = [self formattedStringForString:@"Get Rich(Text in TableViews) or Die Trying!" atRow:i];
            
            RTLabel *label = [RTLabel new];
            label.frame = CGRectMake(0, 0, self.view.frame.size.width-MARGIN*2, 1000);
            label.text = displayString;
            NSValue *size =  [NSValue valueWithCGSize:CGSizeMake(label.frame.size.width, label.optimumSize.height)];
            
            NSDictionary *newData = @{
            @"components":[RTLabel extractTextStyleFromText:displayString paragraphReplacement:@"\n"],
            @"size":size,
            @"displayText":displayString
            };
            
            [myData addObject:newData];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifer = [NSString stringWithFormat:@"%d-%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    
    if (cell == nil) {
        cell = [UITableViewCell new];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            UIImage *image = [[JMImageCache sharedCache] cachedImageForKey:identifer];
            
            if (image == nil) {
                NSDictionary *newData = [myData objectAtIndex:indexPath.row];
                NSValue *value = [[myData objectAtIndex:indexPath.row] objectForKey:@"size"];
                
                RTLabel *label = [RTLabel new];
                [label setText:[newData objectForKey:@"displayText"] extractedTextComponent:[newData objectForKey:@"components"]];
                
                image = [label renderToImageWithSize:value.CGSizeValue];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                CALayer *layer = [CALayer layer];
                layer.position = CGPointMake(MARGIN, MARGIN);
                layer.contents = (id)image.CGImage;
                layer.anchorPoint = CGPointMake(0, 0);
                layer.bounds = CGRectMake(MARGIN, MARGIN, image.size.width, image.size.height);
                
                [cell.layer addSublayer:layer];
            });
            
            [[JMImageCache sharedCache] setImage:image forKey:identifer];
        });
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSValue *value = [[myData objectAtIndex:indexPath.row] objectForKey:@"size"];
    return value.CGSizeValue.height + MARGIN*2;
}
*/

@end
