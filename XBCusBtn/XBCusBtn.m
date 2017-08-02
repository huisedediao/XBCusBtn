//
//  XBCusBtn.m
//  XBAnimationTest
//
//  Created by chuango on 16/10/20.
//  Copyright © 2016年 chuango. All rights reserved.
//

#import "XBCusBtn.h"
#import <objc/message.h>

//block weak属性化self宏
#define WEAK_SELF __typeof(self) __weak weakSelf = self;

//字符串是否为空
#define StringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

//根据传入的文字、宽度和字体计算出合适的size (CGSize)
#define getAdjustSizeWith_text_width_font(text,width,font) ({[text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :font} context:NULL].size;})

//根据传入的文字和字体获取宽度 (CGFloat)
#define getWidthWith_title_font(title,font) ({\
UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];\
label.text = title;\
label.font = font;\
[label sizeToFit];\
label.frame.size.width;\
})

@interface XBCusBtn ()
{
    id targetSave;
    SEL actionSave;
    UIControlEvents controlEventsSave;
}
@property (nonatomic,assign) CGSize imageRectSize;
@property (nonatomic,assign) CGSize titleRectSize;
@property (nonatomic,assign) CGPoint imageOrigin;
@property (nonatomic,assign) CGPoint titleOrigin;
/** 图片 */
@property (nonatomic,strong) UIImage *image;
/** 文字 */
@property (nonatomic,copy) NSString *title;
/** 文字颜色，默认黑色 */
@property (nonatomic,strong) UIColor *titleColor;
/** 背景图片 */
@property (nonatomic,strong) UIImage *backgroundImage;
@end

@implementation XBCusBtn

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        [self initParams];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super initWithCoder:aDecoder])
    {
        [self initParams];
    }
    return self;
}
-(void)initParams
{
    self.backgroundColor=[UIColor clearColor];
    self.titleFont=[UIFont systemFontOfSize:15];
    self.titleColor=[UIColor blackColor];
    self.imageRectScale=0.5;
    self.contentType=XBCusBtnTypeImageLeft;
    self.spaceOfImageAndTitle=0;
    self.spaceToContentSide=0;
    self.contentSide=XBCusBtnSideCenter;
    self.layer.masksToBounds=YES;
    [self addTarget:self action:@selector(selfClick) forControlEvents:UIControlEventTouchUpInside];
    [self addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:nil];
}
-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"highlighted"];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"highlighted"])
    {
        [self setNeedsDisplay];
    }
}
-(void)selfClick{}
-(void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    if (self.block)
    {
        WEAK_SELF
        ActionBlock block=[self.block copy];
        block(weakSelf);
    }
    else
    {
        [super sendAction:action to:target forEvent:event];
    }
}
-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    if (target==self)
    {
        if ([self actionsForTarget:self forControlEvent:controlEvents])
        {
            return;
        }
        [super addTarget:target action:action forControlEvents:controlEvents];
    }
    else
    {
        if ([self actionsForTarget:self forControlEvent:controlEvents])
        {
            [self removeTarget:self action:action forControlEvents:controlEvents];
        }
        [super addTarget:target action:action forControlEvents:controlEvents];
    }
}

-(void)drawRect:(CGRect)rect
{
    self.selected=self.selected;
    [self getTitleSizeWithRect:rect font:self.titleFont];
    [self getImageSizeWithRect:rect];
    [self getTitleOriginWithRect:rect];
    [self getImageOriginWithRect:rect];
    
    if(self.backgroundImage)
    {
        [self.backgroundImage drawInRect:rect];
    }
    if (self.image)
    {
        [self.image drawInRect:CGRectMake(self.imageOrigin.x, self.imageOrigin.y,self.imageRectSize.width,self.imageRectSize.height)];
    }
    [self setTitleWithColor:self.titleColor];
    if ([self isHighlighted])
    {
        if(self.backgroundColorHighlight)
        {
            [self.backgroundColorHighlight set];
            UIRectFillUsingBlendMode(rect, kCGBlendModeMultiply);
        }
        
        if (self.titleColorHighlight) {
            [self setTitleWithColor:self.titleColorHighlight];
        }
    }
}
-(void)setTitleWithColor:(UIColor *)color
{
    if (self.title)
    {
        NSMutableDictionary *dict=[NSMutableDictionary new];
        dict[NSForegroundColorAttributeName]=color;
        dict[NSFontAttributeName]=self.titleFont;
        [self.title drawInRect:CGRectMake(self.titleOrigin.x, self.titleOrigin.y,self.titleRectSize.width,self.titleRectSize.height) withAttributes:dict];
    }
}


