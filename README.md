# nNotification
## About
nNotification is an iOS class to show a message for a specific time. It is very easy to use and a elegant way to inform the user about any information.

Inspired by Toast from Android.

## Requirements
* iOS 4.X
* UIKit
* Foundation
* **QuarzCore**

## Install
1. Drag the files (nNotification.h, nNotification.m) into your Project or add it through the "Add Files to XXX ...".
2. Add **QuartzCore** framework to your project: Click on your project, choose your target, click on "Build Phases", choose "Link Binary With Libraries" and add it via "+".
3. Import it where do you want to use it:

#import "nNotification.h"

## Usage
### Simple use

[nNotification showMessage:@"Your message!"];

### Extended use

nNotificaiton *notification = [nNotification notificationWithMessage:@"Your Message"];
notification.width = 200;
notification.height = 200;
notification.modal = YES;
notification.delay = 3;
notification.showingTime = 5;
[notification show];

// And you can customize UI
nNotification *notification = [nNotification notificationWithMessage:@"Your Message"];

nNotificationExtended extended = notification.extended;
extended.modalBackgroundColor = [UIColor yellowColor];
extended.dialogBackgroundColor = [UIColor redColor];
notification.extended = extended;

[notification show];

## Dokumentation
### Options
**message**: Defines the shown message.
`notification.message = @"Your Message!";`

**showingTime**: Defines how long (time -> seconds) the dialog will be shown. Default is 2.5 seconds.
`notification.showingTime = 4.0;`

**width**: Defines the width of the shown message dialog.
`notification.width = 200;`

**height**: Defines the height of the shown message dialog.
`notification.height = 200;`

**delay**: Defines after which delay (time -> seconds) the dialog appears. So you can hold back the dialog a specific time.
`notification.delay = 4;`

**modal**: Defines whether the user is allowed to interact with the UI or not. Additionally the whole window will be dimmed.
`notification.modal = YES;`

**extended**: Is a struct object, which allows to customize the ui of the dialog.
`nNotificationExtended extended = notification.extended;` 

### Extended
**modalBackgroundColor**: [JUST FOR MODAL] Defines the dimming color.
`extended.modalBackgroundColor = [UIColor redColor];`

**dialogBackgroundColor**: Defines the background color of the dialog layer.
`extended.dialogBackgroundColor = [UIColor yellowColor];`

## Copyright
(2011) Copyright by Richard Jung. All rights reserved.

## License
This software / classes are released under the LGPL conditions. Feel free to use it for commercial purposes.

