//
//  nNotification.m
//
//  Created by Richard Jung on 2011-10-18.
//  Copyright (c) 2011 Richard Jung. All rights reserved.
//

#import "nNotification.h"

@implementation nNotification

// Properties
@synthesize message = _message;
@synthesize width = _width;
@synthesize height = _height;
@synthesize delay = _delay;
@synthesize showingTime = _showingTime;
@synthesize modal = _modal;

// Extended
@synthesize extended = _extended;

#pragma mark - Wrapper
+ (void)showMessage:(NSString *)message {
    
    [nNotification showMessage:message width:0 height:0];
}

+ (void)showMessage:(NSString *)message width:(float)width height:(float)height {
    
    nNotification *notification = [nNotification notifcationWithMessage:message];
    notification.width = width;
    notification.height = height;
    
    [notification show]; 
}

#pragma mark - Accessors
+ (id)notifcationWithMessage:(NSString *)message {
    
    return [[nNotification alloc] initWithMessage:message autoreleaseFlag:YES];
}

#pragma mark - Contructors
- (id)initWithMessage:(NSString *)message {
    
    if ((self = [self init])) {
        
        self.message = message;
        
        // Extended
        nNotificationExtended extended;
        extended.modalBackgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
        extended.dialogBackgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        
        self.extended = extended;
    }
    
    return self;    
}

- (id)initWithMessage:(NSString *)message autoreleaseFlag:(BOOL)flag {
    
    if ((self = [self initWithMessage:message])) {
        
        createdViaAutorelease = flag;
    }
        
    return self;
}

#pragma mark - Memory management
- (id)init {
    
    if ((self = [super init])) {
        
        _showingTime = 2.5;
        createdViaAutorelease = NO;
    }
    
    return self;
}

- (void)dealloc {
    
    [self destroyHUD];
    [scheduledTimerHide release];
    [scheduledTimerShow release];
    [super dealloc];
}

#pragma mark - Actions
- (void)show {
    
    // Ensure that the view operations are executing on the main run loop
    if (![[NSRunLoop currentRunLoop] isEqual:[NSRunLoop mainRunLoop]]) {
        
        SEL theSelector = @selector(show);
        NSInvocation *anInvocation = [NSInvocation
                                      invocationWithMethodSignature:
                                      [nNotification instanceMethodSignatureForSelector:theSelector]];
        
        [anInvocation setSelector:theSelector];
        [anInvocation setTarget:self];
        [anInvocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:NO];
        
        return;
    }
    
    if (_delay > 0) {
        
        if (_message == nil) {
            
            _message = @"";
        }
        
        scheduledTimerShow = [[NSTimer timerWithTimeInterval:_delay target:self selector:@selector(showTrigger:) userInfo:nil repeats:NO] retain];
        [[NSRunLoop currentRunLoop] addTimer:scheduledTimerShow forMode:NSDefaultRunLoopMode];
        return;
    }
    
    [self showTrigger:nil];
}

- (void)hide {
    

}

#pragma mark - UI
- (void)destroyHUD {
    
    if (textLabel == nil) {
        
        return;
    }
    
    [textLabel removeFromSuperview];
    [messageView removeFromSuperview];
    [backgroundHUDView removeFromSuperview];
    
    [textLabel release];
    [messageView release];
    [backgroundHUDView release];
    
    textLabel = nil;
    messageView = nil;
    backgroundHUDView = nil;    
    
    if (createdViaAutorelease == YES) {
        
        [self release];
        return;
    }
}

- (void)buildHUD {
    
    if (backgroundHUDView == nil) {
        
        UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        
        if (_modal) {
        
            backgroundHUDView = [[UIView alloc] initWithFrame:[window bounds]];
            backgroundHUDView.backgroundColor = self.extended.modalBackgroundColor;
            
        }
        
        float loadingViewWidth;
        float loadingViewHeight;
        
        if (self.width == 0) {
            
            loadingViewWidth  = window.frame.size.width * 0.50;            
            
        } else {
            
            loadingViewWidth  = self.width; 
        }
        if (self.height == 0) {
            
            loadingViewHeight = 120;
            
        } else {
            
            loadingViewHeight = self.height;            
        }

        
        messageView = [[UIView alloc] initWithFrame:CGRectMake((window.frame.size.width / 2) - (loadingViewWidth / 2), 
                                                               (window.frame.size.height / 2) - (loadingViewHeight / 2),
                                                               loadingViewWidth, 
                                                               loadingViewHeight)];
        messageView.backgroundColor = self.extended.dialogBackgroundColor;
        messageView.layer.cornerRadius = 12.0;

        
        
        textLabel = [[UILabel alloc] initWithFrame:messageView.bounds];
        
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = UITextAlignmentCenter;
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.font = [UIFont systemFontOfSize:13];
        textLabel.text = self.message;
        
        [messageView addSubview:textLabel];

        
        if (_modal) {
            
            [backgroundHUDView addSubview:messageView];   
            
        } else {
            
            messageView.backgroundColor = [self.extended.dialogBackgroundColor colorWithAlphaComponent:0.8];
        }
        
        float actualFontSize;
        
        CGSize oneLineSize = [textLabel.text sizeWithFont:textLabel.font minFontSize:textLabel.minimumFontSize actualFontSize:&actualFontSize forWidth:textLabel.frame.size.width lineBreakMode:UILineBreakModeWordWrap];
        
        CGSize size = [textLabel.text sizeWithFont:textLabel.font constrainedToSize:CGSizeMake(textLabel.frame.size.width, (textLabel.text.length * 21)) lineBreakMode:UILineBreakModeWordWrap];
        
        CGRect frame = textLabel.frame;
        frame.size.height = size.height;
        frame.origin.y = (messageView.frame.size.height / 2) - (frame.size.height / 2);
        textLabel.frame = frame;
        
        int lines = (int)((size.height / oneLineSize.height) + 0.5);
        textLabel.numberOfLines = lines;
    }
}

- (void)showHUD {
    
    [self buildHUD];

    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];    
    
    UIView *animatingView;
    if (_modal) {

        animatingView = backgroundHUDView;
        
    } else {
        
        animatingView = messageView;
    }
    
    
    animatingView.alpha = 0.0;
    [window addSubview:animatingView];
    
    [UIView beginAnimations:@"ShowMessageView" context:NULL];
    [UIView setAnimationDuration:0.2];
    
    animatingView.alpha = 1.0;
    
    [UIView commitAnimations];

    
    scheduledTimerHide = [[NSTimer timerWithTimeInterval:_showingTime target:self selector:@selector(hideTrigger:) userInfo:nil repeats:NO] retain];
    [[NSRunLoop currentRunLoop] addTimer:scheduledTimerHide forMode:NSDefaultRunLoopMode];
}

- (void)hideHUD {
    
    [UIView beginAnimations:@"nNotificationHide" context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(destroyHUD)];
    
    backgroundHUDView.alpha     = 0.0;
    messageView.alpha           = 0.0;
    
    messageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    
    [UIView commitAnimations];    
}

#pragma mark - Helper
- (void)showTrigger:(NSTimer *)timer {
    
    [self showHUD];
}

- (void)hideTrigger:(NSTimer *)timer {
    
    [self hideHUD];
}

@end
