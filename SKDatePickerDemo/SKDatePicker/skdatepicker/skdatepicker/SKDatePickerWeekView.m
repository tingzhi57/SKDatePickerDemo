//
//  SKDatePickerWeekView.m
//  skdatepicker
//
//  Created by xiw on 2021/5/3.
//

#import "SKDatePickerWeekView.h"
#import "SKDatePickerView.h"
#import "SKDatePickerMonthView.h"
#import "SKDatePickerDayView.h"
#import "SKDate.h"

#pragma mark - Properties
@interface SKDatePickerWeekView()
@property (nonatomic,weak) SKDatePickerView* datePickerView;
@property (nonatomic,weak) SKDatePickerMonthView* monthView;
@property (nonatomic,assign) NSUInteger index;
@property (nonatomic,strong) NSArray<SKDatePickerDayView*>* dayViews;

@end

@implementation SKDatePickerWeekView
-(instancetype)initWithPickerView:(SKDatePickerView*)pickerView monthView:(SKDatePickerMonthView*)monthView index:(NSUInteger)index
{
    self = [super initWithFrame:CGRectZero];
    self.datePickerView = pickerView;
    self.monthView = monthView;
    self.index = index;
    self.axis = UILayoutConstraintAxisHorizontal;
    self.distribution = UIStackViewDistributionFillEqually;
    [self createDayViews];
    return self;
}

#pragma mark - Create dayView
///fills the weekView stack with dayviews
-(void)createDayViews
{
    NSMutableArray<SKDatePickerDayView*>* tmpArray = [NSMutableArray array];
    
    for (int i = 0; i < 7; i++)
    {
        //guard statement to prevent index getting out or range (some months need only 5 (index 4) weeks, index goes up to 5)
        if(self.index < self.monthView.monthInfo.weekDayInfo.count)
        {
            NSDictionary<NSNumber*,SKDate*>* weekDaysInfo = [self.monthView.monthInfo.weekDayInfo objectAtIndex:self.index];
            SKDate* dayInfo = weekDaysInfo[@(i)];
            
            SKDatePickerDayView* dayView = [[SKDatePickerDayView alloc] initWithPickerView:self.datePickerView monthView:self.monthView weekView:self index:i dayInfo:dayInfo];
            
            [tmpArray addObject:dayView];
            [self addArrangedSubview:dayView];
        }
        else break;
        
    }
    
    self.dayViews = tmpArray;
}

-(NSArray<SKDatePickerDayView*>*)getDaysFrom:(NSDate*)start to:(nullable NSDate*)end
{
    __block NSMutableArray<SKDatePickerDayView*>* tmpArray = [NSMutableArray array];
    [self.dayViews enumerateObjectsUsingBlock:^(SKDatePickerDayView * _Nonnull dayView, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([dayView shouldSelectedInPeriod:start to:end])
        {
            [tmpArray addObject:dayView];
            *stop = (end == nil);
        }
    }];
    
    return tmpArray;
}
@end
