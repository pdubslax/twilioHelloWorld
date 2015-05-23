//
//  LoginViewController.m
//  Stumped
//
//  Created by Alex Ottenwess on 5/11/15.
//  Copyright (c) 2015 Patrick Wilson. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import "UIColor+colorFromHexString.h"

@interface LoginViewController ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *facebookLogin;
@property (nonatomic, strong) UIButton *stumpedLogin;
@property (nonatomic, strong) UIButton *signUpButton;
@property (nonatomic, strong) UILabel *stumpedLabel;
@property (nonatomic, strong) UIImageView *stumpedLogo;
@property (nonatomic, strong) NSLayoutConstraint *facebookLogoYValConstraint;
@property (nonatomic, strong) NSLayoutConstraint *stumpedLogoYValConstraint;
@property (nonatomic, strong) NSLayoutConstraint *stumpedLabelYValConstraint;
@property (nonatomic, strong) UITextField *textField1;
@property (nonatomic, strong) UITextField *textField2;
@property (nonatomic, strong) UITextField *textField3;
@property (nonatomic, strong) NSLayoutConstraint *textField1XValConstraint;
@property (nonatomic, strong) NSLayoutConstraint *textField2XValConstraint;
@property (nonatomic, strong) NSLayoutConstraint *textField3XValConstraint;
@property (nonatomic, strong) NSLayoutConstraint *stumpedLoginXValConstraint;
@property (nonatomic, strong) NSLayoutConstraint *stumpedLoginYValConstraint;
@property (nonatomic, strong) NSLayoutConstraint *textField1YValConstraint;
@property (nonatomic, strong) NSLayoutConstraint *textField2YValConstraint;
@property (nonatomic, strong) NSLayoutConstraint *textField3YValConstraint;
@property (nonatomic) BOOL facebook;
@property (nonatomic) BOOL fieldsUP;




@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view setBackgroundColor:[UIColor colorFromHexString:@"3498db"]];
    self.facebook = YES;
    self.fieldsUP = NO;
    [self loadSubviews];
    [self autoLayoutSubviews];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    //This is how you tell if someone is authenticated
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {

    } else {
        // show the signup or login screen
    }
}

- (void)dismissKeyboard{
    [self.view endEditing:YES];
    if (self.fieldsUP){
        CGFloat logoConstant = 0;
        CGFloat labelConstant = 0;
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        int screenWidth = (int)screenRect.size.width;
        int screenHeight = (int)screenRect.size.height;
        if (screenHeight==480){
            //iPhone 4 family
            logoConstant = 100;
            labelConstant = 100;
        }else if (screenHeight==568){
            //iPhone 5 family
            logoConstant = 200;
            labelConstant = 80;
        }
        self.fieldsUP = NO;
        [UIView animateWithDuration:.25
                         animations:^{
                             self.textField1YValConstraint.constant+=70;
                             self.textField2YValConstraint.constant+=70;
                             self.textField3YValConstraint.constant+=70;
                             self.stumpedLabelYValConstraint.constant+=labelConstant;
                             self.stumpedLogoYValConstraint.constant+=logoConstant;
                             [self.contentView layoutIfNeeded]; // Called on parent view
                         } completion:^(BOOL finished) {
                             //
                             
                         }];
    }
    
}

- (void)loadSubviews {
    
    
    //call for data here
    
    
    [self loadContentView];
    [self loadUIElements];
    
}

- (void)loadContentView {
    CGRect frame = self.view.bounds;
    self.contentView = [[UIView alloc] initWithFrame:frame];
    [self.view addSubview:self.contentView];
}

