//
//  CategoryModel.h
//  StarAPP
//
//  Created by xyz on 16/9/12.
//
//

#import <Foundation/Foundation.h>

@interface CategoryModel : NSObject

@property (nonatomic, assign) NSString * deviceName;
@property (nonatomic, strong) NSString *category_name;
@property (nonatomic, strong) NSMutableArray *service_indexArr;


@end
