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
@property (nonatomic,strong) UIButton* nextMonthButton;
@property (nonatomic,strong) UIButton* previousMonthButton;
@property (nonatomic,strong) UILabel* dateLabel;
@property (nonatomic,strong) SKDatePickerView* datePickerView;
@end

@implementation SingleDateViewController

#pragma mark - UI SetUp methods
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.translatesAutoresizingMaskIntoConstraints = false;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM"];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    for (NSLayoutConstraint *constraint in self.view.constraints) {
//        if((constraint.firstItem == self.topLayoutGuide && constraint.secondItem == self.view) ||
//           (constraint.secondItem == self.topLayoutGuide && constraint.firstItem == self.view))         {
//            constraint.constant = 20;
//        }
//    }
#if TITLEBAR
    
    NSMutableArray<NSLayoutConstraint *>* otherActiveConstraints = [NSMutableArray array];
    // Setup title bar.
    UIView* titleView = [UIView new];
    [self.view addSubview:titleView];
    
    [NSLayoutConstraint addEqualToConstraints:titleView superView:self.view attributes:@[@(NSLayoutAttributeTop),@(NSLayoutAttributeLeft),@(NSLayoutAttributeRight)]];
    [otherActiveConstraints addObject:[titleView.heightAnchor constraintEqualToConstant:84]];

    // Setup previousMonthButton
    self.previousMonthButton = [UIButton new];
    [self.previousMonthButton setTitle:@" < " forState:UIControlStateNormal];
    [self.previousMonthButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [self.previousMonthButton addTarget:self action:@selector(gotoPreviewMonth) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:self.previousMonthButton];
    
    [NSLayoutConstraint addEqualToConstraints:self.previousMonthButton superView:titleView attributes:@[@(NSLayoutAttributeBottom),@(NSLayoutAttributeLeft)]];

    [otherActiveConstraints addObject:[self.previousMonthButton.heightAnchor constraintEqualToConstant:32]];

    [otherActiveConstraints addObject:[self.previousMonthButton.widthAnchor constraintEqualToAnchor:self.previousMonthButton.heightAnchor]];

    // Setup nextMonthButton
    self.nextMonthButton = [UIButton new];
    [self.nextMonthButton setTitle:@" > " forState:UIControlStateNormal];
    [self.nextMonthButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.nextMonthButton addTarget:self action:@selector(gotoNextMonth) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:self.nextMonthButton];

    [NSLayoutConstraint addEqualToConstraints:self.nextMonthButton superView:titleView attributes:@[@(NSLayoutAttributeBottom),@(NSLayoutAttributeRight)]];

    [otherActiveConstraints addObject:[self.nextMonthButton.heightAnchor constraintEqualToAnchor:self.previousMonthButton.heightAnchor]];
    [otherActiveConstraints addObject:[self.nextMonthButton.widthAnchor constraintEqualToAnchor:self.previousMonthButton.widthAnchor]];
    

    // Setup dateLabel
    self.dateLabel = [UILabel new];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:self.dateLabel];
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = false;

    [otherActiveConstraints addObject:[self.dateLabel.bottomAnchor constraintEqualToAnchor:titleView.bottomAnchor]];

    [otherActiveConstraints addObject:[self.dateLabel.heightAnchor constraintEqualToAnchor:self.previousMonthButton.heightAnchor]];

    [otherActiveConstraints addObject:[self.dateLabel.leftAnchor constraintEqualToAnchor:self.previousMonthButton.rightAnchor]];

    [otherActiveConstraints addObject:[self.dateLabel.rightAnchor constraintEqualToAnchor:self.nextMonthButton.leftAnchor]];
#endif
    
    self.datePickerView = [SKDatePickerView new];
    
    [self.view addSubview:self.datePickerView];
    
    [NSLayoutConstraint addEqualToConstraints:self.datePickerView superView:self.view attributes:@[@(NSLayoutAttributeBottom),@(NSLayoutAttributeRight),@(NSLayoutAttributeLeft)]];
    
    [[self.datePickerView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor] setActive:YES];
    
#if TITLEBAR
    [otherActiveConstraints addObject:[self.datePickerView.topAnchor constraintEqualToAnchor:titleView.bottomAnchor]];
    [NSLayoutConstraint activateConstraints:otherActiveConstraints];
#endif
    
    self.datePickerView.delegate = self;
}

#pragma mark - previous & next month
-(void)gotoPreviewMonth
{
    [self.datePickerView loadPreviousView];
}

-(void)gotoNextMonth
{
    [self.datePickerView loadNextView];
}

#pragma mark - SKDatePickerViewDelegate methods
-(void)didSelectDay:(NSDate *)date
{
    
}

-(void)didPresentOtherMonth:(SKDatePickerMonthView *)monthView
{
    self.dateLabel.text = [self.dateFormatter stringFromDate:monthView.date];
}

//-(NSLocale*)preferredLocal
//{
////    NSLog(@"%s,[%@]",__func__,[[NSLocale systemLocale] localeIdentifier]);
////    NSLog(@"%s,[%@]",__func__,[[NSLocale autoupdatingCurrentLocale] localeIdentifier]);
////    NSLog(@"%s,[%@]",__func__,[[NSLocale currentLocale] localeIdentifier]);
//    return [NSLocale autoupdatingCurrentLocale];
//}

-(BOOL)shouldHideTopToolBar
{
    return YES;
}

-(NSString*)monthFormatString
{
    return @"YYYY MMM";
}
@end
