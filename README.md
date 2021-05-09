# SKDatePickerDemo
# Description

SKDatePicker is a Objective-C version of JBDatePicker(https://cocoapods.org/pods/JBDatePicker), that shows a calendar month in which the user can select a date or period. It allows the user to swipe between months, and to preselect a specific date. It's appearance is largely customizable. 

# Requirements
* ARC
* iOS9

# Screenshots

![Simulator Screen Shot - iPhone 11 Pro - 2021-05-09 at 22 42 47](https://user-images.githubusercontent.com/5214062/117576353-4632d500-b118-11eb-9a09-2394ec490663.png)
![Simulator Screen Shot - iPhone 11 Pro - 2021-05-09 at 22 43 06](https://user-images.githubusercontent.com/5214062/117576350-429f4e00-b118-11eb-9b9f-1ad123e1ffdc.png)

# Usage
## Storyboard setup

Add a UIView to your storyboard, go to the identity inspector and select SKDatePickerView as the custom class for your new view. Next, open the assistant editor and control drag to your viewController to create an outlet, then make sure that you import skdatepicker.h and that implements the ‘SKDatePickerViewDelegate’ protocol: like this:

```
#import <skdatepicker/skdatepicker.h> 

@interface PeriodViewController () <SKDatePickerViewDelegate> 

@property (weak, nonatomic) IBOutlet SKDatePickerView *datePickerView; 
 
@end 
```

Don't forget to set your viewController as the delegate of SKDatePicker, for example in viewDidLoad:
```
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.datePickerView.delegate = self;
}
```

## Code setup

It is also possible to setup SKDatePicker without using Interface Builder. This is a code example:
```
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    self.datePickerView = [[SKDatePickerView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    [self.view addSubview:self.datePickerView];
    
    self.datePickerView.delegate = self;
}
```

## Delegate functionality
Only one required method in SKDatePickerViewDelegate
```
-(void)didSelectDay:(NSDate*)date;
```
Besides it, there are many optional methods in SKDatePickerViewDelegate.h, you can read it.

# Example Project

An example project is included with this repo.

# Special thanks to
Joost van Breukelen for creating the Swift version of this library, where this library was ported from.

# License

SKDatePicker is available under the MIT license. 
