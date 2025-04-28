//
//  ViewController.m
//  iCarousel
//
//  Created by 陈振辉 on 2025/4/28.
//

#import "ViewController.h"
#import "iCarousel.h"
#import "ReflectionView.h"

@interface ViewController ()<iCarouselDelegate, iCarouselDataSource> {
    iCarousel* _carousel;
    
    NSArray<UIImage *> *_images;
    UIImage* _placeholderImage;
}

@end

@implementation ViewController

- (void)dealloc {
    _carousel = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    _images = [self loadImages];
    
    _carousel = [[iCarousel alloc] init];
    _carousel.frame = CGRectMake(0, 200, self.view.bounds.size.width, self.view.bounds.size.width);
    [self.view addSubview:_carousel];
    
    _carousel.type = iCarouselTypeCoverFlow;
    _carousel.delegate = self;
    _carousel.dataSource = self;
}

#pragma --
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return _images.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable ReflectionView *)view {
    UIImageView *imageView = nil;
    //create new view if no view is available for recycling
    if (!view){
        //set up reflection view
        view = [[ReflectionView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 200.0f)];
        
        //set up content
        imageView = [[UIImageView alloc] initWithFrame:view.bounds];
        imageView.tag = 1;
        [view addSubview:imageView];
    } else {
        imageView = (UIImageView *)[view viewWithTag:1];
    }
    
    //set label
    imageView.image = _images[index];
    
    //update reflection
    //this step is expensive, so if you don't need
    //unique reflections for each item, don't do this
    //and you'll get much smoother peformance
    [view refresh];
    
    return view;
}

- (NSInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel {
    return _images.count > 3 ? 0 : 3 - _images.count;
}

- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(nullable ReflectionView *)view {
    UIImageView *imageView = nil;
    //create new view if no view is available for recycling
    if (!view){
        //set up reflection view
        view = [[ReflectionView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 200.0f)];
        
        //set up content
        imageView = [[UIImageView alloc] initWithFrame:view.bounds];
        imageView.tag = 9527;
        [view addSubview:imageView];
    } else {
        imageView = (UIImageView *)[view viewWithTag:9527];
    }
    
    //set label
    imageView.image = _placeholderImage;
    
    //update reflection
    //this step is expensive, so if you don't need
    //unique reflections for each item, don't do this
    //and you'll get much smoother peformance
    [view refresh];
    
    return view;
}

- (CATransform3D)carousel:(__unused iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform {
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0.0, 1.0, 0.0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * _carousel.itemWidth);
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    //customize carousel display
    switch (option) {
        case iCarouselOptionWrap: {
            //normally you would hard-code this to YES or NO
            return YES;
        }
        case iCarouselOptionSpacing: {
            //add a bit of spacing between the item views
            return value * 1.15;
        }
        case iCarouselOptionFadeMax: {
            if (_carousel.type == iCarouselTypeCustom) {
                //set opacity based on distance from camera
                return 0.0;
            }
            
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems: {
            return value;
        }
    }
}

#pragma mark -
#pragma mark iCarousel taps

- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"Tapped view number: %@", @(index));
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    NSLog(@"Index: %@", @(_carousel.currentItemIndex));
}

- (NSArray<UIImage *> *)loadImages {
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    
    NSString* imagesPath = [resourcePath stringByAppendingPathComponent:@"Assets/images"];
    
    NSMutableArray<UIImage *> *images = [NSMutableArray array];
    
    NSDirectoryEnumerator<NSString *> * enumerator = [[NSFileManager defaultManager] enumeratorAtPath:imagesPath];
    NSString* name = nil;
    while (name = [enumerator nextObject]) {
        UIImage * image = [UIImage imageWithContentsOfFile:[imagesPath stringByAppendingPathComponent:name]];
        if (image) {
            [images addObject:image];
        }
    }
    
    NSString* p = [resourcePath stringByAppendingPathComponent:@"Assets/placeholders/AlbumCover@3x.png"];
    
    _placeholderImage = [UIImage imageWithContentsOfFile:p];
    
    
    return images;
}

@end
