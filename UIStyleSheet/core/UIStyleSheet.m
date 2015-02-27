//
//  UIStyle.m
//  test_CSS
//
//  Created by go886 on 14-9-20.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import "UIStyleSheet.h"
#import <objc/runtime.h>
#import "UIStyleSheetConverter.h"
#import "UIRenderer.h"
#import "SkinMgr.h"

NSString* trim(NSString* str) {
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
NSMutableDictionary* parserItem(NSString* str) {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    NSArray* lines = [str componentsSeparatedByString:@";"];
    for (NSString* line in lines) {
        NSArray* keyvalue = [line componentsSeparatedByString:@":"];
        if (2 == keyvalue.count) {
            [dict setObject:trim(keyvalue[1]) forKey:trim(keyvalue[0])];
        }
    }
    return dict;
}
NSArray* parserKeys(NSString* str) {
    NSMutableArray* keys = [NSMutableArray array];
    for (NSString* s in [str componentsSeparatedByString:@","]) {
        NSString* key = trim(s);
        if (key && key.length) {
            [keys addObject:key];
        }
    }
    return keys;
}
/**/
NSString* removeComment(NSString* str) {
    NSError* err = nil;
    NSRegularExpression* re = [NSRegularExpression regularExpressionWithPattern:@"/\\*.*?\\*/"
                                                                        options:NSRegularExpressionCaseInsensitive|NSRegularExpressionAllowCommentsAndWhitespace|NSRegularExpressionDotMatchesLineSeparators
                                                                          error:&err];
    if (re && !err && str && str.length) {
        NSArray* match = [re matchesInString:str options:NSMatchingReportCompletion range:NSMakeRange(0, str.length)];
        if (match.count) {
            for (NSTextCheckingResult* r in [match reverseObjectEnumerator]) {
                if (1 == r.numberOfRanges) {
                    str = [str stringByReplacingCharactersInRange:[r rangeAtIndex:0] withString:@""];
                }else {
                    assert(false);
                }
            }
        }
    }
    return trim(str);
}
NSMutableDictionary* css_parser(NSString* str) {
    str = removeComment(str);
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    NSError* err = nil;
    NSRegularExpression* re = [NSRegularExpression regularExpressionWithPattern:@"(.*?)\\{(.*?)\\}"
                                                                        options:NSRegularExpressionCaseInsensitive|NSRegularExpressionAllowCommentsAndWhitespace|NSRegularExpressionDotMatchesLineSeparators
                                                                          error:&err];
    if (re && !err && str && str.length) {
        NSArray* match = [re matchesInString:str options:NSMatchingReportCompletion range:NSMakeRange(0, str.length)];
        if (match.count) {
            for (NSTextCheckingResult* r in match) {
                if (3 == [r numberOfRanges]) {
                    NSArray* keys = parserKeys([str substringWithRange:[r rangeAtIndex:1]]);
                    NSDictionary* values = parserItem([str substringWithRange:[r rangeAtIndex:2]]);
                    for (NSString* key in keys) {
                        assert(![result objectForKey:key]);
                        [result setObject:values forKey:key];
                    }
                }
            }
        }
    }
    
    return result;
}

NSDictionary* systemParams() {
    NSMutableDictionary* map = [NSMutableDictionary dictionary];
    map[@"@UIScreen-width"] = [NSString stringWithFormat:@"%f", [UIScreen mainScreen].bounds.size.width];
    map[@"@UIScreen-height"] = [NSString stringWithFormat:@"%f", [UIScreen mainScreen].bounds.size.height];
    map[@"@UIFrame-width"] = [NSString stringWithFormat:@"%f", [UIScreen mainScreen].applicationFrame.size.width];
    map[@"@UIFrame-height"] = [NSString stringWithFormat:@"%f", [UIScreen mainScreen].applicationFrame.size.height];
    
    return map;
}

NSString* css_format(NSString* str) {
    NSError* err = nil;
    NSRegularExpression* re = [NSRegularExpression regularExpressionWithPattern:@"^@(.*?):(.*?);"
                                                                        options:NSRegularExpressionCaseInsensitive|NSRegularExpressionAnchorsMatchLines
                                                                          error:&err];
    if (re && !err && str && str.length) {
        NSArray* match = [re matchesInString:str options:NSMatchingReportCompletion range:NSMakeRange(0, str.length)];
        if (match.count) {
            NSMutableDictionary* items = [NSMutableDictionary dictionary];
            for (NSTextCheckingResult* r in match) {
                if (3 == r.numberOfRanges) {
                    NSString* key = [str substringWithRange:[r rangeAtIndex:0]];
                    NSRange rng = [r rangeAtIndex:1];
                    rng.location -= 1;
                    rng.length += 1;
                    NSString* value = trim([str substringWithRange:rng]);
                    NSString* value2 = [str substringWithRange:[r rangeAtIndex:2]];
                    [items setObject:@[value, value2] forKey:key];
                }
            }
            
            for (NSString* key in [items allKeys]) {
                str = [str stringByReplacingOccurrencesOfString:key withString:@""];
            }
            
            for (NSString* key in [items allKeys]) {
                NSArray* info = items[key];
                str = [str stringByReplacingOccurrencesOfString:info[0] withString:info[1]];
            }
        }
    }
    
    
    NSDictionary* params = systemParams();
    for (NSString* key in params) {
        str =  [str stringByReplacingOccurrencesOfString:key withString:params[key]];
    }
    return str;
}


NSString* css_parser_include(NSString* str, NSString* curDir, NSMutableSet* includeSet) {
    BOOL isRoot = FALSE;
    if (!includeSet) {
        isRoot = TRUE;
        includeSet = [NSMutableSet set];
    }
    NSError* err = nil;
    NSRegularExpression* re = [NSRegularExpression regularExpressionWithPattern:@"\\$include:\"(.*?)\";"
                                                                        options:NSRegularExpressionCaseInsensitive|NSRegularExpressionAllowCommentsAndWhitespace|NSRegularExpressionDotMatchesLineSeparators
                                                                          error:&err];
    if (re && !err && str && str.length) {
        NSArray* match = [re matchesInString:str options:NSMatchingReportCompletion range:NSMakeRange(0, str.length)];
        if (match.count) {
            NSMutableArray* items = [NSMutableArray array];
            for (NSTextCheckingResult* r in match) {
                if (2 == r.numberOfRanges) {
                    NSString* key = [str substringWithRange:[r rangeAtIndex:0]];
                    NSString* skinName = [str substringWithRange:[r rangeAtIndex:1]];
                    [items addObject:@{@"key":key, @"skin":skinName}];
                }
            }
            
            for (NSDictionary* info in items) {
                NSString* key = info[@"key"];
                NSString* skinName = info[@"skin"];
                NSString* fullSkinName = [curDir stringByAppendingPathComponent:skinName];
                NSString* data;
                if (![includeSet containsObject:fullSkinName]) {
                    [includeSet addObject:fullSkinName];
                    data = [NSString stringWithContentsOfFile:fullSkinName
                                                     encoding:NSUTF8StringEncoding
                                                        error:nil];
                    
                    data = css_parser_include(data, curDir, includeSet);
                }
                str = [str stringByReplacingOccurrencesOfString:key withString:(data ? data : @"")];
            }
        }
    }
    
    return (!isRoot) ? str : [str stringByReplacingOccurrencesOfString:@"$skin" withString:curDir];
}
////////
@interface UIStyleSheetDoc : UIStyleSheet
@property(nonatomic,strong)NSMutableDictionary* doc;
@end

@implementation UIStyleSheetDoc
-(NSString*)getValue:(NSString *)key {
    NSString* value = [super getValue:key];
    [self.doc setObject:(value ? value : @" ") forKey:key];
    return value;
}
@end

/////////
UIStyleSheet* __defaultStyle = nil;
@implementation UIStyleSheet {
    NSDictionary* _styleData;
    id _obj;
}
+(instancetype)defaultStyleSheet {
    return __defaultStyle;
}
+(void)setDefaultStyleSheet:(UIStyleSheet*)style {
    __defaultStyle = style;
    
    {
        Class cls = [UIBarButtonItem class];
        id lastObj = style.currentObj;
        [style setCurrentObj:cls];
        
        NSDictionary* titleTextAttributes = [style titleTextAttributesWithSuffix:nil];
        if ([[titleTextAttributes allKeys] count] > 0) {
            [[cls appearance] setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        }
        
        NSString* value = nil;
        value = [style getValue:@"background-tint-color"];
        if (value) [[cls appearance] setTintColor:[UIStyleSheetConverter toColor:value]];
        
        
        typedef struct {
            __unsafe_unretained NSString* key;
            NSUInteger st;
        }ItemInfo;
        
        {
            ItemInfo infos[] = {
                {@"background-image",UIControlStateNormal},
                {@"background-image-highlighted", UIControlStateHighlighted},
                 {@"background-image-selected", UIControlStateSelected},
                {@"background-image-disabled", UIControlStateDisabled},
            };
            
            for (int i=0; i<sizeof(infos)/sizeof(infos[0]); ++i) {
                value = [style getValue:infos[i].key];
                if (value) [[cls appearance] setBackButtonBackgroundImage:[UIStyleSheetConverter toImage:value] forState:infos[i].st barMetrics:UIBarMetricsDefault];
            }
        }
        
        [style setCurrentObj:lastObj];
    }
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    for (UIView* view in window.subviews) {
        [view removeFromSuperview];
        [window addSubview:view];
    }
    [window makeKeyWindow];
}
+(NSDictionary*)createStyleSheetDocForClass:(Class)cls {
    NSMutableDictionary* doc = [NSMutableDictionary dictionary];
    UIView* v = [[cls alloc] init];
    if (v) {
        UIStyleSheetDoc* style = [UIStyleSheetDoc new];
        style.doc = doc;
        [v applyStyleSheet:style];
        style.doc = nil;
    }
    
    return doc;
}
+(NSString*)styleSheetDocForClass:(Class)cls {
    NSMutableString* str = [NSMutableString string];
    NSDictionary* doc = [[self class] createStyleSheetDocForClass:cls];
    [str appendFormat:@"%@ {\n", NSStringFromClass(cls)];
    NSArray* keys = [[doc allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSString* key in keys) {
        [str appendFormat:@"  %@: %@;\n", key, doc[key]];
    }
    [str appendString:@"}"];
    return str;
}
+(NSString*)styleSheetDoc {
    Class cls[] = {
        [UIView class],
        [UILabel class],
        [UIButton class],
        [UISearchBar class],
        [UINavigationBar class],
        [UIToolbar class],
        [UIProgressView class],
        [UISegmentedControl class],
        [UISlider class],
        [UISwitch class],
        [UITableView class],
        [UITextField class],
        [UITabBar class],
        [UIActivityIndicatorView class],
        [UIPageControl class],
        [UIImageView class],
        [UIScrollView class],
        [UITextView class],
        [UITableViewCell class]
    };
    
    NSMutableString* docstring = [NSMutableString string];
    for (NSInteger i =0; i<sizeof(cls)/sizeof(cls[0]); ++i) {
        [docstring appendFormat:@"%@\n\n", [self styleSheetDocForClass:cls[i]]];
    }
    
    return docstring;
}
+(instancetype)initWithFile:(NSString *)fileName {
    NSString* data = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
    NSString* curDir = [fileName stringByDeletingLastPathComponent];
    return [self initWithString:css_parser_include(data, curDir, nil)];
}
+(instancetype)initWithString:(NSString *)string {
    return [[self alloc] initWithMap:css_parser(css_format(string))];
}
-(instancetype)initWithMap:(NSDictionary*)map {
    self = [self init];
    if (self) {
        _styleData = map;
    }
    
    return self;
}

-(NSString*)description {
    return [NSString stringWithFormat:@"class:%@ css:%@", NSStringFromClass(self.class), _styleData];
}
-(id)currentObj {
    return _obj;
}

-(void)setCurrentObj:(id)obj {
    _obj = obj;
}
-(NSString*)valForKey:(NSString*)key obj:(id)obj {
    Class cls = [obj class];
    NSString* selfClass = NSStringFromClass(cls);
    NSString* superviewClass;
    NSString* objName;
    if ([obj isKindOfClass:[UIView class]]) {
        superviewClass = NSStringFromClass([obj superview].class);
        objName = [(UIView*)obj styleName];
    }
    
    NSString* oldSelfClass = selfClass;
    NSString* oldSuperViewClass = superviewClass;
    
    NSString* result;
    NSString* styleKey;
    BOOL bEnd = FALSE;
    do {
        if (objName) {
            if (superviewClass) {
                styleKey = [NSString stringWithFormat:@"%@ %@#%@", superviewClass, selfClass, objName];
                superviewClass = nil;
            }else if (selfClass) {
                styleKey = [NSString stringWithFormat:@"%@#%@", selfClass, objName];
                selfClass = nil;
            }else {
                styleKey = [NSString stringWithFormat:@"#%@", objName];
                objName = nil;
                selfClass = oldSelfClass;//NSStringFromClass(_curCls);
                superviewClass = oldSuperViewClass;//NSStringFromClass(_curCls);
            }
        }else {
            if(selfClass) {
                styleKey = [NSString stringWithFormat:@"%@", selfClass];
                selfClass = nil;
            }else {
                styleKey = @"*";
                bEnd = YES;
            }
        }
        
        NSDictionary* info = [_styleData objectForKey:styleKey];
        if (info && [info isKindOfClass:[NSDictionary class]]) {
            result = [info objectForKey:key];
        }
    } while (!result && styleKey && !bEnd);
    
    return (result && result.length) ? result : nil;
}
-(NSString*)getValue:(NSString *)key {
    return [self valForKey:key obj:_obj];
}
-(NSDictionary*)titleTextAttributesWithSuffix:(NSString*)suffix {
    NSMutableDictionary *titleTextAttributes = [NSMutableDictionary dictionary];
    
    NSString *fontColorSelector = [UIStyleSheet selector:@"font-color" withSuffix:suffix];
    NSString *textShadowColorSelector = [UIStyleSheet selector:@"text-shadow-color" withSuffix:suffix];
    NSString *textShadowOffsetSelector = [UIStyleSheet selector:@"text-shadow-offset" withSuffix:suffix];
    
    
    NSString* value = nil;
    value = [self getValue:@"font"];
    if (value) {
        UIFont* font = [UIStyleSheetConverter toFont:value];
        
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
        [titleTextAttributes setObject:font forKey:NSFontAttributeName];
#else
        [titleTextAttributes setObject:font forKey:UITextAttributeFont];
#endif
    }
    
    value = [self getValue:fontColorSelector];
    if (value) {
        UIColor* color = [UIStyleSheetConverter toColor:value];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
        [titleTextAttributes setObject:color forKey:NSForegroundColorAttributeName];
#else
        [titleTextAttributes setObject:color forKey:UITextAttributeTextColor];
#endif
    }
    
    
    value = [self getValue:textShadowColorSelector];
    NSString* value2 = [self getValue:textShadowOffsetSelector];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    if (value || value2) {
        NSShadow *shadow = [NSShadow new];

        if (value) shadow.shadowColor = [UIStyleSheetConverter toColor:value];
        if (value2) shadow.shadowOffset = [UIStyleSheetConverter toSize:value2];
        
        [titleTextAttributes setObject:shadow forKey:NSShadowAttributeName];
    }
#else
    if (value) [titleTextAttributes setObject:[UIStyleSheetConverter toColor:value] forKey:UITextAttributeTextShadowColor];
    if (value2) [titleTextAttributes setObject:[NSValue valueWithUIOffset:[UIStyleSheetConverter toOffset:value2]] forKey:UITextAttributeTextShadowOffset];
#endif
    
    
    return titleTextAttributes;
}
+ (NSString*)selector:(NSString*)selector withSuffix:(NSString*)suffix {
    if (suffix)
        return [NSString stringWithFormat:@"%@-%@", selector, suffix];
    return selector;
}
-(UIImage*)gradientImage:(NSString*)key frame:(CGRect)frame {
    NSString* value1 = [self getValue:[NSString stringWithFormat:@"%@-top", key]];
    if (!value1) return nil;
    
    NSString* value2 = [self getValue:[NSString stringWithFormat:@"%@-bottom", key]];
    if (!value2) return nil;
    
    UIColor* cor1 = [UIStyleSheetConverter toColor:value1];
    UIColor* cor2 = [UIStyleSheetConverter toColor:value2];
    if (!cor1 || !cor2) return nil;
    
    return  [UIRenderer gradientImageWithTop:cor1 bottom:cor2 frame:frame];
}
@end

///////////////////////////////////
///////
static NSString* kStyleName;
static NSString* kStyleSheet;
static NSString* kStyleClass;

@implementation UIView (styleSheet)
#ifdef DEBUG
-(NSString*)styleClass {
    return objc_getAssociatedObject(self, &kStyleClass);
}
-(void)setStyleClass:(NSString *)styleClass {
    objc_setAssociatedObject(self,
                             &kStyleClass,
                             styleClass,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#endif

-(NSString*)styleName {
    return objc_getAssociatedObject(self, &kStyleName);
}
-(void)setStyleName:(NSString *)styleName {
    objc_setAssociatedObject(self,
                             &kStyleName,
                             styleName,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self reapplyStyleSheet];
}
-(UIStyleSheet*)styleSheet {
    return objc_getAssociatedObject(self, &kStyleSheet);
}
-(void)setStyleSheet:(UIStyleSheet *)styleSheet {
    objc_setAssociatedObject(self,
                             &kStyleSheet,
                             styleSheet,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (self.window && styleSheet) {
        [self applyUIForWindow:self.window];
    }
}
-(void)applyStyleSheet:(UIStyleSheet *)style {
    if ([self isKindOfClass:NSClassFromString(@"UIInputSetContainerView")]) {
        return;
    }
    NSString* value = nil;
    
    {
        CGRect frame = self.frame;
        BOOL bChanged = FALSE;
        value = [style getValue:@"x"];
        if (value) frame.origin.x = [UIStyleSheetConverter toFloat:value], bChanged = YES;
        
        value = [style getValue:@"y"];
        if (value) frame.origin.y = [UIStyleSheetConverter toFloat:value], bChanged = YES;
        
        value = [style getValue:@"width"];
        if (value) frame.size.width = [UIStyleSheetConverter toFloat:value], bChanged = YES;
        
        value = [style getValue:@"height"];
        if (value) frame.size.height = [UIStyleSheetConverter toFloat:value], bChanged = YES;
        
        if (bChanged) self.frame = frame;
        
        
        bChanged = FALSE;
        CGPoint center = self.center;
        value = [style getValue:@"center-x"];
        if (value) center.x = [UIStyleSheetConverter toFloat:value], bChanged = YES;
        
        value = [style getValue:@"center-y"];
        if (value) center.y = [UIStyleSheetConverter toFloat:value], bChanged = YES;
        
        if (bChanged) self.center = center;
        
    }
    
//    if ([self respondsToSelector:@selector(setFont:)]) {
//        value = [style getValue:@"font"];
//        if (value) [self setValue:[UIStyleSheetConverter toFont:value] forKey:@"font"];
//    }
//    
//    if ([self respondsToSelector:@selector(setTextColor:)]) {
//        value = [style getValue:@"text-color"];
//        if (value) [self setValue:[UIStyleSheetConverter toColor:value] forKey:@"text-color"];
//
//    }
    
    value = [style getValue:@"enabled"];
    if (value) self.userInteractionEnabled = [UIStyleSheetConverter toBoolean:value];
    
    value = [style getValue:@"alpha"];
    if (value) self.alpha = [UIStyleSheetConverter toFloat:value];
    
    value = [style getValue:@"opaque"];
    if (value) self.opaque = [UIStyleSheetConverter toBoolean:value];
    
    value = [style getValue:@"hidden"];
    if (value) self.hidden = [UIStyleSheetConverter toBoolean:value];
    
    value = [style getValue:@"clips"];
    if (value) self.clipsToBounds = [UIStyleSheetConverter toBoolean:value];
    
    value = [style getValue:@"content-mode"];
    if (value) self.contentMode = [UIStyleSheetConverter toViewContentMode:value];
    
    
    if ([self respondsToSelector:@selector(setTintColor:)]) {
        value = [style getValue:@"tint-color"];
        if (value) self.tintColor = [UIStyleSheetConverter toColor:value];
    }
    
    value = [style getValue:@"background-color"];
    if (value)  self.backgroundColor = [UIStyleSheetConverter toColor:value];
    else if ([self isKindOfClass:[UILabel class]]  && (!self.backgroundColor || [self.backgroundColor isEqual:[UIColor whiteColor]]))
        self.backgroundColor = [UIColor clearColor];

    
//    value = [style getValue:@"background-image"];
//    if (value) [self setBackgroundColor:[UIColor colorWithPatternImage:[UIStyleSheetConverter toImage:value]]];
    
    value = [style getValue:@"border-color"];
    if (value) [self.layer setBorderColor:[UIStyleSheetConverter toColor:value].CGColor];
    
    value = [style getValue:@"border-width"];
    if (value) [self.layer setBorderWidth:[UIStyleSheetConverter toFloat:value]];
    
    value = [style getValue:@"corner-radius"];
    if (value) [self.layer setCornerRadius:[UIStyleSheetConverter toFloat:value]];
    
    value = [style getValue:@"shadow-color"];
    if (value) [self.layer setShadowColor:[UIStyleSheetConverter toColor:value].CGColor];
    
    value = [style getValue:@"shadow-offset"];
    if (value) [self.layer setShadowOffset:[UIStyleSheetConverter toSize:value]];
    
    value = [style getValue:@"shadow-opacity"];
    if (value) [self.layer setShadowOpacity:[UIStyleSheetConverter toFloat:value]];
    
    value = [style getValue:@"shadow-radius"];
    if (value) [self.layer setShadowRadius:[UIStyleSheetConverter toFloat:value]];
    
    value = [style getValue:@"effect"];
    if (value) {
        UIBlurEffectStyle effectStyle = UIBlurEffectStyleLight;
        if ([value isEqualToString:@"Dark"])
            effectStyle = UIBlurEffectStyleDark;
        else if ([value isEqualToString:@"extra-light"])
            effectStyle = UIBlurEffectStyleExtraLight;
        
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:effectStyle];
        UIVisualEffectView *visualEffectView;
        for (UIView* v in self.subviews) {
            if (1023 == v.tag && [v isKindOfClass:[UIVisualEffectView class]]) {
                visualEffectView = (UIVisualEffectView*)v;
                break;
            }
        }
        if (!visualEffectView) {
            visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            visualEffectView.tag = 1023;
        }
        
        visualEffectView.frame = self.bounds;
        visualEffectView.userInteractionEnabled = FALSE;
        [self addSubview:visualEffectView];
        [self sendSubviewToBack:visualEffectView];
    }
    
    
    {
        value = [style getValue:@"accessibility-text"];
        if (value) [self setAccessibilityLabel:[UIStyleSheetConverter toString:value]];
        
        value = [style getValue:@"accessibility-hint"];
        if (value) [self setAccessibilityHint:[UIStyleSheetConverter toString:value]];
    }
    
    
}

-(void)reapplyStyleSheet {
    [self applyUIForWindow:self.window];
}

-(void)applyUIForWindow:(UIWindow *)window {
    if (window) {
#ifdef DEBUG
        NSString* cls = NSStringFromClass(self.class);
        NSString* styleClass = [self styleClass];
        if (!styleClass) [self setStyleClass:cls];
        if (styleClass && ![styleClass isEqualToString:cls]) {
            NSAssert(FALSE, @"applyUIForWindow double");
        }
#endif
        
        UIStyleSheet* style = self.styleSheet ? self.styleSheet : [UIStyleSheet defaultStyleSheet];
        if (style) {
            id lastObj = style.currentObj;
            [style setCurrentObj:self];
            [self applyStyleSheet:style];
            NSAssert(style.currentObj == self, @"obj is err");
            [style setCurrentObj:lastObj];
            if ([SkinMgr instance].enabledLogger) {
                ^ BOOL (UIView* view) {
                    CGRect frame = view.frame;
                    NSString* text = ([view respondsToSelector:@selector(text)] ? [(UILabel*)view text] : @"");
                    if ([view respondsToSelector:@selector(text)]) {
                        NSString* (*fun)(__strong id,SEL,...) = (NSString* (*)(__strong id, SEL, ...))(class_getMethodImplementation(view.class, @selector(text)));
                        text = fun(view, @selector(text));
                    }
                    NSLog(@"UIStyleSheet >> class:%@ superclass:%@ superviewclass:%@  \tframe<%.1f,%.1f,%.1f,%.1f>\ttext:%@ \tstylename:%@",
                          NSStringFromClass([view class]),
                          NSStringFromClass([view superclass]),
                          NSStringFromClass(view.superview.class),
                          frame.origin.x, frame.origin.y, frame.size.width, frame.size.height,
                          text,
                          view.styleName);
                    return YES;
                }(self);
            }
        }
    }
}
@end




