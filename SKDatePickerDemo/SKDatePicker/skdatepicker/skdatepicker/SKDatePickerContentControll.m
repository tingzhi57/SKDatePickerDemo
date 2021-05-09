//
//  SKDatePickerContentControll.m
//  skdatepicker
//
//  Created by xiw on 2021/5/4.
//

#import "SKDatePickerContentControll.h"
#import "SKDatePickerView.h"
#import "SKDatePickerMonthView.h"
#import "SKDatePickerManager.h"
#import "NSLayoutConstraint+SKConstraint.h"

typedef NS_ENUM(NSInteger, MonthViewIdentifier)
{
    MonthViewIdentifierPrevious,
    MonthViewIdentifierPresented,
    MonthViewIdentifierNext
};

@interface SKDatePickerContentControll ()<UIScrollViewDelegate>

@property (nonatomic, weak) SKDatePickerView* datePickerView;
@property (nonatomic, strong) SKDatePickerMonthView* presentedMonthView;
@property (nonatomic, strong) NSMutableDictionary<NSNumber*,SKDatePickerMonthView*>* monthViews;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger scrollDirection;
@property (nonatomic, assign) BOOL isPresenting;

@end

@implementation SKDatePickerContentControll

-(instancetype)initWithPickerView:(SKDatePickerView*)pickerView frame:(CGRect)frame presentedDate:(NSDate*)date
{
    self = [self init];
    self.datePickerView = pickerView;
    _scrollView = [[UIScrollView alloc] initWithFrame:frame];
    
    //setup scrollView. Give it a contentsize of 3 times the width because it will hold 3 monthViews
    self.scrollView.contentSize = CGSizeMake(frame.size.width * 3, frame.size.height);
    self.scrollView.showsHorizontalScrollIndicator = false;
    self.scrollView.showsVerticalScrollIndicator = false;
    self.scrollView.layer.masksToBounds = true;
    self.scrollView.scrollEnabled = YES;
    [self.scrollView setPagingEnabled:true];
    self.scrollView.delegate = self;
    
    
    //create the current Monthview for the current date and fill it with weekviews.
    self.monthViews = [NSMutableDictionary dictionaryWithCapacity:3];
    self.presentedMonthView = [[SKDatePickerMonthView alloc] initWithPickerView:self.datePickerView date:date isPresented:YES];
    
    [self.presentedMonthView createWeekViews];
    [self addInitialMonthViews:date];
    return self;
}

#pragma mark - Adding of MonthViews

/**
 Fills the scrollView of the contentController
 with the initial three monthViews
 
 - Parameter date: the Date object to pass
 
 */
-(void)addInitialMonthViews:(NSDate*)date
{
    
    //add the three monthViews to the scrollview
    [self addMonthView:self.presentedMonthView withIdentifier:MonthViewIdentifierPresented];
    [self addMonthView:[self getOtherMonthView:date withIdentifier:MonthViewIdentifierPrevious] withIdentifier:MonthViewIdentifierPrevious];
    [self addMonthView:[self getOtherMonthView:date withIdentifier:MonthViewIdentifierNext] withIdentifier:MonthViewIdentifierNext];
}

