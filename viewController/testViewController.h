//
//  testViewController.h
//  StarAPP
//
//  Created by xyz on 16/8/24.
//
//

#import <UIKit/UIKit.h>


@interface testViewController : UIViewController<AsyncSocketDelegate>
@property (nonatomic, strong) AsyncSocket    *socket;       // socket
@property (nonatomic, copy  ) NSString       *socketHost;   // socket的Host
@property (nonatomic, assign) UInt16         socketPort;    // socket的prot

-(void)socketConnectHost;// socket连接

@end
