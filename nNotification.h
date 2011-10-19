//
//  nNotification.h
//
//  Created by Richard Jung on 2011-10-18.
//  Copyright (c) 2011 Richard Jung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

struct nNotificationExtended {
    
    UIColor *modalBackgroundColor;
    UIColor *dialogBackgroundColor;
};

typedef struct nNotificationExtended nNotificationExtended;

@interface nNotification : NSObject {
    
    // UI
    UIView *backgroundHUDView;
    UIView *messageView;
    UILabel *textLabel;
    
    // Helpers
    NSTimer *scheduledTimerShow;
    NSTimer *scheduledTimerHide;
    BOOL currentlyAnimating;
    BOOL createdViaAutorelease;
}

// Properties
@property (nonatomic, readwrite, retain) NSString *message;
@property (readwrite, assign) float width;
@property (readwrite, assign) float height;
@property (readwrite, assign) float delay;
@property (readwrite, assign) float showingTime;
@property (readwrite, assign) BOOL modal;

// Extended
@property (readwrite, assign) nNotificationExtended extended;

#pragma mark - Wrapper
+ (void)showMessage:(NSString *)message;
+ (void)showMessage:(NSString *)message width:(float)width height:(float)height;

#pragma mark - Accessors
+ (id)notifcationWithMessage:(NSString *)message;

#pragma mark - Contructors
- (id)initWithMessage:(NSString *)message;
- (id)initWithMessage:(NSString *)message autoreleaseFlag:(BOOL)flag;

#pragma mark - Actions
- (void)show;
- (void)hide;

#pragma mark - UI
- (void)destroyHUD;
- (void)buildHUD;
- (void)showHUD;
- (void)hideHUD;

#pragma mark - Helper
- (void)showTrigger:(NSTimer *)timer;
- (void)hideTrigger:(NSTimer *)timer;
- (void)didHideHUD;
- (void)kill;

@end
