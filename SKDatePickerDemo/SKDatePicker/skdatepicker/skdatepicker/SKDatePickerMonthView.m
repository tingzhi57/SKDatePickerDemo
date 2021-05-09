//
//  SKDatePickerMonthView.m
//  skdatepicker
//
//  Created by xiw on 2021/5/3.
//

#import "SKDatePickerMonthView.h"
#import "SKDatePickerView.h"
#import "SKDatePickerWeekView.h"
#import "SKDatePickerDayView.h"
#import "SKDate.h"
#import "SKDatePickerManager.h"

@interface SKDatePickerMonthView()
@property (nonatomic,weak) SKDatePickerView* datePickerView;

@property (nonatomic, strong) NSArray<SKDatePickerWeekView*>* weekViews;
@property (nonatomic, strong, nullable) NSArray<SKDatePickerDayView*>* selectDays;

@end
@implementation SKDatePickerMonthView

-(instancetype)initWithPickerView:(SKDatePickerView*)pickerView date:(NSDate*)date isPresented:(BOOL)isPresented
{
    self = [super initWithFrame:CGRectZero];
    self.datePickerView = pickerView;
    self.date = date;
    self.isPresented = isPresented;
    self.axis = UILayoutConstraintAxisVertical;
    self.distribution = UIStackViewDistributionFillEqually;

    SKDatePickerManager* datePickerManager = self.datePickerView.manager;
    self.monthInfo = [datePickerManager getMonthInfoForDate:self.date];
#if 0
    self.numberOfWeeks = self.monthInfo.numberOfWeeksInMonth;
    self.monthDescription = datePickerView.monthDescriptionForDate(self.date)
#endif
    //this is needed to inform the delegate about the presented month
    //the property observer isn't called on initialization
    if (self.isPresented)
    {
        self.datePickerView.presentedMonthView = self;
    }
    
    return self;
}

-(void)setIsPresented:(BOOL)isPresented
{
    if (isPresented) {
        self.datePickerView.presentedMonthView = self;
    }
    _isPresented = isPresented;
}

#pragma mark - Reloading
-(void)reloadSubViewsWithFrame:(CGRect)frame
{
    self.frame = frame;
}

#pragma mark - Create weekviews

-(void)createWeekViews
{
    for (SKDatePickerWeekView* weekView in self.weekViews)
    {
        [weekView removeFromSuperview];
    }
    
    NSMutableArray<SKDatePickerWeekView*>* tmpWeekViews = [NSMutableArray arrayWithCapacity:self.monthInfo.numberOfWeeksInMonth];
    
    for (int i = 0; i < self.monthInfo.numberOfWeeksInMonth; i++)
    {
        SKDatePickerWeekView* weekView = [[SKDatePickerWeekView alloc] initWithPickerView:self.datePickerView monthView:self index:i];
        [tmpWeekViews addObject:weekView];
        [self addArrangedSubview:weekView];
    }
    
    self.weekViews = tmpWeekViews;
}

-(NSDate*)firstVisibleDate
{
    if ([self.datePickerView shouldShowMonthOutDates])
    {
        SKDate* skdate = self.monthInfo.weekDayInfo.firstObject[@(0)];
        return skdate.date;
    }
    return self.monthInfo.monthStartDay;
}

-(NSDate*)lastVisibleDate
{
    if ([self.datePickerView shouldShowMonthOutDates])
    {
        SKDate* skdate = self.monthInfo.weekDayInfo.lastObject[@(6)];
        return skdate.date;
    }
    return self.monthInfo.monthEndDay;
}

-(void)clearAllSelectDays
{
    for (SKDatePickerDayView* dayView in self.selectDays)
    {
        [dayView deselect];
    }
    self.selectDays = nil;
}


-(void)selectDate:(NSDate*)date
{
    [self clearAllSelectDays];
    NSDate* firstDate = [self firstVisibleDate];
    if ([[date earlierDate:firstDate] isEqualToDate:date] && ![date isEqualToDate:firstDate])
    {
        return;
    }
    
    NSDate* lastDate = [self lastVisibleDate];
    if ([[date laterDate:lastDate] isEqualToDate:date] && ![date isEqualToDate:lastDate])
    {
        return;
    }
    
    for (SKDatePickerWeekView* weekView in self.weekViews)
    {
        NSArray<SKDatePickerDayView*>* dayArray = [weekView getDaysFrom:date to:nil];
        if (dayArray.firstObject)
        {
            [dayArray.firstObject select];
            self.selectDays = dayArray;
            break;
        }
    }
}


-(void)selectPeriod:(NSDate*)start end:(NSDate*)end
{
    [self clearAllSelectDays];
    NSDate* firstDate = [self firstVisibleDate];
    if ([[end earlierDate:firstDate] isEqualToDate:end] && ![end isEqualToDate:firstDate])
    {
        return;
    }
    
    NSDate* lastDate = [self lastVisibleDate];
    if ([[start laterDate:lastDate] isEqualToDate:start] && ![start isEqualToDate:lastDate])
    {
        return;
    }
    NSMutableArray<SKDatePickerDayView*>* newSelectDays = [NSMutableArray array];
    for (SKDatePickerWeekView* weekView in self.weekViews)
    {
        NSArray<SKDatePickerDayView*>* dayArray = [weekView getDaysFrom:start to:end];
        for (SKDatePickerDayView* dayView in dayArray)
        {
            [dayView select];
            [newSelectDays addObject:dayView];
        }
    }
    self.selectDays = newSelectDays;
}

-(void)addSelectDayView:(SKDatePickerDayView*)dayView
{
    NSMutableArray<SKDatePickerDayView*>* newSelect = nil;
    if (self.selectDays)
    {
        newSelect = [NSMutableArray arrayWithArray:self.selectDays];
    }else newSelect = [NSMutableArray array];
    [newSelect addObject:dayView];
    self.selectDays = newSelect;
}
@end
