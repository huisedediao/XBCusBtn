//
//  XBCusBtn.h
//  XBAnimationTest
//
//  Created by chuango on 16/10/20.
//  Copyright © 2016年 chuango. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    XBCusBtnTypeImageTop,//图片在上
    XBCusBtnTypeTitleTop,//文字在上
    XBCusBtnTypeImageLeft,//图片在左
    XBCusBtnTypeTitleLeft//文字在左
} XBCusBtnContentType;

typedef enum : NSUInteger {
    XBCusBtnSideTop,
    XBCusBtnSideBottom,
    XBCusBtnSideLeft,
    XBCusBtnSideRight,
    XBCusBtnSideCenter
} XBCusBtnContentSide;

@interface XBCusBtn : UIControl
/** 图片和文字排布样式 ，默认图片在左*/
@property (nonatomic,assign) XBCusBtnContentType contentType;
/** 图片和文字的间距,默认是0 */
@property (nonatomic,assign) CGFloat spaceOfImageAndTitle;
/** 内容（图片和文字）到对齐方向边缘的距离，内容在中间时不起作用，默认是0 */
@property (nonatomic,assign) CGFloat spaceToContentSide;
/** 内容（图片和文字）是靠那个方向对齐，上下左右，默认横向居中 */
@property (nonatomic,assign) XBCusBtnContentSide contentSide;
/** 图片所占的比例（默认0.5），如果是横向，则是高度占自身高度的比例；如果是纵向，则是宽度占自身宽度的比例
 *  如果同时设置了imageSize，以imageSize优先
 */
@property (nonatomic,assign) CGFloat imageRectScale;
/** 图片显示的size，如果同时设置了imageRectScale，以这里设置的size优先 */
@property (nonatomic,assign) CGSize imageSize;
/** 正常状态下的图片 */
@property (nonatomic,strong) UIImage *imageNormal;
/** 选中状态的图片 */
@property (nonatomic,strong) UIImage *imageSelected;
/** 正常状态下的文字 */
@property (nonatomic,copy) NSString *titleNormal;
/** 选中状态的文字 */
@property (nonatomic,copy) NSString *titleSelected;
/** 正常状态下的文字颜色，默认黑色 */
@property (nonatomic,strong) UIColor *titleColorNormal;
/** 选中状态的文字颜色，默认黑色 */
@property (nonatomic,strong) UIColor *titleColorSelected;
/** 标题字体，默认15号系统字体 */
@property (nonatomic,strong) UIFont *titleFont;
/** 正常状态下的背景图片 */
@property (nonatomic,strong) UIImage *backgroundImageNormal;
/** 选中状态的背景图片 */
@property (nonatomic,strong) UIImage *backgroundImageSelected;
@end
