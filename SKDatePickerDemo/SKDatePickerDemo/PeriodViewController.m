//
//  PeriodViewController.m
//  SKDatePickerDemo
//
//  Created by xiw on 2021/5/6.
//

#import "PeriodViewController.h"
#import <skdatepicker/skdatepicker.h>

@interface PeriodViewController ()<SKDatePickerViewDelegate>
@property (weak, nonatomic) IBOutlet SKDatePickerView *datePickerView;
@property (weak, nonatomic) IBOutlet UILabel *periodLabel;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;

@property (nonatomic,strong) NSDateFormatter  * dateFormatter;

@end

@implementation PeriodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    self.datePickerView.delegate = self;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    NSCalendar* calendar = self.datePickerView.calendar;
    NSDateComponents* tmpComponent = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday  | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    tmpComponent.month += 1;
    tmpComponent.hour = 2;
    tmpComponent.minute = 0;
    tmpComponent.second = 0;
    
    NSDate* nextMonthStartDate = [calendar dateFromComponents:tmpComponent];
    tmpComponent.day += 7;
    tmpComponent.hour = 23;
    tmpComponent.minute = 59;
    tmpComponent.second = 59;
    NSDate* nextWeekEndDate = [calendar dateFromComponents:tmpComponent];
    [self.datePickerView presentStartDate:nextMonthStartDate endDate:nextWeekEndDate];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - SKDatePickerViewDelegate methods
-(void)didSelectDay:(NSDate*)date
{
    
}

-(BOOL)shouldContinueSelection
{
    return YES;
}

-(void)didSelectContinueDayFrom:(NSDate*)startDate toEnd:(NSDate*)endDate
{
    if (self.dateFormatter == nil)
    {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.dateFormatter.locale = [NSLocale autoupdatingCurrentLocale];
    }
    
    NSString* startDateString = startDate ? [self.dateFormatter stringFromDate:startDate] : @"";
    NSString* endDateString = endDate ? [self.dateFormatter stringFromDate:endDate] : @"";
    self.periodLabel.text = [NSString stringWithFormat:@"%@ ~ %@",startDateString,endDateString];
    self.warningLabel.text = @"";
}

-(NSInteger)maxPeriodDays
{
    return 90;
}

-(void)warningSelectTooLargeScope
{
    self.warningLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Couldn't exceed %d days", nil),(int)[self maxPeriodDays]];
}

//-(BOOL)shouldShowMonthOutDates
//{
//    return YES;
//}

-(BOOL)shouldShowTimeField
{
    return YES;
}

//-(TimeFiledFormat)timeFiledFormat
//{
//    return TimeFormat_H;
//}

-(SelectionShape)selectionShape
{
    return SelectionShapeRoundedRect;
}

-(UIColor *)colorForSelectedDayText
{
    return [UIColor whiteColor];
}

-(NSDate *)dateToShow
{
    return nil;
}
@end
