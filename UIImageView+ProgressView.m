//
//  UIImageView+ProgressView.m
//
//  Created by Kevin Renskers on 07-06-13.
//  Copyright (c) 2013 Kevin Renskers. All rights reserved.
//

@import SDWebImage;

#import "UIImageView+ProgressView.h"

#define TAG_PROGRESS_VIEW 149462

@implementation UIImageView (ProgressView)

- (void)addProgressView:(UIProgressView *)progressView {
    UIProgressView *existingProgressView = (UIProgressView *)[self viewWithTag:TAG_PROGRESS_VIEW];
    if (!existingProgressView) {
        if (!progressView) {
            progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        }

        progressView.tag = TAG_PROGRESS_VIEW;
        progressView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;

        double width = progressView.frame.size.width;
        double height = progressView.frame.size.height;
        double x = (self.frame.size.width / 2.0) - width/2;
        double y = (self.frame.size.height / 2.0) - height/2;
        progressView.frame = CGRectMake(x, y, width, height);

        [self addSubview:progressView];
    }
}

- (void)updateProgress:(CGFloat)progress {
    UIProgressView *progressView = (UIProgressView *)[self viewWithTag:TAG_PROGRESS_VIEW];
    if (progressView) {
        progressView.progress = (float)progress;
    }
}

- (void)removeProgressView {
    UIProgressView *progressView = (UIProgressView *)[self viewWithTag:TAG_PROGRESS_VIEW];
    if (progressView) {
        [progressView removeFromSuperview];
    }
}

- (void)sd_setImageWithURL:(NSURL *)url usingProgressView:(UIProgressView *)progressView {
    [self sd_setImageWithURL:url placeholderImage:nil options:(SDWebImageOptions)0 progress:nil completed:nil usingProgressView:progressView];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder usingProgressView:(UIProgressView *)progressView {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:(SDWebImageOptions)0 progress:nil completed:nil usingProgressView:progressView];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options usingProgressView:(UIProgressView *)progressView{
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil usingProgressView:progressView];
}

- (void)sd_setImageWithURL:(NSURL *)url completed:(SDExternalCompletionBlock)completedBlock usingProgressView:(UIProgressView *)progressView {
    [self sd_setImageWithURL:url placeholderImage:nil options:(SDWebImageOptions)0 progress:nil completed:completedBlock usingProgressView:progressView];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDExternalCompletionBlock)completedBlock usingProgressView:(UIProgressView *)progressView {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:(SDWebImageOptions)0 progress:nil completed:completedBlock usingProgressView:progressView];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDExternalCompletionBlock)completedBlock usingProgressView:(UIProgressView *)progressView {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock usingProgressView:progressView];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDExternalCompletionBlock)completedBlock usingProgressView:(UIProgressView *)progressView {
    [self addProgressView:progressView];
    
    __weak typeof(self) weakSelf = self;

    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        CGFloat progress = ((CGFloat)receivedSize / (CGFloat)expectedSize);
        dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf updateProgress:progress];
        });

        if (progressBlock) {
            progressBlock(receivedSize, expectedSize, targetURL);
        }
    }
    completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [weakSelf removeProgressView];
        if (completedBlock) {
            completedBlock(image, error, cacheType, imageURL);
        }
    }];
}

@end
