/*
 * Copyright (C) 2015 Concur Technologies
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <CoreText/CoreText.h>

#import "CXDurationModeSwitch.h"

@interface CXDurationModeSwitch ()
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) NSMutableArray *customConstraints;
@end

@implementation CXDurationModeSwitch

- (void)awakeFromNib {
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    self.mode = CXDurationPickerModeStartDate;
    
    self.customConstraints = [[NSMutableArray alloc] init];
    
    UIView *view = nil;
    
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"CXDurationModeSwitch"
                                                     owner:self
                                                   options:nil];
    
    for (id object in objects) {
        if ([object isKindOfClass:[UIView class]]) {
            view = object;
            break;
        }
    }
    
    if (view != nil) {
        self.containerView = view;
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
        [self setNeedsUpdateConstraints];
    }
}

- (void)updateConstraints {
    [self removeConstraints:self.customConstraints];
    
    [self.customConstraints removeAllObjects];
    
    if (self.containerView != nil) {
        UIView *view = self.containerView;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(view);
        
        [self.customConstraints addObjectsFromArray:
         [NSLayoutConstraint constraintsWithVisualFormat:
          @"H:|[view]|" options:0 metrics:nil views:views]];
        
        [self.customConstraints addObjectsFromArray:
         [NSLayoutConstraint constraintsWithVisualFormat:
          @"V:|[view]|" options:0 metrics:nil views:views]];
        
        [self addConstraints:self.customConstraints];
    }
    
    [super updateConstraints];
}

#pragma mark - View API

- (void)setStartDateString:(NSString *)startDateString {
    self.startDateLabel.text = startDateString;
}

- (void)setEndDateString:(NSString *)endDateString {
    self.endDateLabel.text = endDateString;
}

#pragma mark - Gesture Recognizers

- (IBAction)didTapButton1:(id)sender {
    [self setStartMode];
}

- (IBAction)didTapButton2:(id)sender {
    [self setEndMode];
}

- (void)setMode:(CXDurationPickerMode)mode {
    switch (mode) {
        case CXDurationPickerModeEndDate:
            [self setEndMode];
            break;
        case CXDurationPickerModeStartDate:
            [self setStartMode];
            break;
        default:
            NSLog(@"Unrecognized duration picker mode: %lu", mode);
            break;
    }
}

- (void)setEndMode {
    CGPoint newCenter = CGPointMake(self.button2.center.x, self.indicator.center.y);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.indicator.center = newCenter;
    } completion:nil];
    
    _mode = CXDurationPickerModeEndDate;
    
    if (self.delegate) {
        [self.delegate modeSwitch:self modeChanged:_mode];
    }
}

- (void)setStartMode {
    CGPoint newCenter = CGPointMake(self.button1.center.x, self.indicator.center.y);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.indicator.center = newCenter;
    } completion:nil];
    
    _mode = CXDurationPickerModeStartDate;
    
    if (self.delegate) {
        [self.delegate modeSwitch:self modeChanged:_mode];
    }
}

@end