///returns the previous monthView for a given date
-(SKDatePickerMonthView*)getOtherMonthView:(NSDate*)date  withIdentifier:(MonthViewIdentifier)identifier
{
    
    NSCalendar* cal = self.datePickerView.manager.calendar;
    NSDateComponents* comps = [cal components:(NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:date];
    if (identifier == MonthViewIdentifierPrevious) {
        
        comps.month -= 1;
    }else if (identifier == MonthViewIdentifierNext)
    {
        
        comps.month += 1;
    }
    NSDate* firstDateOfPreviousMonth = [cal dateFromComponents:comps];
    SKDatePickerMonthView* previousMonthView = [[SKDatePickerMonthView alloc] initWithPickerView:self.datePickerView date:firstDateOfPreviousMonth isPresented:false];

    //this is what gives new new monthView it's initial frame
    previousMonthView.frame = self.scrollView.frame;
    [previousMonthView createWeekViews];
    
    return previousMonthView;
}

/**
 Adds the given monthView to the contentControllers scrollView and updates
 the given monthViews frame origin to place it in the correct position.
 
 - Parameter monthView: the MonthView to be added
 - Parameter identifier: can be .previous, .presented or .next
 
 */
-(void)addMonthView:(SKDatePickerMonthView*)monthView withIdentifier:(MonthViewIdentifier)identifier
{
    CGRect frame = monthView.frame;
    frame.origin = CGPointMake(self.scrollView.bounds.size.width * identifier, 0);
//    frame.size = self.scrollView.bounds.size;
    self.monthViews[@(identifier)] = monthView;
    monthView.frame = frame;
    [self.scrollView addSubview:monthView];
    //[NSLayoutConstraint addEqualToConstraints:monthView superView:self.scrollView attributes:@[@(NSLayoutAttributeTop),@(NSLayoutAttributeBottom),@(NSLayoutAttributeWidth),@(NSLayoutAttributeHeight)]];
}
/**
 Replaces the identifier of a monthView with another identifier, so it's gets another role. The presented monthView will, for example, become the next monthView. The frame origin of the monthView involved will also be adjusted and scrolled into position if needed.
 
 - Parameter monthView: the monthView involved
 - Parameter identifier: the new identifier that the monthView will get
 - Parameter shouldScrollToPosition: a boolean that determines if the monthView's frame should scroll into position or not
 
 */
-(void)replaceMonthViewIdentifier:(SKDatePickerMonthView*)monthView  withIdentifier:(MonthViewIdentifier)identifier shouldScrollToPosition:(BOOL)scrollPosition
{
    
    //adjust frame to the frame that comes with the new identifier (the new role)
    CGRect monthViewFrame = monthView.frame;
    monthViewFrame.origin.x = monthViewFrame.size.width * identifier;
    monthView.frame = monthViewFrame;
    
    //update the monthViews dictionary
    self.monthViews[@(identifier)] = monthView;
    
    //scroll the new 'presented' monthView into the presented position.
    //this will also cause the currentPage to be set to 1 again by the didScroll delegate method
    if (scrollPosition)
    {
        [self.scrollView scrollRectToVisible:monthViewFrame animated:false];
    }
}
#pragma mark - Scrolling MonthViews

-(void)scrolledToPreviousMonth
{
    SKDatePickerMonthView* previousMonthView = self.monthViews[@(MonthViewIdentifierPrevious)];
    SKDatePickerMonthView* presentedMonthView = self.monthViews[@(MonthViewIdentifierPresented)];
    
    //remove next monthView, this will be replaced by presented monthView
    [self.monthViews[@(MonthViewIdentifierNext)] removeFromSuperview];
    
    //replace previous monthView identifier with 'presented' identifier and set isPresented value
    [self replaceMonthViewIdentifier:previousMonthView withIdentifier:MonthViewIdentifierPresented shouldScrollToPosition:YES];
    
    previousMonthView.isPresented = true;
    
    //replace presented monthView identifier with 'next' identifier and set isPresented value
    [self replaceMonthViewIdentifier:presentedMonthView withIdentifier:MonthViewIdentifierNext shouldScrollToPosition:NO];
    presentedMonthView.isPresented = false;
    
    //add new monthView which will become the new 'previous' monthView
    [self addMonthView:[self getOtherMonthView:previousMonthView.date withIdentifier:MonthViewIdentifierPrevious] withIdentifier:MonthViewIdentifierPrevious];
}


-(void)scrolledToNextMonth
{
    
    SKDatePickerMonthView* nextMonthView =  self.monthViews[@(MonthViewIdentifierNext)];
    SKDatePickerMonthView* presentedMonthView = self.monthViews[@(MonthViewIdentifierPresented)];
    
    //remove previous monthView, this will be replaced by presented monthView
    [self.monthViews[@(MonthViewIdentifierPrevious)] removeFromSuperview];
    
    //replace next monthView identifier with 'presented' identifier and set isPresented value
    [self replaceMonthViewIdentifier:nextMonthView withIdentifier:MonthViewIdentifierPresented shouldScrollToPosition:YES];
    nextMonthView.isPresented = true;
    
    //replace presented monthView identifier with 'previous' identifier and set isPresented value
    [self replaceMonthViewIdentifier:presentedMonthView withIdentifier:MonthViewIdentifierPrevious shouldScrollToPosition:NO];
    presentedMonthView.isPresented = false;
    
    //add new monthView which will become the new 'next' monthView
    [self addMonthView:[self getOtherMonthView:nextMonthView.date withIdentifier:MonthViewIdentifierNext] withIdentifier:MonthViewIdentifierNext];
}

#pragma mark - Reloading and replacing of MonthViews

/**
 Updates the frame of the scrollView and reloads the monthViews present
 When called, scrolls to presented monthView
 
 - Parameter frame: the frame to update to
 - Note: is only called on initial load of datePicker
 
 */
-(void)updateScrollViewFrame:(CGRect)frame
{
    self.scrollView.contentSize = CGSizeMake(frame.size.width * 3,  frame.size.height);
    CGRect monthViewFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.monthViews[@(MonthViewIdentifierPrevious)].frame = monthViewFrame;
    monthViewFrame.origin = CGPointMake(monthViewFrame.origin.x + frame.size.width, monthViewFrame.origin.y);
    self.monthViews[@(MonthViewIdentifierPresented)].frame = monthViewFrame;
    CGRect presentedMonthViewFrame = monthViewFrame;
    monthViewFrame.origin = CGPointMake(monthViewFrame.origin.x + frame.size.width, monthViewFrame.origin.y);
    self.monthViews[@(MonthViewIdentifierNext)].frame = monthViewFrame;
    //scroll the new 'presented' monthView into the presented position.
    //this will also cause the currentPage to be set to 1 again by the didScroll delegate method
    [self.scrollView scrollRectToVisible:presentedMonthViewFrame animated:false];
}

#pragma mark - UIScrollViewDelegate
-(BOOL)pageChanged
{
    return  self.currentPage != 1;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.frame.size.width > 0) {
        
        NSInteger page = (NSInteger)floor(scrollView.contentOffset.x / scrollView.frame.size.width);
        if (self.currentPage != page)
        {
            self.currentPage = page;
        }
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //decide in which direction the user did scroll
    if (decelerate)
    {
        CGFloat rightBorderOfScrollView = scrollView.frame.size.width;
        if( scrollView.contentOffset.x <= rightBorderOfScrollView ){
            self.scrollDirection = -1;
        } else {
            self.scrollDirection = 1;
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self pageChanged])
    {
        switch( self.scrollDirection)
        {
            case 1:
                [self scrolledToNextMonth];
                break;
            case -1:
                [self scrolledToPreviousMonth];
                break;
            default:
                break;
        }
    }
    
    self.scrollDirection = 0;
}

#pragma mark - Presenting of monthViews
-(void)scollMonthViewPosition:(NSInteger)multiple
{
    SKDatePickerMonthView* previous =  self.monthViews[@(MonthViewIdentifierPrevious)];
    SKDatePickerMonthView* next =  self.monthViews[@(MonthViewIdentifierNext)];
    SKDatePickerMonthView* presented = self.monthViews[@(MonthViewIdentifierPresented)];
    
    CGRect frame = previous.frame;
    frame.origin.x += self.scrollView.frame.size.width * multiple;
    previous.frame = frame;
    frame = presented.frame;
    frame.origin.x += self.scrollView.frame.size.width * multiple;
    presented.frame = frame;
    frame = next.frame;
    frame.origin.x += self.scrollView.frame.size.width * multiple;
    next.frame = frame;
}

-(void)presentNextView
{
    if (!self.isPresenting)
    {
        
        self.isPresenting = true;
        [UIView animateWithDuration:0.5 animations:^{
            //animate positions of monthViews
            [self scollMonthViewPosition:-1];
        } completion:^(BOOL finished) {
            [self scrolledToNextMonth];
//            //replace identifiers
//            self.replaceMonthViewIdentifier(presented, with: .previous, shouldScrollToPosition: false)
//            self.replaceMonthViewIdentifier(next, with: .presented, shouldScrollToPosition: false)
//            self.presentedMonthView = next
//
//            //set isPresented value
//            previous.isPresented = false
//            self.presentedMonthView.isPresented = true
//
//            //remove previous monthView
//            previous.removeFromSuperview()
//
//            //create and insert new 'next' monthView
//            self.addMonthView(self.getNextMonthView(for: next.date), withIdentifier: .next)
            self.isPresenting = false;
        }];
    }
}

-(void)presentPreviousView
{
    if (!self.isPresenting)
    {
        self.isPresenting = true;
        
        [UIView animateWithDuration:0.5 animations:^{
            //animate positions of monthViews
            
            [self scollMonthViewPosition: 1];
        } completion: ^(BOOL finished) {
            [self scrolledToPreviousMonth];
            self.isPresenting = false;
        }];
    }
}


-(void)reSelectPeriodDays
{
    NSLog(@"%s,%@ - %@",__FUNCTION__,self.startDate,self.endDate);
    for (SKDatePickerMonthView* monthView in self.monthViews.allValues)
    {
        if (self.startDate == nil && self.endDate == nil)
        {
            [monthView clearAllSelectDays];
        }
        else if(self.endDate == nil)
        {
            [monthView selectDate:self.startDate];
        }
        else
        {
            [monthView selectPeriod:self.startDate end:self.endDate];
        }
    }
}

-(BOOL)checkVaildPeriod:(NSDate*)start end:(NSDate*)end
{
    if (start != nil && end != nil)
    {
        NSTimeInterval gap = fabs([start timeIntervalSinceDate:end]);
        double maxDays = MAX_PERIOD_SELECT_DAYS;
        return gap < maxDays * 24 * 60 * 60;
    }
    return YES;
}

-(BOOL)calculateStartDateAndEndDate:(NSDate*)selectDate
{
    if (self.startDate == nil && self.endDate == nil)
    {
        self.startDate = selectDate;
        return YES;
    }
    NSDate* start;
    NSDate* end;
    if(self.endDate == nil)
    {
        NSDate* tmpDate = [self.startDate earlierDate:selectDate];
        if ([tmpDate isEqualToDate:self.startDate])
        {
            start = self.startDate;
            end = selectDate;
        }else
        {
            end = self.startDate;
            start = selectDate;
        }
    }
    else
    {
        //Only if startDate&endDate aren't nil.
        NSDate* tmpDate = [self.startDate earlierDate:selectDate];
        if ([tmpDate isEqualToDate:self.startDate])
        {
            tmpDate = [self.endDate laterDate:selectDate];
            if ([tmpDate isEqualToDate:self.endDate])
            {
                start = selectDate;
                end = self.endDate;
            }
            else
            {
                start = self.startDate;
                end = selectDate;
            }
        }
        else
        {
            end = self.startDate;
            start = selectDate;
        }
    }
    if ([self checkVaildPeriod:start end:end])
    {
        self.startDate = start;
        self.endDate = end;
        return YES;
    }
    return NO;
}
@end
