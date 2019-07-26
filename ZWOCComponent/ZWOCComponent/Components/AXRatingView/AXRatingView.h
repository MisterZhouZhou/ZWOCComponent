//
//  AXRatingView.h
//

#import <UIKit/UIKit.h>

@interface AXRatingView : UIControl

@property (nonatomic) NSUInteger numberOfStar;        // 星星的数量(设置之后可更改图形数量)
@property (copy, nonatomic) NSString *markCharacter;  // 星星的字符如，@"\u2605"显示为★(设置之后可更改图形)
@property (strong, nonatomic) UIFont *markFont;       // 星星大小(设置之前h可更改大小)
@property (strong, nonatomic) UIImage *markImage;     // 星星图片(设置之后可更改图形)
@property (strong, nonatomic) UIColor *baseColor;     // 星星图片基色(设置之后可更改图形颜色)
@property (strong, nonatomic) UIColor *highlightColor;// 星星图片高亮的颜色(设置之后可更改图形高亮颜色)
@property (nonatomic) float value;                    // 星星的值
@property (nonatomic) float stepInterval;             // 步长([1-numberOfStar])
@property (nonatomic) float minimumValue;             // 最小值

@end
