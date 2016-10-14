

#import "YLSlideTitleView.h"


static NSInteger const YLSlideTitleViewButtonTag = 28271;
static CGFloat   const YLSlideTitleViewTitleMax  = 15.f;
static CGFloat   const YLSlideTitleViewTitleMin  = 15.f;

static inline UIFont *buttonFont(UIButton *button,CGFloat titleSize){
    
    return [UIFont fontWithName:button.titleLabel.font.fontName size:titleSize];
}

@interface YLSlideTitleView()<UIScrollViewDelegate>{

//    NSArray    *_titles;
NSMutableArray    *_titles;
    NSUInteger  _previousPage;
    
}
//设置 view 和 button
- (void)configView;
- (void)configButtonWithOffsetx:(CGFloat)offsetx;
//计算字体变化大小
- (CGFloat)titleSizeSpacingWithOffsetx:(CGFloat)sx;
@end

@implementation YLSlideTitleView

- (instancetype)initWithFrame:(CGRect)frame forTitles:(NSMutableArray*)titles{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = SET_COLOS_YLSLIDE(250, 250, 250);
        _titles              = [titles copy];
        _previousPage        = 0;
        self.delegate        = self;
        self.showsHorizontalScrollIndicator = NO;
        [self configView];
        
    }
    
    return self;
}

- (void)configView{

    //设置 content size
    float buttonWidth = 0.f;

    for (NSUInteger i = 0; i<_titles.count; i++) {
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setTitle:_titles[i] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor colorWithRed:0x21/255.0 green:0x21/255.0 blue:0x21/255.0 alpha:1] forState:UIControlStateNormal];
     
        [button.titleLabel setFont:buttonFont(button,YLSlideTitleViewTitleMin)];
        
        
        CGSize titleSize = [YLSlideTitleView boudingRectWithSize:CGSizeMake(SCREEN_WIDTH_YLSLIDE, YLSildeTitleViewHeight)
                                                        label:button.titleLabel];
        
        CGRect frame;
        frame.origin = CGPointMake(buttonWidth, 0);
        frame.size   = CGSizeMake(titleSize.width+20, 48);  //两个字之间的间距
        
        [button setFrame:frame];
        
        buttonWidth += CGRectGetWidth(button.frame);

        button.tag             = YLSlideTitleViewButtonTag + i;
        button.backgroundColor = [UIColor whiteColor];
        
        [button addTarget:self
                   action:@selector(buttonEvents:)
         forControlEvents:UIControlEventTouchUpInside];
        
        [self configButtonWithOffsetx:0];
        
        [self addSubview:button];
        
//        UIImageView *triangleView = [[UIImageView alloc]init];
//        triangleView.frame = CGRectMake(CGRectGetMinX(button.frame)+CGRectGetWidth(button.frame)/2, 48-6, 14, 7);
//        triangleView.image =  [UIImage imageNamed:@"Group 7"];
//        [button addSubview:triangleView];
        //        [self addSubview:triangleView];
//        [self bringSubviewToFront:triangleView];
//        [_slideTitleView bringSubviewToFront:triangleView];
//        [self.lineview  bringSubviewToFront:triangleView];
    }
    
    
    self.contentSize = CGSizeMake(buttonWidth, YLSildeTitleViewHeight);
    
    __WEAK_SELF_YLSLIDE
    
    self.slideTitleViewScrollBlock =^(CGFloat offsetx){
        
        
        __STRONG_SELF_YLSLIDE
        [strongSelf configButtonWithOffsetx:offsetx];

    };
    
    self.slideViewWillScrollEndBlock =^(CGFloat offsetx){
        
        __STRONG_SELF_YLSLIDE
       //设置 Button 可见
        CGFloat x = offsetx * (60 / self.frame.size.width) - 60;
      
        [strongSelf scrollRectToVisible:CGRectMake(x, 0,
                                                   strongSelf.frame.size.width,
                                                   strongSelf.frame.size.height)
                               animated:YES];
    
    };

  

    
}

