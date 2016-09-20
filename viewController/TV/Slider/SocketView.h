//
//  SocketView.h
//  StarAPP
//
//  Created by xyz on 16/9/19.
//
//

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"
#import "SocketModel.h"


extern NSString * const TYPE_UINT8;
extern NSString * const TYPE_UINT16;
extern NSString * const TYPE_UINT32;
extern NSString * const TYPE_UINT64;
extern NSString * const TYPE_STRING;
extern NSString * const TYPE_ARRAY;

@interface SocketView : UIViewController
@property (nonatomic, strong) NSMutableData *data;
@property(nonatomic,assign )BOOL connectBool;
@property (nonatomic, strong)  AsyncSocket *socket;

@property(nonatomic,strong)Cs_20001* cs_one;

-(void)socketConnectHost;// socket连接
-(void)heartBeat;
@end
