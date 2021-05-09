//
//  SKDatePickerSelectionView.m
//  skdatepicker
//
//  Created by xiw on 2021/5/3.
//

#import "SKDatePickerSelectionView.h"
#import "SKDatePickerDayView.h"
#import "SKDatePickerView.h"
#import "SKDatePickerViewDelegate.h"

@interface SKDatePickerSelectionView()
{
    CGFloat padding;
}
@property (nonatomic, weak) SKDatePickerDayView* dayView;
@property (nonatomic, assign) BOOL isSemiSelected;

@end

@implementation SKDatePickerSelectionView
-(instancetype)initWithDayView:(SKDatePickerDayView*)dayView frame: (CGRect)frame isSemiSelected:(BOOL)isSemiSelected
{
    self = [super initWithFrame:frame];
    
    self.dayView = dayView;
    self.isSemiSelected = isSemiSelected;
    if([self.dayView.datePickerView shouldContinueSelection])
    {
        padding = 1;
    }else
        padding = 10;
    self.backgroundColor = [UIColor clearColor];
    [self shapeLayer].fillColor = [self fillColor].CGColor;
    return self;
}

+(Class)layerClass
{
    return CAShapeLayer.self;
}

-(CAShapeLayer*)shapeLayer
{
    return (CAShapeLayer*)self.layer;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    SelectionShape shape = SelectionShapeSquare;
    if ([self.dayView.delegate respondsToSelector:@selector(selectionShape)])
    {
        shape = [self.dayView.delegate selectionShape];
    }
    UIBezierPath* path = nil;
    CGFloat pathSize = [self radius] * 2;
    CGFloat cornerRadiusForShape = [self radius] / 2;
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    CGPoint startPoint = CGPointMake(center.x - [self radius], center.y - [self radius]);
    
    switch (shape) {
        case SelectionShapeRoundedRect:
        {
            path = [UIBezierPath bezierPathWithRect:CGRectMake(startPoint.x, startPoint.y, pathSize, pathSize)];
        }
            break;
        case SelectionShapeSquare:
        {
            path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(startPoint.x, startPoint.y, pathSize, pathSize) cornerRadius: cornerRadiusForShape];
        }
            break;
        default:
            path = [UIBezierPath bezierPathWithArcCenter:center radius:[self radius] startAngle:0 endAngle:M_PI * 2.0f clockwise:true];
            break;
    }
    [self shapeLayer].path = path.CGPath;
}


-(CGFloat)radius
{
    return (MIN(self.frame.size.height, self.frame.size.width) - padding) / 2;
}

-(UIColor*)fillColor
{
    if (self.isSemiSelected)
    {
        if ([self.dayView.delegate respondsToSelector:@selector(colorForSemiSelectedSelectionCircle)])
        {
            return [self.dayView.delegate colorForSemiSelectedSelectionCircle];
        }
    }
    else
    {
        if ([self.dayView.delegate respondsToSelector:@selector(colorForSelectionBackground)])
        {
            return [self.dayView.delegate colorForSelectionBackground];
        }
    }
    return [UIColor lightGrayColor];
}
@end