- (void)configButtonWithOffsetx:(CGFloat)offsetx{
    
#warning 在重复使用 [UIFont fontWithName:button.titleLabel.font.fontName size:titleSize]方法会占用极大的内存(已反复试验)，每次都需要对Label进行处理。在此处请谨慎使用此方法，此变换效果也是其中一种可根据自行需求进行修改。有更好的方法可告知。

    NSUInteger currentPage   = offsetx/SCREEN_WIDTH_YLSLIDE;
    
//    CGFloat titleSizeSpacing = [self titleSizeSpacingWithOffsetx:offsetx/SCREEN_WIDTH];
    
    if (_previousPage != currentPage) {
        
        UIButton * previousButton = (UIButton*)[self viewWithTag:_previousPage +YLSlideTitleViewButtonTag];
        
        [previousButton setTitleColor:[UIColor colorWithRed:0x21/255.0 green:0x21/255.0 blue:0x21/255.0 alpha:1]
                        forState:UIControlStateNormal];
        
    }
    
    UIButton * currentButton = (UIButton*)[self viewWithTag:currentPage+YLSlideTitleViewButtonTag];
//    [currentButton.titleLabel setFont:[UIFont systemFontOfSize:(YLSlideTitleViewTitleMax-titleSizeSpacing)]];
   // [currentButton.titleLabel setFont:buttonFont(currentButton,
                                                 //YLSlideTitleViewTitleMax-titleSizeSpacing)];
    
    [currentButton setTitleColor:[UIColor colorWithRed:0x60/255.0 green:0xa3/255.0 blue:0xec/255.0 alpha:1]  forState:UIControlStateNormal];
    
    UIButton * nextButton = [self viewWithTag:currentPage+1+YLSlideTitleViewButtonTag];
    
//    [nextButton.titleLabel setFont:[UIFont systemFontOfSize:(YLSlideTitleViewTitleMin+titleSizeSpacing)]];
    //[nextButton.titleLabel setFont:buttonFont(currentButton,
                                             // YLSlideTitleViewTitleMin+titleSizeSpacing)];
    
    [nextButton setTitleColor:[UIColor colorWithRed:0x21/255.0 green:0x21/255.0 blue:0x21/255.0 alpha:1] forState:UIControlStateNormal];

    _previousPage = currentPage;
    
//    //******
//    float getCurrentBtnX = CGRectGetMinX(currentButton.frame);
//    float getCurrentBtnWidth = CGRectGetMinX(currentButton.frame);
//    
//    self.dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%f",getCurrentBtnX],@"textOne",[NSString stringWithFormat:@"%f",getCurrentBtnWidth],@"textTwo", nil];
//    //创建通知
//    NSNotification *notification =[NSNotification notificationWithName:@"portTriangleFrame" object:nil userInfo:self.dict];
//    //通过通知中心发送通知
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
//    
//    
    
}

//- (CGFloat)titleSizeSpacingWithOffsetx:(CGFloat)sx{
//  
////    NSInteger scale         = sx*100;
////    CGFloat   currentScale  = (scale % 100) * 0.01 * 3;
//    
//    return currentScale;
//}

//按钮点击
- (void)buttonEvents:(UIButton*)button{

    self.isClickTitleButton = YES;
    
    if (_slideTitleViewClickButtonBlock) {
        _slideTitleViewClickButtonBlock(button.tag - YLSlideTitleViewButtonTag);
    }
    
    UIButton *previousButton = [self viewWithTag:_previousPage + YLSlideTitleViewButtonTag];
    [[previousButton titleLabel]setFont:[UIFont systemFontOfSize:YLSlideTitleViewTitleMin]];
    [previousButton setTitleColor:[UIColor colorWithRed:0x21/255.0 green:0x21/255.0 blue:0x21/255.0 alpha:1] forState:UIControlStateNormal];
    
    UIButton *currentButton = [self viewWithTag:button.tag];
    [[currentButton titleLabel]setFont:[UIFont systemFontOfSize:YLSlideTitleViewTitleMin]];
    [currentButton setTitleColor:[UIColor colorWithRed:0x60/255.0 green:0xa3/255.0 blue:0xec/255.0 alpha:1] forState:UIControlStateNormal];
    
    _previousPage = button.tag - YLSlideTitleViewButtonTag;
    
}

#pragma mark
+ (CGSize)boudingRectWithSize:(CGSize)size label:(UILabel*)label
{
#warning 如果你是IOS7以下设备使用，请增加相对应的方法
    UIFont * font = label.font;
    font = [font fontWithSize:YLSlideTitleViewTitleMax];
    NSDictionary * attribute =@{NSFontAttributeName:font};
    
    return   [label.text boundingRectWithSize:size
                                      options:
              NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|
              NSStringDrawingUsesFontLeading
                                   attributes:
              attribute
                                      context:
              nil].size;
    
}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
////    scrollView.contentOffset.x;    //x
////    scrollView.contentOffset.y;    //y
//
//    self.dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%f",scrollView.contentOffset.x],@"textContentOffsetX", nil];
//    //创建通知
//    NSNotification *notification =[NSNotification notificationWithName:@"portTriangleFrame" object:nil userInfo:self.dict];
//    //通过通知中心发送通知
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
//
//}
@end
