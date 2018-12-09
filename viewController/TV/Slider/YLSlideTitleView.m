

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
    NSMutableArray    *_titles_temp;
    
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
        self.backgroundColor = [UIColor whiteColor];
        //        _titles              = [self titleArrReplace:titles];
        _titles              = [titles copy];
        _titles_temp         = [titles mutableCopy];
        
        _previousPage        = 0;
        self.delegate        = self;
        self.showsHorizontalScrollIndicator = NO;
        [self configView];
        
    }
    
    
    return self;
}
- (void)configView{
    NSLog(@"==- 减速完成（停止） 444");
    //设置 content size
    float buttonWidth = 0.f;
    
    for (NSUInteger i = 0; i<_titles.count ; i++) {
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setTitle:_titles[i] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor colorWithRed:0x21/255.0 green:0x21/255.0 blue:0x21/255.0 alpha:1] forState:UIControlStateNormal];   //大约等于黑色
        
        [button.titleLabel setFont:buttonFont(button,YLSlideTitleViewTitleMin)];
        
        
        
        CGSize titleSize = [YLSlideTitleView boudingRectWithSize:CGSizeMake(SCREEN_WIDTH_YLSLIDE, YLSildeTitleViewHeight)
                                                           label:button.titleLabel];
        
        CGRect frame;
        frame.origin = CGPointMake(buttonWidth, 0);
        frame.size   = CGSizeMake(titleSize.width+20, 48);  //两个字之间的间距
        
        [button setFrame:frame];
        
        buttonWidth += CGRectGetWidth(button.frame);
        
        button.tag             = YLSlideTitleViewButtonTag + i;
        button.backgroundColor = [UIColor clearColor];//[UIColor redColor];
        
        [button addTarget:self
                   action:@selector(buttonEvents:)
         forControlEvents:UIControlEventTouchUpInside];
        
        [self configButtonWithOffsetx:0];
        
        [self addSubview:button];
        
        
    }
    
    
    self.contentSize = CGSizeMake(buttonWidth, YLSildeTitleViewHeight);
    
    __WEAK_SELF_YLSLIDE
    
    self.slideTitleViewScrollBlock =^(CGFloat offsetx){
        
        
        __STRONG_SELF_YLSLIDE
        [strongSelf configButtonWithOffsetx:offsetx];
        NSLog(@"offsetx %f",offsetx);
        
    };
    
    self.slideViewWillScrollEndBlock =^(CGFloat offsetx){
        
        NSLog(@"offsetx1 %f",offsetx);
        __STRONG_SELF_YLSLIDE
        //设置 Button 可见
        CGFloat x = offsetx * (60 / self.frame.size.width) - 60;
        
//                NSLog(@"self.frame.size.width %f",self.frame.size.width);
//                NSLog(@"offsetx * (60 / self.frame.size.width) %f",offsetx * (60 / self.frame.size.width));
//
//
//                NSLog(@"self.frame.size.width1 %f",self.frame.size.width);
        
        [strongSelf scrollRectToVisible:CGRectMake(x, 0,
                                                   strongSelf.frame.size.width,
                                                   strongSelf.frame.size.height)
                               animated:YES];
        
    };
    
    
    //此处销毁通知，防止一个通知被多次调用
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"categorysTouchToViews" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categorysTouchToViews:) name:@"categorysTouchToViews" object:nil];
    
    //修改title 值和数量
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeButton" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeButton:) name:@"changeButton" object:nil];
    
}
-(void)categorysTouchToViews:(NSNotification *)text
{
    NSLog(@"==- 减速完成（停止）555 ");
    NSInteger currentIndex = [text.userInfo[@"currentIndex"]integerValue];
    //    [self slideViewRecycle];
    //    [self visibleViewDelegateForIndex:currentIndex];
    
    UIButton * btn = [[UIButton alloc]init];
    btn.tag = currentIndex+YLSlideTitleViewButtonTag;
    [self buttonEvents:btn];
    
    
    //    //实际是底部的ScrollerView的侧滑的距离大小
    //    int currentBtnShowX = [[UIScreen mainScreen] bounds].size.width * currentIndex;
    //
    //    if (self.slideViewWillScrollEndBlock) {
    //        self.slideViewWillScrollEndBlock(currentBtnShowX);
    //    }
    
}
- (void)configButtonWithOffsetx:(CGFloat)offsetx{
    
    NSLog(@"==- 减速完成（停止）666 ");
    
#warning 在重复使用 [UIFont fontWithName:button.titleLabel.font.fontName size:titleSize]方法会占用极大的内存(已反复试验)，每次都需要对Label进行处理。在此处请谨慎使用此方法，此变换效果也是其中一种可根据自行需求进行修改。有更好的方法可告知。
    
    NSUInteger currentPage   = offsetx/SCREEN_WIDTH_YLSLIDE;
    
    NSLog(@"currentPage === %d",currentPage);
    
    int YLSlideTitleViewButtonTagIndex = currentPage ;
    
    NSString *  YLSlideTitleViewButtonTagIndexStr = [NSString stringWithFormat:@"%d",YLSlideTitleViewButtonTagIndex];
    
    [USER_DEFAULT setObject:YLSlideTitleViewButtonTagIndexStr forKey:@"YLSlideTitleViewButtonTagIndexStr"];
    
    
    
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
    
    
    //**************8
    
    _currentBtnX = 0;
    for (int i = 28271; i<  currentButton.tag; i++) {
        UIButton * btn = (UIButton*)[self viewWithTag:i];
        _currentBtnX += btn.frame.size.width;
    }
    //    NSLog(@"currentButton1:%f",currentButton.bounds.origin.x +20 +currentButton.bounds.size.width/2- self.preScrollViewCut);
    
    _currentBtnX = _currentBtnX  +currentButton.frame.size.width/2 - self.preScrollViewCut;
    
    self.dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%f",_currentBtnX],@"currentBtnX", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"portTriangleFrame" object:nil userInfo:self.dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
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
    
    NSLog(@"==- 减速完成（停止）777 ");
    NSLog(@" currentPage === %d",(button.tag - YLSlideTitleViewButtonTag) );
    
    int YLSlideTitleViewButtonTagIndex = button.tag - YLSlideTitleViewButtonTag;
    
    //为了分类定位到中间
    //实际是底部的ScrollerView的侧滑的距离大小
    int currentBtnShowX = [[UIScreen mainScreen] bounds].size.width * YLSlideTitleViewButtonTagIndex;
    
    if (self.slideViewWillScrollEndBlock) {
        self.slideViewWillScrollEndBlock(currentBtnShowX);
    }
    
    NSString *  YLSlideTitleViewButtonTagIndexStr = [NSString stringWithFormat:@"%d",YLSlideTitleViewButtonTagIndex];
    
    [USER_DEFAULT setObject:YLSlideTitleViewButtonTagIndexStr forKey:@"YLSlideTitleViewButtonTagIndexStr"];
    
    
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
    
    
    //    NSLog(@"currentButton2:%f",currentButton.frame.origin.x);
    _currentBtnX = currentButton.frame.origin.x  +currentButton.bounds.size.width/2 - self.preScrollViewCut;
    
    
    self.dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%f",_currentBtnX],@"currentBtnX", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"portTriangleFrame" object:nil userInfo:self.dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}
#pragma mark
+ (CGSize)boudingRectWithSize:(CGSize)size label:(UILabel*)label
{
    NSLog(@"==- 减速完成（停止） 888");
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


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSLog(@"==- 减速完成（停止） 999");
    //    NSLog(@"currentButton3: + %f",scrollView.contentOffset.x);
    _currentBtnX = _currentBtnX - scrollView.contentOffset.x + self.preScrollViewCut ;
    
    
    
    self.preScrollViewCut = scrollView.contentOffset.x ;
    
    self.dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%f",_currentBtnX],@"currentBtnX", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"portTriangleFrame" object:nil userInfo:self.dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    
//    _titles = nil;
//    [self configView];
}

-(void)changeButton:(NSNotification *)text
{
    NSLog(@"==- 减速完成（停止） 000");
    //针对一个特殊环境做测试，删除title数量，修改title名称
    _titles_temp = text.userInfo[@"titleInfo"];

    float buttonWidth = 0.f;
    if (_titles_temp.count < _titles.count) {
        int countChazhi = _titles.count - _titles_temp.count;
        for (int i = 0; i < countChazhi ; i ++) {
            UIButton * currentButton = (UIButton*)[self viewWithTag:_titles.count - i-1 +YLSlideTitleViewButtonTag];
            currentButton.backgroundColor = [UIColor clearColor];
            [currentButton removeFromSuperview];

        }
        int currentIndexForCategory = 0 ;
        NSString * titleNumStr =  [USER_DEFAULT objectForKey:@"YLSlideTitleViewButtonTagIndexStr"];
        NSString * currentButtonName ;
        UIButton * currentButton = (UIButton*)[self viewWithTag:[titleNumStr integerValue] +YLSlideTitleViewButtonTag];
        currentButtonName = currentButton.titleLabel.text;
        
        NSLog(@"**currentIndexForCategory %@",currentIndexForCategory);
        NSLog(@"**titleNumStr %@",titleNumStr);
        NSLog(@"**currentButtonName %@",currentButtonName);
        for (int i = 0; i < _titles_temp.count ; i ++) {
            UIButton * currentButton = (UIButton*)[self viewWithTag:i +YLSlideTitleViewButtonTag];
            currentButton.backgroundColor = [UIColor clearColor];//[UIColor blueColor];
            [currentButton setTitle:_titles_temp[i] forState:UIControlStateNormal];

            
            CGSize titleSize = [YLSlideTitleView boudingRectWithSize:CGSizeMake(SCREEN_WIDTH_YLSLIDE, YLSildeTitleViewHeight)
                                                               label:currentButton.titleLabel];
//
            CGRect frame;
            frame.origin = CGPointMake(buttonWidth, 0);
            frame.size   = CGSizeMake(titleSize.width+20, 48);  //两个字之间的间距
            
            [currentButton setFrame:frame];
            
            buttonWidth += CGRectGetWidth(currentButton.frame);
            
            if ([currentButtonName isEqualToString:_titles_temp[i]]) {
                currentIndexForCategory = i;
                NSLog(@"**currentIndexForCategory %d",currentIndexForCategory);
            }
        }

        self.contentSize = CGSizeMake(buttonWidth, YLSildeTitleViewHeight);
        
        if(titleNumStr.intValue == _titles.count - 1  )
        {
                    NSNumber * currentIndexForCategoryNum = @(_titles_temp.count - 1);
                    NSDictionary * dict =[[NSDictionary alloc] initWithObjectsAndKeys:currentIndexForCategoryNum,@"currentIndex", nil];
            
                    NSNotification *notification12 =[NSNotification notificationWithName:@"categorysTouchToViews" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification12];
        }
//        NSNumber * currentIndexForCategoryNum = @(currentIndexForCategory);
//        NSDictionary * dict =[[NSDictionary alloc] initWithObjectsAndKeys:currentIndexForCategoryNum,@"currentIndex", nil];
//
//        NSNotification *notification12 =[NSNotification notificationWithName:@"categorysTouchToViews" object:nil userInfo:dict];
//        [[NSNotificationCenter defaultCenter] postNotification:notification12];
        
        
        //        NSLog(@"==- 减速完成（停止）555 ");
        
        
        //        NSInteger currentIndex = currentIndexForCategory;
        //        UIButton * btn = [[UIButton alloc]init];
        //        btn.tag = currentIndex+YLSlideTitleViewButtonTag;
        //        [self buttonEvents_titleCut:btn];
        
 
        _titles = [_titles_temp mutableCopy];
    }else if (_titles_temp.count == _titles.count)
    {
        
        NSString * titleNumStr =  [USER_DEFAULT objectForKey:@"YLSlideTitleViewButtonTagIndexStr"];
        int currentIndexForCategory = 0 ;
        NSString * currentButtonName ;
        UIButton * currentButton = (UIButton*)[self viewWithTag:[titleNumStr integerValue] +YLSlideTitleViewButtonTag];
        currentButtonName = currentButton.titleLabel.text;
        NSLog(@"currentButtonName == %@",currentButtonName);
        
        
        for (int i = 0; i < _titles_temp.count ; i ++) {
            UIButton * currentButton = (UIButton*)[self viewWithTag:i +YLSlideTitleViewButtonTag];
            currentButton.backgroundColor = [UIColor clearColor]; //[UIColor blueColor];
            [currentButton setTitle:_titles_temp[i] forState:UIControlStateNormal];
            
            
            CGSize titleSize = [YLSlideTitleView boudingRectWithSize:CGSizeMake(SCREEN_WIDTH_YLSLIDE, YLSildeTitleViewHeight)
                                                               label:currentButton.titleLabel];
            
            CGRect frame;
            frame.origin = CGPointMake(buttonWidth, 0);
            frame.size   = CGSizeMake(titleSize.width+20, 48);  //两个字之间的间距
            
            [currentButton setFrame:frame];
            
            buttonWidth += CGRectGetWidth(currentButton.frame);
        }
        
        
        
        
        self.contentSize = CGSizeMake(buttonWidth, YLSildeTitleViewHeight);
        _titles = [_titles_temp mutableCopy];
        
        
        
        for (int i = 0 ; i < _titles_temp.count; i ++) {
            UIButton * currentButton = (UIButton*)[self viewWithTag:i + YLSlideTitleViewButtonTag];
            
            if ([currentButtonName isEqualToString:currentButton.titleLabel.text]) {
                NSLog(@"currentButtonName %@",currentButtonName);
                NSLog(@"i %d",i);
                currentIndexForCategory = i;
            }
        }
        
        NSNumber * currentIndexForCategoryNum = @(currentIndexForCategory);
        NSDictionary * dict =[[NSDictionary alloc] initWithObjectsAndKeys:currentIndexForCategoryNum,@"currentIndex", nil];
        
        NSNotification *notification12 =[NSNotification notificationWithName:@"categorysTouchToViews" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notification12];
        
    }else if (_titles_temp.count > _titles.count){
        
        //            NSNotification *recycleNotific =[NSNotification notificationWithName:@"recycle" object:nil userInfo:nil];
        //            [[NSNotificationCenter defaultCenter] postNotification:recycleNotific];
        
        NSString * titleNumStr =  [USER_DEFAULT objectForKey:@"YLSlideTitleViewButtonTagIndexStr"];
        int currentIndexForCategory = 0 ;
        NSString * currentButtonName ;
        UIButton * currentButton = (UIButton*)[self viewWithTag:[titleNumStr integerValue] +YLSlideTitleViewButtonTag];
        currentButtonName = currentButton.titleLabel.text;
        NSLog(@"currentButtonName == %@",currentButtonName);
        
        int countChazhi = _titles_temp.count - _titles.count;
        
        for (int i = 0; i < _titles.count ; i ++) {
            UIButton * currentButton = (UIButton*)[self viewWithTag:_titles.count - i-1 +YLSlideTitleViewButtonTag];
            currentButton.backgroundColor = [UIColor clearColor];
            [currentButton removeFromSuperview];
            currentButton = nil;
            
        }
        
 
            _titles = [_titles_temp mutableCopy];
            NSLog(@"_title s %lu",(unsigned long)_titles.count);
            [self configView];
        
  
        _titles = [_titles_temp mutableCopy];
        
      
        
        NSLog(@"**currentIndexForCategory %@",currentIndexForCategory);
        NSLog(@"**titleNumStr %@",titleNumStr);
        NSLog(@"**currentButtonName %@",currentButtonName);
        
        for (int i = 0 ; i < _titles_temp.count; i ++) {
            UIButton * currentButton = (UIButton*)[self viewWithTag:i + YLSlideTitleViewButtonTag];
            
            if ([currentButtonName isEqualToString:currentButton.titleLabel.text]) {
                NSLog(@"currentButtonName %@",currentButtonName);
                NSLog(@"i %d",i);
                currentIndexForCategory = i;
            }
        }
        
        NSNumber * currentIndexForCategoryNum = @(currentIndexForCategory);
        NSDictionary * dict =[[NSDictionary alloc] initWithObjectsAndKeys:currentIndexForCategoryNum,@"currentIndex", nil];
        
        NSNotification *notification12 =[NSNotification notificationWithName:@"categorysTouchToViews" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notification12];
        
        
        NSNotification *notification =[NSNotification notificationWithName:@"setSliderViewByReSetNotific" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        

        
    }
    
    
}

@end

