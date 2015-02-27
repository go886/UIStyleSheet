//
//  UIStyle.h
//  test_CSS
//
//  Created by go886 on 14-9-20.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIStyleSheet : NSObject
+(instancetype)defaultStyleSheet;
+(void)setDefaultStyleSheet:(UIStyleSheet*)style;
+(NSDictionary*)createStyleSheetDocForClass:(Class)cls;
+(NSString*)styleSheetDocForClass:(Class)cls;
+(NSString*)styleSheetDoc;

+(instancetype)initWithString:(NSString*)string;
+(instancetype)initWithFile:(NSString*)fileName;

-(NSString*)getValue:(NSString*)key;
-(NSString*)valForKey:(NSString*)key obj:(id)obj;
-(NSDictionary*)titleTextAttributesWithSuffix:(NSString*)suffix;
-(UIImage*)gradientImage:(NSString*)key frame:(CGRect)frame;
@end



@interface UIView (styleSheet)
@property(nonatomic,strong) NSString* styleName;
@property(nonatomic,strong) UIStyleSheet* styleSheet;

-(void)applyStyleSheet:(UIStyleSheet*)style;
-(void)reapplyStyleSheet;
@end