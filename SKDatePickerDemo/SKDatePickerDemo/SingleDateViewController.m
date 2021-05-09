//
//  ViewController.m
//  SKDatePickerDemo
//
//  Created by xiw on 2021/5/6.
//

#import "SingleDateViewController.h"
#import <skdatepicker/skdatepicker.h>

@interface SingleDateViewController ()<SKDatePickerViewDelegate>

@property (nonatomic,strong) NSDateFormatter  * dateFormatter;
@property (nonatomic,strong) SKDatePickerView* datePickerView;

@end

@implementation SingleDateViewController

#pragma mark - UI SetUp methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datePickerView = [SKDatePickerView new];
    
    [self.view addSubview:self.datePickerView];
    
    [NSLayoutConstraint addEqualToConstraints:self.datePickerView superView:self.view attributes:@[@(NSLayoutAttributeBottom),@(NSLayoutAttributeRight),@(NSLayoutAttributeLeft)]];
    
    if (@available(iOS 11.0, *))
    {
        [[self.datePickerView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor] setActive:YES];
    }
    else
    {
        // Fallback on earlier versions
    }
    
    self.datePickerView.delegate = self;
}


#pragma mark - SKDatePickerViewDelegate methods
-(void)didSelectDay:(NSDate *)date
{
    if (self.dateFormatter == nil)
    {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    
    UIAlertController* alertControl = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Selected Date", @"Selected Date") message:[self.dateFormatter stringFromDate:date] preferredStyle:UIAlertControllerStyleAlert];
    __weak id selfWeak = self;
    
    [alertControl addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [selfWeak dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alertControl animated:YES completion:nil];
    
}

-(BOOL)shouldShowMonthOutDates
{
    return YES;
}
//-(NSLocale*)preferredLocal
//{
////    NSLog(@"%s,[%@]",__func__,[[NSLocale systemLocale] localeIdentifier]);
////    NSLog(@"%s,[%@]",__func__,[[NSLocale autoupdatingCurrentLocale] localeIdentifier]);
////    NSLog(@"%s,[%@]",__func__,[[NSLocale currentLocale] localeIdentifier]);
//    return [NSLocale autoupdatingCurrentLocale];
//}

-(NSString*)monthFormatString
{
    return @"YYYY MMM";
}


#pragma mark - Colors methods
-(UIColor *)colorForTopbarBackground
{
    return [UIColor orangeColor];
}

-(UIColor *)colorForTopbarText
{
    return [UIColor whiteColor];
}

-(UIColor *)colorForWeekDaysViewBackground
{
    return [self colorForTopbarBackground];
}

-(UIColor *)colorForWeekLabelsText
{
    return [self colorForTopbarText];
}

-(UIColor *)colorForSelectionBackground
{
    return [self colorForTopbarBackground];
}

-(UIColor *)colorForSelectedDayText
{
    return [self colorForTopbarText];
}
@end
