//
//  WikiCollectionViewCell.m
//  TrailMix
//
//  Created by Henry Chan on 8/7/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//

#import "WikiCollectionViewCell.h"
#import "WikiAPIClient.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface WikiCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation WikiCollectionViewCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self commonInit];
        
    }
    
    return self;
    
}
//
//- (instancetype)initWithFrame:(CGRect)frame {
//    
//    self = [super initWithFrame:frame];
//    
//    if (self) {
//        
//        [self commonInit];
//        
//    }
//    
//    return self;
//    
//}

- (void) commonInit {
    
}

-(void)prepareForReuse {
    
    [super prepareForReuse];

    [self.imageView sd_cancelCurrentImageLoad];
}


- (void)setArticle:(WikiArticle *)article {
    
    _article = article;
    
    [self updateUI];
    
}

- (void) updateUI {
    
    self.imageView.clipsToBounds = YES;
    
    self.titleLabel.text = self.article.title;
    
    if (!self.article.image) {
        
        self.imageView.image = nil;
        
        WikiArticle *article = self.article;
        
        [WikiAPIClient getArticleImageList:self.article.pageID completion:^(NSArray *imageList) {
            
            NSString *imageFileName = [imageList firstObject][@"title"];
            
            if (imageFileName) {
                
                [WikiAPIClient getArticleImageURL:imageFileName completion:^(NSURL *imageURL) {
                    
//                    NSLog(@"%@, %@",self.article, article);
                    
                    // This check prevents the download of images if the cell isn't what is currently being displayed
                    if (self.article == article) { // we need to reference the previous article...
                        
                        [self.imageView sd_setImageWithURL:imageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            
                            
                            
                            if (image)
                            {
                                self.imageView.alpha = 0.0;

                                self.article.image = image;

                                [UIView animateWithDuration:0.5 animations:^{

                                    self.imageView.alpha = 1.0;
                                    
                                }];
                            }
                            
                            
                        }];
                    }
                    
                    
                    
                }];
                
            } else {
                
                NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/staticmap?center=%f,%f&zoom=17&size=400x400&maptype=terrain&markers=color:red%%7C%f,%f", self.article.coordinate.latitude, self.article.coordinate.longitude,self.article.coordinate.latitude, self.article.coordinate.longitude];
                
                
                //                NSLog(@"%@",urlString);
                NSURL *imageURL = [NSURL URLWithString: urlString];
                
                [self.imageView sd_setImageWithURL:imageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    NSLog(@"%@",error);
                    self.article.image = image;
                    
                }];
                
            }
            
            
        }];
        
    } else {
        
        self.imageView.image = self.article.image;
        
    }
    
    
}

@end
