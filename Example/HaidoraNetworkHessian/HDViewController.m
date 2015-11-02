//
//  HDViewController.m
//  HaidoraNetworkHessian
//
//  Created by mrdaios on 10/22/2015.
//  Copyright (c) 2015 mrdaios. All rights reserved.
//

#import "HDViewController.h"
#import <HaidoraNetwork.h>
#import "com_boco_bmdp_faultmanage_troubleshooting_servcie_ITroubleShootingAssistantSrv.h"

@interface HDViewController ()

@end

@implementation HDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [HDNetworkConfig sharedInstance].baseURL = @"http://211.138.211.110:8081/bmdp/hessian";

    [[com_boco_bmdp_faultmanage_troubleshooting_servcie_ITroubleShootingAssistantSrv
        initRegionCitySrvWithparamMsgHeader:nil
              paramInitRegionCitySrvRequest:nil]
        startWithCompletionBlockWithSuccess:^(id request, id responseObject) {

        }
        failure:^(id request, NSError *error){

        }];

    //    [[com_boco_bmdp_faultmanage_troubleshooting_servcie_ITroubleShootingAssistantSrv
    //        initRegionCitySrvWithparamMsgHeader:nil
    //              paramInitRegionCitySrvRequest:nil]
    //        startWithCompletionBlockWithSuccess:^(id request, id responseObject) {
    //
    //        }
    //        failure:^(id request, NSError *error){
    //
    //        }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
