//
//  PickersViewController.m
//  SKDatePickerDemo
//
//  Created by xiw on 2021/6/6.
//

#import "PickersViewController.h"
#import <skdatepicker/skdatepicker.h>

@interface PickersViewController ()<SKTimePickerDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation PickersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.containerView)
    {
        NSMutableArray<NSLayoutConstraint *>* otherActiveConstraints = [NSMutableArray array];
        NSArray<NSString*>* timeFormats = [NSArray arrayWithObjects:@"HH:mm:ss",@"HH:mm",@"HH", nil];
        UIView* lastLineView = nil;
        NSInteger lastComponent = TimeComponentAll;
        for (NSString* timeformat in timeFormats)
        {
            UIView* lineView = [self newLineView:lastLineView constraints:otherActiveConstraints];
            lastLineView = lineView;
            
            SKTimePicker* timeField = [SKTimePicker new];
            timeField.timer_delegate = self;
            timeField.lastComponent = lastComponent--;
            timeField.plainField.textAlignment = NSTextAlignmentRight;
            timeField.hour = 14;
            timeField.timeFormateString = timeformat;
            
            [lineView addSubview:timeField];
            [NSLayoutConstraint addEqualToConstraints:timeField superView:lineView attributes:@[@(NSLayoutAttributeRight),@(NSLayoutAttributeHeight)]];

            [otherActiveConstraints addObject:[timeField.widthAnchor constraintEqualToAnchor:lineView.widthAnchor multiplier:0.5f]];

            [timeField updateTimePlainText];

            UILabel* singleTimeLabel = [UILabel new];
            singleTimeLabel.text = timeField.timeFormateString;
            [lineView addSubview:singleTimeLabel];
            [NSLayoutConstraint addEqualToConstraints:singleTimeLabel superView:lineView attributes:@[@(NSLayoutAttributeLeft),@(NSLayoutAttributeHeight)]];

            [otherActiveConstraints addObject:[singleTimeLabel.widthAnchor constraintEqualToAnchor:timeField.widthAnchor]];
            [otherActiveConstraints addObject:[singleTimeLabel.heightAnchor constraintEqualToAnchor:timeField.heightAnchor]];
        }
        
        NSArray<NSString*>* dateFormats = [NSArray arrayWithObjects:@"yyyy-MMM-dd",@"yyyy-MM",@"yyyy", nil];
        lastComponent = DateComponentAll;
        for (NSString* dateformat in dateFormats)
        {
            
            UIView* lineView = [self newLineView:lastLineView constraints:otherActiveConstraints];
            
            lastLineView = lineView;
            
            SKSimpleDatePicker* simpleDatePicker = [SKSimpleDatePicker new];
            simpleDatePicker.dateFormateString = dateformat;
            simpleDatePicker.lastComponent = lastComponent--;
            simpleDatePicker.plainField.textAlignment = NSTextAlignmentRight;
            [lineView addSubview:simpleDatePicker];
            
            [NSLayoutConstraint addEqualToConstraints:simpleDatePicker superView:lineView attributes:@[@(NSLayoutAttributeRight),@(NSLayoutAttributeHeight)]];

            [otherActiveConstraints addObject:[simpleDatePicker.widthAnchor constraintEqualToAnchor:lineView.widthAnchor multiplier:0.5f]];
            [simpleDatePicker updateDatePlainText];
            
            
            UILabel* singleDateLabel = [UILabel new];
            singleDateLabel.text = simpleDatePicker.dateFormateString;
            [lineView addSubview:singleDateLabel];
            [NSLayoutConstraint addEqualToConstraints:singleDateLabel superView:lineView attributes:@[@(NSLayoutAttributeLeft),@(NSLayoutAttributeHeight)]];

            [otherActiveConstraints addObject:[singleDateLabel.widthAnchor constraintEqualToAnchor:simpleDatePicker.widthAnchor]];
            [otherActiveConstraints addObject:[singleDateLabel.heightAnchor constraintEqualToAnchor:simpleDatePicker.heightAnchor]];
        }
        
        UIView* lineView = [self newLineView:lastLineView constraints:otherActiveConstraints];
        
        lastLineView = lineView;
        
        [NSLayoutConstraint activateConstraints:otherActiveConstraints];
    }
    
}

-(UIView*)newLineView:(UIView*)lastLineView constraints:(NSMutableArray<NSLayoutConstraint *>*)otherActiveConstraints
{
    UIView* lineView = [UIView new];
    [self.containerView addSubview:lineView];
    [NSLayoutConstraint addEqualToConstraints:lineView superView:self.containerView attributes:@[@(NSLayoutAttributeCenterX)]];
    [otherActiveConstraints addObject:[lineView.widthAnchor constraintEqualToAnchor:self.containerView.widthAnchor multiplier:0.9f]];
    [otherActiveConstraints addObject:[lineView.heightAnchor constraintEqualToConstant:44]];
    if (lastLineView == nil)
    {
        [otherActiveConstraints addObject:[lineView.topAnchor constraintEqualToAnchor:self.containerView.topAnchor]];
    }
    else
    {
        [otherActiveConstraints addObject:[lineView.topAnchor constraintEqualToAnchor:lastLineView.bottomAnchor]];
    }
    return lineView;
}

-(void)timeValueChanged:(SKTimePicker*)timePicker
{
    
}

-(bool)validateTimeValue:(SKTimePicker*)timePicker
{
    return YES;
}
@end
