//
//  ViewController.m
//  fabookLogin
//
//  Created by Tim on 2016/8/23.
//  Copyright © 2016年 Tim. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface ViewController ()<FBSDKLoginButtonDelegate>
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *fbLoginBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
//    loginButton.center = self.view.center;
//    loginButton.readPermissions =
//    @[@"public_profile", @"email", @"user_friends"];
//    [self.view addSubview:loginButton];
    
    //跟user要求這些資訊
    _fbLoginBtn.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    
    _fbLoginBtn.delegate = self;
}

- (void)loginButton:	(FBSDKLoginButton *)loginButton
didCompleteWithResult:	(FBSDKLoginManagerLoginResult *)result
              error:	(NSError *)error
{
    if (result.isCancelled==YES) {
        //user 取消登入
        NSLog(@"User login canceled.");
    }else{
        
        //登入成功
        NSLog(@"grantedPermissions=%@",result.grantedPermissions);
        
        //FBSDKAccessToken * token = result.token;
        //NSLog(@"userID=%@",token.userID);
        //NSLog(@"tokenString=%@",token.tokenString);
        
        if ([result.grantedPermissions containsObject:@"email"]) {
            //如果登入成功且有取得token
            if ([FBSDKAccessToken currentAccessToken]) {
                
                //帶入想要取得的資訊
                NSDictionary * param = @{@"fields" : @"email,id,name,picture.width(100).height(100)"};
                
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:param] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                    
                    //如果登入error 為nil且有取得result時
                    if (!error && result!=nil) {
                        
                        //判斷登入結果如果是個dictionary 的class
                        if([result isKindOfClass:[NSDictionary class]])
                        {
                            //NSLog(@"email=%@",result[@"email"]);
                            _emailLabel.text = result[@"email"];
                            
                            //NSLog(@"name=%@",result[@"name"]);
                            _nameLabel.text = result[@"name"];
                            
                            NSString * imageStringOfLoginUser = [[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
                            
                            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageStringOfLoginUser]];
                            _userImage.image = [UIImage imageWithData:imageData];
                        }
                    }
                }];
            }
        } else {
            //user 不同意
            NSLog(@"Not granted");
        }
    }
    
    //登入失敗
    if(error != nil)
        NSLog(@"error=%@",error);
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
