//
//  ReflectionView.h
//  iCarousel
//
//  Created by 陈振辉 on 2025/4/28.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReflectionView : UIView

@property (nonatomic, assign) CGFloat reflectionGap;
@property (nonatomic, assign) CGFloat reflectionScale;
@property (nonatomic, assign) CGFloat reflectionAlpha;

- (void)refresh;

@end

NS_ASSUME_NONNULL_END
