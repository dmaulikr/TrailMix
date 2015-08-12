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
    
    self.imageView.image = nil;
    
    WikiArticle *article = self.article;
    
    if (!self.article.imageURL) {
        
        [WikiAPIClient getArticleImageURL:self.article.pageID completion:^(NSURL *imageURL) {
            
            if (self.article == article) {
                
                if (imageURL) {
                    
                    self.article.imageURL = imageURL;
                    
                    [self.imageView sd_setImageWithURL:imageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        
                    }];
                    
                } else {
                    
                    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/staticmap?center=%f,%f&zoom=17&size=400x400&maptype=terrain&markers=color:red%%7C%f,%f", self.article.coordinate.latitude, self.article.coordinate.longitude,self.article.coordinate.latitude, self.article.coordinate.longitude];
                    
                    NSURL *googleMapImageURL = [NSURL URLWithString: urlString];
                    
                    self.article.imageURL = googleMapImageURL;
                    
                    [self.imageView sd_setImageWithURL:googleMapImageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        
                        NSLog(@"%@",error);
                        
                        self.article.imageURL = imageURL;
                        
                    }];
                    
                }
                
            } 
            
            
        }];
        
    
    } else {
        
        [self.imageView sd_setImageWithURL:self.article.imageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
    }

    
    
}

@end
