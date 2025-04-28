//
//  ReflectionView.m
//  iCarousel
//
//  Created by 陈振辉 on 2025/4/28.
//

#import "ReflectionView.h"

@interface ReflectionView ()
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end


@implementation ReflectionView

+ (Class)layerClass {
    return [CAReplicatorLayer class];
}

- (void)dealloc {
    _gradientLayer = nil;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    //set default properties
    _reflectionGap = 0.0f;
    _reflectionScale = 0.3f;
    _reflectionAlpha = 0.5f;
    
    //update reflection
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self refresh];
}

- (void)refresh {
    //update instances
    CAReplicatorLayer *layer = (CAReplicatorLayer *)self.layer;
    layer.shouldRasterize = YES;
    layer.rasterizationScale = [UIScreen mainScreen].scale;
    layer.instanceCount = 2;
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0.0f, layer.bounds.size.height + _reflectionGap, 0.0f);
    transform = CATransform3DScale(transform, 1.0f, -1.0f, 0.0f);
    layer.instanceTransform = transform;
    layer.instanceAlphaOffset = _reflectionAlpha - 1.0f;
    
    //create gradient layer
    if (!_gradientLayer) {
        _gradientLayer = [[CAGradientLayer alloc] init];
        self.layer.mask = _gradientLayer;
        _gradientLayer.colors = @[(__bridge id)[UIColor blackColor].CGColor,
                                  (__bridge id)[UIColor blackColor].CGColor,
                                  (__bridge id)[UIColor clearColor].CGColor];
    }
    
    //update mask
    [CATransaction begin];
    [CATransaction setDisableActions:YES]; // don't animate
    CGFloat total = layer.bounds.size.height * 2.0f + _reflectionGap;
    CGFloat halfWay = (layer.bounds.size.height + _reflectionGap) / total - 0.01f;
    _gradientLayer.frame = CGRectMake(0.0f, 0.0f, self.bounds.size.width, total);
    _gradientLayer.locations = @[@0.0f, @(halfWay), @(halfWay + (1.0f - halfWay) * _reflectionScale)];
    [CATransaction commit];
}


- (void)setReflectionGap:(CGFloat)reflectionGap {
    _reflectionGap = reflectionGap;
    [self setNeedsLayout];
}

- (void)setReflectionScale:(CGFloat)reflectionScale {
    _reflectionScale = reflectionScale;
    [self setNeedsLayout];
}

- (void)setReflectionAlpha:(CGFloat)reflectionAlpha {
    _reflectionAlpha = reflectionAlpha;
    [self setNeedsLayout];
}


@end


