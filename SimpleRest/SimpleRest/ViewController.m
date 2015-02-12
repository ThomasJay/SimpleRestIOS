//
//  ViewController.m
//  SimpleRest
//
//  Created by Tom Jay on 2/10/15.
//  Copyright (c) 2015 Tom Jay. All rights reserved.
//

#import "ViewController.h"
#import "CommunicationsManager.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation ViewController

- (IBAction)getDataButtonPressed:(id)sender {
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = @"12344";
    

    [[CommunicationsManager sharedCommunicationsManager] getUserDataForParams:params callback:^(NSError *error, NSDictionary *values) {
        
        if (!error) {
            
            NSLog(@"ViewController::getDataButtonPressed getUserDataForParams callback Success");
            
            self.nameLabel.text = values[@"name"];
            self.descriptionLabel.text = values[@"description"];
            
            
        }
        else {
            NSLog(@"ViewController::getDataButtonPressed getUserDataForParams callback error");
            
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:[NSString stringWithFormat:@"Server Error code=%d msg=%@", error.code, [error.userInfo valueForKey:NSLocalizedDescriptionKey]]
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            
            [message show];

        }
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