- (void)loadUIElements{
    self.facebookLogin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.facebookLogin addTarget:self
               action:@selector(facebookLoginMethod)
     forControlEvents:UIControlEventTouchUpInside];
    [self.facebookLogin setTitle:@"" forState:UIControlStateNormal];
    [self.facebookLogin setBackgroundImage:[UIImage imageNamed:@"facebook_login.png"] forState:UIControlStateNormal];
    [self.facebookLogin setBackgroundImage:[UIImage imageNamed:@"facebook_login_pressed.png"] forState:UIControlEventTouchDown | UIControlEventTouchUpInside | UIControlStateHighlighted |UIControlStateSelected];
    self.facebookLogin.frame = CGRectMake(self.view.frame.size.width/2 - 580/4, self.view.frame.size.height-150, 580/2, 124/2);
    [self.contentView addSubview:self.facebookLogin];
    
    self.stumpedLogin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.stumpedLogin addTarget:self
                           action:@selector(stumpedLoginMethod)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.stumpedLogin setTitle:@"" forState:UIControlStateNormal];
    [self.stumpedLogin setBackgroundImage:[UIImage imageNamed:@"stumped_login.png"] forState:UIControlStateNormal];
    [self.stumpedLogin setBackgroundImage:[UIImage imageNamed:@"stumped_login_pressed.png"] forState:UIControlStateDisabled];
    self.stumpedLogin.frame = CGRectMake(self.view.frame.size.width/2 - 580/4, self.view.frame.size.height-150, 580/2, 124/2);
    [self.contentView addSubview:self.stumpedLogin];
    
    self.signUpButton= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.signUpButton addTarget:self
                           action:@selector(otherLogin)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.signUpButton setTitle:@"No Facebook?" forState:UIControlStateNormal];
    [self.signUpButton setTintColor:[UIColor blackColor]];
    [self.contentView addSubview:self.signUpButton];
    
    self.stumpedLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"twilio_logo.png"]];
    [self.stumpedLogo setFrame:CGRectMake((self.view.frame.size.width - 112)/2, 100, 112,112)];
    [self.stumpedLogo setContentMode:UIViewContentModeScaleAspectFit];
    [self.contentView addSubview:self.stumpedLogo];
    
    self.stumpedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 100)];
    [self.stumpedLabel setText:@"Twilio Globetrotter"];
    [self.stumpedLabel setTextAlignment:NSTextAlignmentCenter];
    [self.stumpedLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:60]];
    [self.stumpedLabel setTextColor:[UIColor whiteColor]];
    [self.stumpedLabel setNumberOfLines:0];
    [self.contentView addSubview:self.stumpedLabel];
    
    self.textField1 = [[UITextField alloc] init];
    self.textField1.borderStyle = UITextBorderStyleRoundedRect;
    self.textField1.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:30];
    self.textField1.placeholder = @"Email";
    self.textField1.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField1.keyboardType = UIKeyboardTypeEmailAddress;
    self.textField1.returnKeyType = UIReturnKeyNext;
    self.textField1.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textField1.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textField1.delegate = self;
    [self.contentView addSubview:self.textField1];
    
    self.textField2 = [[UITextField alloc] init];
    self.textField2.borderStyle = UITextBorderStyleRoundedRect;
    self.textField2.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:30];
    self.textField2.placeholder = @"Username";
    self.textField2.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField2.keyboardType = UIKeyboardTypeDefault;
    self.textField2.returnKeyType = UIReturnKeyNext;
    self.textField2.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textField2.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textField2.delegate = self;
    [self.contentView addSubview:self.textField2];
    
    self.textField3 = [[UITextField alloc] init];
    self.textField3.borderStyle = UITextBorderStyleRoundedRect;
    self.textField3.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:30];
    self.textField3.placeholder = @"Password";
    self.textField3.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField3.keyboardType = UIKeyboardTypeDefault;
    self.textField3.returnKeyType = UIReturnKeyDone;
    self.textField3.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField3.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textField3.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textField3.delegate = self;
    [self.contentView addSubview:self.textField3];
}

