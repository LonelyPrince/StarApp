
/*
  YLSlideTitleView 栏目标题
 */

#import <UIKit/UIKit.h>
static float const YLSildeTitleViewHeight = 48;

typedef void (^YLSlideTitleViewScrollBlock)(CGFloat offset_x);
typedef void (^YLSlideViewWillScrollEndBlock)(CGFloat offset_x);
typedef void (^YLSlideTitleViewClickButtonBlock)(NSUInteger index);

@interface YLSlideTitleView : UIScrollView

@property (nonatomic,copy) YLSlideTitleViewScrollBlock
slideTitleViewScrollBlock;
@property (nonatomic,copy) YLSlideTitleViewClickButtonBlock slideTitleViewClickButtonBlock;
@property (nonatomic,copy) YLSlideViewWillScrollEndBlock
slideViewWillScrollEndBlock;
/*判断是否点击 Button 或 滚动 UIScrollView 进行页面的切换 */
@property (nonatomic,assign) BOOL isClickTitleButton;
@property (nonatomic,strong) NSDictionary *dict;

/* 以下两个用作滑动按钮下的小三角*/
@property (nonatomic,assign) float currentBtnX;
@property (nonatomic,assign) float preScrollViewCut;
//- (instancetype)initWithFrame:(CGRect)frame forTitles:(NSArray*)titles;
- (instancetype)initWithFrame:(CGRect)frame forTitles:(NSMutableArray*)titles;

@end