-(void)getImageOriginWithRect:(CGRect)rect
{
    CGFloat imageX;
    CGFloat imageY;
    switch (self.contentSide)
    {
        case XBCusBtnSideTop:
        {
            switch (self.contentType)
            {
                case XBCusBtnTypeImageTop://图片在上
                {
                    imageY=self.titleOrigin.y-self.imageRectSize.height-self.spaceOfImageAndTitle;
                }
                    break;
                case XBCusBtnTypeTitleTop://文字在上
                {
                    imageY=self.titleOrigin.y+self.titleRectSize.height+self.spaceOfImageAndTitle;
                }
                default:
                    break;
            }
            imageX=(rect.size.width-self.imageRectSize.width)*0.5;
        }
            break;
        case XBCusBtnSideBottom:
        {
            switch (self.contentType)
            {
                case XBCusBtnTypeImageTop://图片在上
                {
                    imageY=self.titleOrigin.y-self.imageRectSize.height-self.spaceOfImageAndTitle;
                }
                    break;
                case XBCusBtnTypeTitleTop://文字在上
                {
                    imageY=self.titleOrigin.y+self.titleRectSize.height+self.spaceOfImageAndTitle;
                }
                default:
                    break;
            }
            imageX=(rect.size.width-self.imageRectSize.width)*0.5;
        }
            break;
        case XBCusBtnSideLeft:
        {
            switch (self.contentType)
            {
                case XBCusBtnTypeImageLeft:
                {
                    imageX=self.titleOrigin.x-self.spaceOfImageAndTitle-self.imageRectSize.width;
                }
                    break;
                case XBCusBtnTypeTitleLeft:
                {
                    imageX=self.titleOrigin.x+self.spaceOfImageAndTitle+self.titleRectSize.width;
                }
                    break;
                    
                default:
                    break;
            }
            imageY=(rect.size.height-self.imageRectSize.height)*0.5;
        }
            break;
        case XBCusBtnSideRight:
        {
            switch (self.contentType)
            {
                case XBCusBtnTypeImageLeft:
                {
                    imageX=self.titleOrigin.x-self.spaceOfImageAndTitle-self.imageRectSize.width;
                }
                    break;
                case XBCusBtnTypeTitleLeft:
                {
                    imageX=self.titleOrigin.x+self.spaceOfImageAndTitle+self.titleRectSize.width;
                }
                    break;
                    
                default:
                    break;
            }
            imageY=(rect.size.height-self.imageRectSize.height)*0.5;
        }
            break;
        case XBCusBtnSideCenter:
        {
            switch (self.contentType)
            {
                case XBCusBtnTypeImageLeft:
                {
                    imageX=self.titleOrigin.x-self.spaceOfImageAndTitle-self.imageRectSize.width;
                    imageY=(rect.size.height-self.imageRectSize.height)*0.5;
                }
                    break;
                case XBCusBtnTypeTitleLeft:
                {
                    imageX=self.titleOrigin.x+self.spaceOfImageAndTitle+self.titleRectSize.width;
                    imageY=(rect.size.height-self.imageRectSize.height)*0.5;
                }
                    break;
                case XBCusBtnTypeImageTop://图片在上
                {
                    imageY=self.titleOrigin.y-self.imageRectSize.height-self.spaceOfImageAndTitle;
                    imageX=(rect.size.width-self.imageRectSize.width)*0.5;
                }
                    break;
                case XBCusBtnTypeTitleTop://文字在上
                {
                    imageY=self.titleOrigin.y+self.titleRectSize.height+self.spaceOfImageAndTitle;
                    imageX=(rect.size.width-self.imageRectSize.width)*0.5;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    self.imageOrigin=CGPointMake(imageX, imageY);
}
-(void)getTitleOriginWithRect:(CGRect)rect
{
    CGFloat titleY;
    CGFloat titleX;
    switch (self.contentSide)
    {
        case XBCusBtnSideTop:
        {
            switch (self.contentType)
            {
                case XBCusBtnTypeImageTop://竖直，图片在上
                {
                    titleY=self.spaceToContentSide+self.spaceOfImageAndTitle+self.imageRectSize.height;
                }
                    break;
                case XBCusBtnTypeTitleTop://竖直，文字在上
                {
                    titleY=self.spaceToContentSide;
                }
                default:
                    break;
            }
            titleX=(rect.size.width-self.titleRectSize.width)*0.5;
        }
            break;
        case XBCusBtnSideBottom:
        {
            switch (self.contentType)
            {
                case XBCusBtnTypeImageTop://竖直，图片在上
                {
                    titleY=rect.size.height-self.spaceToContentSide-self.titleRectSize.height;
                }
                    break;
                case XBCusBtnTypeTitleTop://竖直，文字在上
                {
                    titleY=rect.size.height-self.spaceToContentSide-self.imageRectSize.height-self.spaceOfImageAndTitle-self.titleRectSize.height;
                }
                default:
                    break;
            }
            titleX=(rect.size.width-self.titleRectSize.width)*0.5;
        }
            break;
        case XBCusBtnSideLeft:
        {
            switch (self.contentType)
            {
                case XBCusBtnTypeImageLeft://水平，图片在左边
                {
                    titleX=self.spaceToContentSide+self.imageRectSize.width+self.spaceOfImageAndTitle;
                }
                    break;
                case XBCusBtnTypeTitleLeft://水平，文字在左边
                {
                    titleX=self.spaceToContentSide;
                }
                    break;
                    
                default:
                    break;
            }
            titleY=(rect.size.height-self.titleRectSize.height)*0.5;
        }
            break;
        case XBCusBtnSideRight:
        {
            switch (self.contentType)
            {
                case XBCusBtnTypeImageLeft://水平，图片在左边
                {
                    titleX=rect.size.width-self.titleRectSize.width-self.spaceToContentSide;
                }
                    break;
                case XBCusBtnTypeTitleLeft://水平，文字在左边
                {
                    titleX=rect.size.width-self.titleRectSize.width-self.spaceToContentSide-self.spaceOfImageAndTitle-self.imageRectSize.width;
                }
                    break;
                    
                default:
                    break;
            }
            titleY=(rect.size.height-self.titleRectSize.height)*0.5;
        }
            break;
        case XBCusBtnSideCenter:
        {
            switch (self.contentType)
            {
                case XBCusBtnTypeImageLeft://水平，图片在左边
                {
                    titleX=(rect.size.width-self.titleRectSize.width-self.spaceOfImageAndTitle-self.imageRectSize.width)*0.5+self.imageRectSize.width+self.spaceOfImageAndTitle;
                    
                    titleY=(rect.size.height-self.titleRectSize.height)*0.5;
                }
                    break;
                case XBCusBtnTypeTitleLeft://水平，文字在左边
                {
                    titleX=(rect.size.width-self.titleRectSize.width-self.spaceOfImageAndTitle-self.imageRectSize.width)*0.5;
                    
                    titleY=(rect.size.height-self.titleRectSize.height)*0.5;
                }
                    break;
                    
                case XBCusBtnTypeImageTop:
                {
                    titleY=(rect.size.height-self.titleRectSize.height-self.imageRectSize.height-self.spaceOfImageAndTitle)*0.5+self.imageRectSize.height+self.spaceOfImageAndTitle;
                    titleX=(rect.size.width-self.titleRectSize.width)*0.5;
                }
                    break;
                    
                case XBCusBtnTypeTitleTop:
                {
                    titleY=(rect.size.height-self.titleRectSize.height-self.imageRectSize.height-self.spaceOfImageAndTitle)*0.5;
                    titleX=(rect.size.width-self.titleRectSize.width)*0.5;
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    self.titleOrigin=CGPointMake(titleX, titleY);
}

//计算文字的size
-(void)getTitleSizeWithRect:(CGRect)rect font:(UIFont *)font
{
    if (StringIsEmpty(self.title)==NO)
    {
        CGFloat textWith=getWidthWith_title_font(self.title, font);
        if (self.contentType==XBCusBtnTypeImageTop || self.contentType==XBCusBtnTypeTitleTop)
        {
            CGFloat rectW=rect.size.width;
            self.titleRectSize=getAdjustSizeWith_text_width_font(self.title, textWith>rectW?rectW:textWith, font);
        }
        else
        {
            CGFloat rectW=(rect.size.width-self.spaceToContentSide-self.imageRectSize.width-self.spaceOfImageAndTitle);
            self.titleRectSize=getAdjustSizeWith_text_width_font(self.title,  textWith>rectW?rectW:textWith, font);
        }
    }
}
//计算图片的size
-(void)getImageSizeWithRect:(CGRect)rect
{
    if (self.image)
    {
        CGFloat imageHWScale=self.image.size.height/self.image.size.width;
        CGFloat imageW;
        CGFloat imageH;
        switch (self.contentType)
        {
            case XBCusBtnTypeImageTop:
            {
                imageW=rect.size.width*self.imageRectScale;
                imageH=imageW*imageHWScale;
            }
                break;
            case XBCusBtnTypeTitleTop:
            {
                imageW=rect.size.width*self.imageRectScale;
                imageH=imageW*imageHWScale;
            }
                break;
            case XBCusBtnTypeImageLeft:
            {
                imageH=rect.size.height*self.imageRectScale;
                imageW=imageH/imageHWScale;
            }
                break;
            case XBCusBtnTypeTitleLeft:
            {
                imageH=rect.size.height*self.imageRectScale;
                imageW=imageH/imageHWScale;
            }
                break;
                
            default:
                break;
        }
        if (self.imageSize.width==CGSizeZero.width && self.imageSize.height==CGSizeZero.height)
        {
            self.imageRectSize=CGSizeMake(imageW, imageH);
        }
        else
        {
            self.imageRectSize=self.imageSize;
        }
    }
}

#pragma mark - 方法重写
-(void)setSpaceToContentSide:(CGFloat)spaceToContentSide
{
    _spaceToContentSide=spaceToContentSide;
    [self setNeedsDisplay];
}
-(void)setSpaceOfImageAndTitle:(CGFloat)spaceOfImageAndTitle
{
    _spaceOfImageAndTitle=spaceOfImageAndTitle;
    [self setNeedsDisplay];
}
-(void)setTitle:(NSString *)title
{
    _title=title;
    [self setNeedsDisplay];
}
-(void)setTitleFont:(UIFont *)titleFont
{
    _titleFont=titleFont;
    [self setNeedsDisplay];
}
-(void)setTitleColor:(UIColor *)titleColor
{
    _titleColor=titleColor;
    [self setNeedsDisplay];
}
-(void)setImage:(UIImage *)image
{
    _image=image;
    [self setNeedsDisplay];
}
-(void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage=backgroundImage;
    [self setNeedsDisplay];
}
-(void)setImageRectScale:(CGFloat)imageRectScale
{
    _imageRectScale=imageRectScale;
    [self setNeedsDisplay];
}
-(void)setContentSide:(XBCusBtnContentSide)contentSide
{
    _contentSide=contentSide;
    [self setNeedsDisplay];
}
-(void)setContentType:(XBCusBtnContentType)contentType
{
    _contentType=contentType;
    [self setNeedsDisplay];
}
-(void)setImageSize:(CGSize)imageSize
{
    _imageSize=imageSize;
    [self setNeedsDisplay];
}
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected)
    {
        self.titleColor=self.titleColorSelected?self.titleColorSelected:self.titleColorNormal;
        self.title=self.titleSelected?self.titleSelected:self.titleNormal;
        self.image=self.imageSelected?self.imageSelected:self.imageNormal;
        self.backgroundImage=self.backgroundImageSelected?self.backgroundImageSelected:self.backgroundImageNormal;
    }
    else
    {
        self.titleColor=self.titleColorNormal?self.titleColorNormal:self.titleColorSelected;
        self.title=self.titleNormal?self.titleNormal:self.titleSelected;
        self.image=self.imageNormal?self.imageNormal:self.imageSelected;
        self.backgroundImage=self.backgroundImageNormal?self.backgroundImageNormal:self.backgroundImageSelected;
    }
}
-(void)setTitleNormal:(NSString *)titleNormal
{
    _titleNormal=titleNormal;
    self.title=titleNormal;
}
-(void)setTitleSelected:(NSString *)titleSelected
{
    _titleSelected=titleSelected;
    self.title=titleSelected;
}
-(void)setTitleColorNormal:(UIColor *)titleColorNormal
{
    _titleColorNormal=titleColorNormal;
    self.titleColor=titleColorNormal;
}
-(void)setTitleColorSelected:(UIColor *)titleColorSelected
{
    _titleColorSelected=titleColorSelected;
    self.titleColor=titleColorSelected;
}
-(void)setImageNormal:(UIImage *)imageNormal
{
    _imageNormal=imageNormal;
    self.image=imageNormal;
}
-(void)setImageSelected:(UIImage *)imageSelected
{
    _imageSelected=imageSelected;
    self.image=imageSelected;
}
-(void)setBackgroundImageNormal:(UIImage *)backgroundImageNormal
{
    _backgroundImageNormal=backgroundImageNormal;
    self.backgroundImage=backgroundImageNormal;
}
-(void)setBackgroundImageSelected:(UIImage *)backgroundImageSelected
{
    _backgroundImageSelected=backgroundImageSelected;
    self.backgroundImage=backgroundImageSelected;
}

@end