-(void)facebookLoginMethod{
    NSArray *permissionsArray = @[ @"public_profile", @"email", @"user_friends"];
    [self.facebookLogin setHidden:YES];
    [self.stumpedLogin setHidden:YES];
    [self.stumpedLabel setHidden:YES];
    [self.signUpButton setHidden:YES];
    // Login PFUser using Facebook
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            if ([FBSDKAccessToken currentAccessToken]) {
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     if (!error) {
                         NSLog(@"fetched user:%@", result);
                         user[@"displayName"]=result[@"name"];
                         user[@"userID"]=result[@"id"];
                         [user saveInBackground];
                         [self dismissViewControllerAnimated:NO completion:^{
                             
                         }];
                     }
                 }];
            }
            
        } else {
            NSLog(@"User logged in through Facebook!");
            
            if ([FBSDKAccessToken currentAccessToken]) {
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     if (!error) {
                         NSLog(@"fetched user:%@", result);
                         user[@"displayName"]=result[@"name"];
                         user[@"userID"]=result[@"id"];
                         [user saveInBackground];
                         [self dismissViewControllerAnimated:NO completion:^{
                             
                         }];
                     }
                 }];
            }
            
        }
    }];
}
-(void)stumpedLoginMethod{
    PFUser *user = [PFUser user];
    user.username = self.textField2.text;
    user.password = self.textField3.text;
    user.email = self.textField1.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {   // Hooray! Let them use the app now.
            [PFUser logInWithUsernameInBackground:self.textField2.text password:self.textField3.text
                                            block:^(PFUser *user, NSError *error) {
                                                if (user) {
                                                    // Do stuff after successful login.
                                                    [self dismissViewControllerAnimated:NO completion:^{
                                                        //
                                                    }];
                                                    
                                                } else {
                                                    // The login failed. Check error to see why.
                                                }
                                            }];
            
        } else {   NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
            [PFUser logInWithUsernameInBackground:self.textField2.text password:self.textField3.text
                                            block:^(PFUser *user, NSError *error) {
                                                if (user) {
                                                    // Do stuff after successful login.
                                                    [self dismissViewControllerAnimated:NO completion:^{
                                                        //
                                                    }];
                                                    
                                                } else {
                                                    // The login failed. Check error to see why.
                                                }
                                            }];
        }
    }];
}
-(void)otherLogin{
    CGFloat logoConstant = 90;
    CGFloat labelConstant = 90;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int screenWidth = (int)screenRect.size.width;
    int screenHeight = (int)screenRect.size.height;
    if (screenHeight==480){
        //iPhone 4 family
         logoConstant = 170;
         labelConstant = 130;
    }else if (screenHeight==568){
        //iPhone 5 family
        logoConstant = 45;
        labelConstant = 68;
    }
    if (self.facebook){
        [self.stumpedLogin setEnabled:NO];
        [UIView animateWithDuration:1.0
                         animations:^{
                             self.facebookLogoYValConstraint.constant+=300;
                             self.stumpedLabelYValConstraint.constant-=labelConstant;
                             self.stumpedLogoYValConstraint.constant-=logoConstant;
                             [self.contentView layoutIfNeeded]; // Called on parent view
                         } completion:^(BOOL finished) {
                             //
                         }];
        [UIView animateWithDuration:1.2
                         animations:^{
                             self.textField1XValConstraint.constant+=400;
                             [self.contentView layoutIfNeeded]; // Called on parent view
                         } completion:^(BOOL finished) {
                             //
                         }];
        [UIView animateWithDuration:1.4
                         animations:^{
                             self.textField2XValConstraint.constant+=400;
                             [self.contentView layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             //
                         }];
        [UIView animateWithDuration:1.6
                         animations:^{
                             self.textField3XValConstraint.constant+=400;
                             [self.contentView layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             //
                         }];
        [UIView animateWithDuration:1.8
                         animations:^{
                             self.stumpedLoginXValConstraint.constant+=400;
                             [self.contentView layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             //
                         }];
        [self.facebookLogin setEnabled:NO];
        [self.signUpButton setTitle:@"Login with Facebook" forState:UIControlStateNormal];
        self.facebook = NO;
    }
    else{
        [UIView animateWithDuration:1.0
                         animations:^{
                             self.facebookLogoYValConstraint.constant-=300;
                             self.stumpedLabelYValConstraint.constant+=labelConstant;
                             self.stumpedLogoYValConstraint.constant+=logoConstant;
                             [self.contentView layoutIfNeeded]; // Called on parent view
                         } completion:^(BOOL finished) {
                             //
                         }];
        [UIView animateWithDuration:.5
                         animations:^{
                             self.textField1XValConstraint.constant-=400;
                             [self.contentView layoutIfNeeded]; // Called on parent view
                         } completion:^(BOOL finished) {
                             //
                         }];
        [UIView animateWithDuration:.7
                         animations:^{
                             self.textField2XValConstraint.constant-=400;
                             [self.signUpButton setAlpha:1.0f];
                             [self.contentView layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             //
                         }];
        [UIView animateWithDuration:.9
                         animations:^{
                             self.textField3XValConstraint.constant-=400;
                             [self.contentView layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             //
                         }];
        [UIView animateWithDuration:1.1
                         animations:^{
                             self.stumpedLoginXValConstraint.constant-=400;
                             [self.contentView layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             //
                         }];
        self.facebook = YES;
        [self.facebookLogin setEnabled:YES];
        [self.signUpButton setTitle:@"No Facebook?" forState:UIControlStateNormal];
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)autoLayoutSubviews {
    for (UIView *view in self.contentView.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    // Label all views for autolayout
    NSDictionary *views = @{
                            @"facebookLogin"           :   self.facebookLogin,
                            @"stumpedLabel"            :   self.stumpedLabel,
                            @"stumpedLogo"             :   self.stumpedLogo,
                            @"signUpButton"            :   self.signUpButton,
                            @"textField1"         :   self.textField1,
                            @"textField2"         :   self.textField2,
                            @"textField3"         :   self.textField3,
                            @"stumpedLogin"        :  self.stumpedLogin
                            };
    NSString *centerFBookString = [NSString stringWithFormat:@"H:|-%f-[facebookLogin(==290)]-%f-|",(self.view.frame.size.width-290)/2,(self.view.frame.size.width-290)/2];
    NSString *centerLogoString = [NSString stringWithFormat:@"H:|-%f-[stumpedLogo(==112)]-%f-|",(self.view.frame.size.width-112)/2,(self.view.frame.size.width-112)/2];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:centerFBookString options:0 metrics:nil views:views]];
    self.facebookLogoYValConstraint = [NSLayoutConstraint constraintWithItem:self.facebookLogin attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-150];
    [self.contentView addConstraint:self.facebookLogoYValConstraint];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.facebookLogin attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:62]];
    //[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:-[facebookLogin(==62)]-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[stumpedLabel]-|" options:0 metrics:nil views:views]];
   
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:centerLogoString options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[signUpButton]-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[signUpButton]-20-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textField1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textField1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:300]];
    self.textField1XValConstraint = [NSLayoutConstraint constraintWithItem:self.textField1 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:-400];
    [self.contentView addConstraint:self.textField1XValConstraint];
    self.textField1YValConstraint = [NSLayoutConstraint constraintWithItem:self.textField1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-320];
    [self.contentView addConstraint:self.textField1YValConstraint];
    
    
    
   
    
    self.stumpedLogoYValConstraint = [NSLayoutConstraint constraintWithItem:self.stumpedLogo attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-167];
    [self.contentView addConstraint:self.stumpedLogoYValConstraint];
    
    self.stumpedLabelYValConstraint = [NSLayoutConstraint constraintWithItem:self.stumpedLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-30];
    [self.contentView addConstraint:self.stumpedLabelYValConstraint];
    
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textField2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textField2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:300]];
    self.textField2XValConstraint = [NSLayoutConstraint constraintWithItem:self.textField2 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:-400];
    [self.contentView addConstraint:self.textField2XValConstraint];
    self.textField2YValConstraint = [NSLayoutConstraint constraintWithItem:self.textField2 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-250];
    [self.contentView addConstraint:self.textField2YValConstraint];
    

    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textField3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textField3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:300]];
    self.textField3XValConstraint = [NSLayoutConstraint constraintWithItem:self.textField3 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:-400];
    [self.contentView addConstraint:self.textField3XValConstraint];
    self.textField3YValConstraint = [NSLayoutConstraint constraintWithItem:self.textField3 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-180];
    [self.contentView addConstraint:self.textField3YValConstraint];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.stumpedLogin attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:62]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.stumpedLogin attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:290]];
    self.stumpedLoginXValConstraint = [NSLayoutConstraint constraintWithItem:self.stumpedLogin attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:-400];
    [self.contentView addConstraint:self.stumpedLoginXValConstraint];
    self.stumpedLoginYValConstraint = [NSLayoutConstraint constraintWithItem:self.stumpedLogin attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-100];
    [self.contentView addConstraint:self.stumpedLoginYValConstraint];
    
    
    
    
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGFloat logoConstant = 0;
    CGFloat labelConstant = 0;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int screenWidth = (int)screenRect.size.width;
    int screenHeight = (int)screenRect.size.height;
    if (screenHeight==480){
        //iPhone 4 family
        logoConstant = 100;
        labelConstant = 100;
    }else if (screenHeight==568){
        //iPhone 5 family
        logoConstant = 200;
        labelConstant = 80;
    }
    if (!self.fieldsUP){
        self.fieldsUP = YES;
    [UIView animateWithDuration:.25
                     animations:^{
                         self.textField1YValConstraint.constant-=70;
                         self.textField2YValConstraint.constant-=70;
                         self.textField3YValConstraint.constant-=70;
                         self.stumpedLabelYValConstraint.constant-=labelConstant;
                         self.stumpedLogoYValConstraint.constant-=logoConstant;
                         [self.contentView layoutIfNeeded]; // Called on parent view
                     } completion:^(BOOL finished) {
                         //
                         
                     }];
    }
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.textField1) {
        [self.textField2 becomeFirstResponder];
    } else if (theTextField == self.textField2) {
        [self.textField3 becomeFirstResponder];
    }else if (theTextField==self.textField3){
        [self.textField3 resignFirstResponder];
        if (self.fieldsUP){
            CGFloat logoConstant = 0;
            CGFloat labelConstant = 0;
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            int screenWidth = (int)screenRect.size.width;
            int screenHeight = (int)screenRect.size.height;
            if (screenHeight==480){
                //iPhone 4 family
                logoConstant = 100;
                labelConstant = 100;
            }else if (screenHeight==568){
                //iPhone 5 family
                logoConstant = 200;
                labelConstant = 80;
            }
            self.fieldsUP = NO;
            [UIView animateWithDuration:.25
                             animations:^{
                                 self.textField1YValConstraint.constant+=70;
                                 self.textField2YValConstraint.constant+=70;
                                 self.textField3YValConstraint.constant+=70;
                                 self.stumpedLabelYValConstraint.constant+=labelConstant;
                                 self.stumpedLogoYValConstraint.constant+=logoConstant;
                                 [self.contentView layoutIfNeeded]; // Called on parent view
                             } completion:^(BOOL finished) {
                                 //
                                 
                             }];
        }
    }
    if ([self.textField2.text length]==0||[self.textField3.text length]==0) {
        [self.stumpedLogin setEnabled:NO];
    }else{
        [self.stumpedLogin setEnabled:YES];
    }
    
    return YES;
}

@end
