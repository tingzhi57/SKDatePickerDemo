//
//  SKColumnPicker.m
//  skdatepicker
//
//  Created by xiw on 2021/5/24.
//

#import "SKColumnPicker.h"
#import "NSLayoutConstraint+SKConstraint.h"

@interface SKColumnPicker()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField* plainField;
@property (nonatomic,strong) UIView* pickerView;
@property (nonatomic,strong) UIPickerView* columnView;
@end

@implementation SKColumnPicker

-(void)commonInit
{
    if (self.pickerView == nil) {
        self.pickerView = [UIView new];
        [self addSubview:self.pickerView];
        [NSLayoutConstraint addEqualToConstraints:self.pickerView superView:self attributes:@[@(NSLayoutAttributeTop),@(NSLayoutAttributeRight),@(NSLayoutAttributeBottom),@(NSLayoutAttributeLeft)]];
    }
    if(self.columnView == nil)
    {
        self.columnView = [UIPickerView new];
        self.columnView.dataSource = self.datasource;
        [self.pickerView addSubview:self.columnView];
        [NSLayoutConstraint addEqualToConstraints:self.columnView superView:self.pickerView attributes:@[@(NSLayoutAttributeCenterY),@(NSLayoutAttributeCenterX)]];
        NSMutableArray<NSLayoutConstraint *>* active_constraints = [NSMutableArray array];
        
        [active_constraints addObject:[self.columnView.widthAnchor constraintEqualToAnchor:self.pickerView.widthAnchor multiplier:0.8]];
        
        UIButton* cancelButton = [UIButton new];
        [cancelButton addTarget:self action:@selector(cancelColumnPick) forControlEvents:UIControlEventTouchUpInside];
//        [cancelButton setTitle:@"X" forState:UIControlStateNormal];
        NSBundle* bundle = [NSBundle bundleForClass:self.class];
        UIImage* cancelImg = [UIImage imageNamed:@"btn_cancel" inBundle:bundle compatibleWithTraitCollection:nil];
        [cancelButton setImage:cancelImg forState:UIControlStateNormal];
        [self.pickerView addSubview:cancelButton];
        
        [NSLayoutConstraint addEqualToConstraints:cancelButton superView:self.pickerView attributes:@[@(NSLayoutAttributeCenterY),@(NSLayoutAttributeLeft)]];
        
        [active_constraints addObject:[cancelButton.widthAnchor constraintEqualToAnchor:self.pickerView.widthAnchor multiplier:0.1f]];
        [active_constraints addObject:[cancelButton.widthAnchor constraintEqualToAnchor:cancelButton.heightAnchor]];
        
        UIButton* okButton = [UIButton new];
        [okButton addTarget:self action:@selector(okColumnPick) forControlEvents:UIControlEventTouchUpInside];
//        [okButton setTitle:@"OK" forState:UIControlStateNormal];
        
        
        [okButton setImage:[UIImage imageNamed:@"btn_confirm" inBundle:bundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [self.pickerView addSubview:okButton];
        
        [NSLayoutConstraint addEqualToConstraints:okButton superView:self.pickerView attributes:@[@(NSLayoutAttributeCenterY),@(NSLayoutAttributeRight)]];
        
        
        [active_constraints addObject:[okButton.widthAnchor constraintEqualToAnchor:self.pickerView.widthAnchor multiplier:0.1]];
        
        [active_constraints addObject:[okButton.widthAnchor constraintEqualToAnchor:okButton.heightAnchor]];
        
        [NSLayoutConstraint activateConstraints:active_constraints];
    }
    self.pickerView.hidden = YES;
    
    if (self.plainField == nil)
    {
        self.plainField = [UITextField new];
        self.plainField.delegate = self;
        [self addSubview:self.plainField];
        [NSLayoutConstraint addEqualToConstraints:self.plainField superView:self attributes:@[@(NSLayoutAttributeTop),@(NSLayoutAttributeRight),@(NSLayoutAttributeBottom),@(NSLayoutAttributeLeft)]];
    }
}

-(void)setDatasource:(id<UIPickerViewDataSource>)datasource
{
    _datasource = datasource;
    if (_datasource)
    {
        [self commonInit];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.plainField.hidden = YES;
    self.pickerView.hidden = NO;
    return NO;
}

-(void)cancelColumnPick
{
    self.plainField.hidden = NO;
    self.pickerView.hidden = YES;
}

-(void)okColumnPick
{
    [self.delegate pickerViewDidSelectColumn:self];
    [self cancelColumnPick];
}
@end
