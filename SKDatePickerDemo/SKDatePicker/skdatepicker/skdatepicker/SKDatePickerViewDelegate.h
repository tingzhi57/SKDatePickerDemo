//
//  SKDatePickerViewDelegate.h
//  skdatepicker
//
//  Created by xiw on 2021/5/3.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#define MAX_PERIOD_SELECT_DAYS 45

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SelectionShape)
{
    SelectionShapeCircle,
    SelectionShapeSquare,
    SelectionShapeRoundedRect
};


@class SKDatePickerDayView;
@class SKDatePickerMonthView;

@protocol SKDatePickerViewDelegate <NSObject>
@required
/**
 Is called when the user selected a day
 - parameter date: the date of the user selected
 - note:
 Implementing this method is mandatory
 */
-(void)didSelectDay:(NSDate*)date;


@optional
-(void)didSelectContinueDayFrom:(NSDate*)startDate toEnd:(NSDate*)endDate;
-(void)warningSelectTooLargeScope:(NSInteger)maxPeriodDays;
/**
 Sets the first day of the week.
 - note:
 Implementing this variable is optional. It's default is set to the locale.
 */
-(NSInteger)firstWeekDay;
/**
 Is called when the user swiped (or manually moved) to another month
 - parameter monthView: the monthView that is now 'on screen'
 - note:
 Implementing this method is optional.
 */
-(void)didPresentOtherMonth:(SKDatePickerMonthView*)monthView;

/**
 Is called to check if any particular date is selectable by the picker
 - parameter date: the date to check if allowed
 - note:
 Implementing this method is optional.
 */
-(BOOL)shouldAllowSelectionOfDay:(NSDate*)date;

/**
 Determines if a month should also show the dates of the previous and next month
 - note:
 Implementing this variable is optional. It's default is set to false.
 */
-(BOOL)shouldShowMonthOutDates;

/**
 Determines if the weekday symbols and the month description should follow available localizations
 - note:
 Implementing this variable is optional. It's default is set to false. This means that the weekday symbols
 and the month description will be in the same language as the device language. If you want it to conform to the
 localization of your app, return true here. If you return true and your app is not localized, the weekday symbols and
 the month description will be in the development language.
 */
//-(BOOL)shouldLocalize;
-(NSLocale*)preferredLocal;
-(NSString*)monthFormatString;

-(BOOL)shouldContinueSelection;

/**
 Determines if hide month label or next|previous moth button
- note:
Implementing this variable is optional. It's default is set to false.
 */
-(BOOL)shouldHideTopToolBar;

#pragma mark - General appearance properties
///color of any date label text that falls within the presented month
-(UIColor*)colorForDayLabelInMonth;

///color of any date label text that falls out of the presented month and is part of the next or previous (but not presented) month
-(UIColor*)colorForDayLabelOutOfMonth;

///color of any date label text that occurs outside the allowed selectable days (day earlier than earliest selectable or later than last selectable)
-(UIColor*)colorForUnavaibleDay;

///color of the 'today' date label text
-(UIColor*)colorForToday;

///color of any label text that is selected
-(UIColor*)colorForSelectedDayText;

///color of the labels in the WeekdaysView bar that say 'mon' to 'sun'. Defaults to [UIColor darkTextColor].
-(UIColor*)colorForWeekLabelsText;
-(UIColor*)colorForWeekDaysViewBackground;

-(UIColor*)colorForTopbarText;
-(UIColor*)colorForTopbarBackground;
///color of the selection dates
-(UIColor*)colorForSelectionBackground;

///color of the semi selected selection circle (that shows on a long press)
-(UIColor*)colorForSemiSelectedSelectionCircle;

/**
 Determines the shape that is used to indicate a selected date. Possiblilities are:
 .circle, .square, .roundedRect
 
 - note:
 Implementing this variable is optional. It's default is set to square.
 
 */
-(SelectionShape)selectionShape;
/**
 font of the date labels.
 */
-(UIFont*)fontForDayLabel;
-(UIFont*)fontForWeekDaysViewText;
-(UIFont*)fontForTopbarText;

/**
 Determines the height ratio of the weekDaysView and top toolbar compared to the total height
 
 - note:
 Implementing this variable is optional. It's default is set to 0.1 (10%).
 
 */
-(CGFloat)rowViewHeightRatio;

/**
 Is called when setting up the calendar view as an override point for customization of weekday labels
 - parameter calendar: calendar instance used by the calendar view
 */
-(NSArray<NSString*>*)weekdaySymbols:(NSCalendar*)calendar;


/**
 Sets the day that determines which month is shown on initial load
 - note:
 Implementing this variable is optional. It's default is set the current date.
 */
-(NSDate*)dateToShow;

@end

NS_ASSUME_NONNULL_END
