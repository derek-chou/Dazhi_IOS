//
//  CellPhoneViewController.h
//  Hello
//
//  Created by Derek Chou on 2016/1/6.
//  Copyright © 2016年 Derek Chou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDownPicker.h"

@interface CellPhoneViewController : UIViewController<UITextFieldDelegate>

@property IBOutlet UITextField *countryCodesField;
@property IBOutlet UITextField *cellPhoneField;
@property (strong, nonatomic) DownPicker *codesPicker;

@end
