// Copyright 2018-present 650 Industries. All rights reserved.

#import <EDUMViewManagerAdapter.h>

@interface EDUMViewManagerAdapter ()

@property EDUMViewManager *viewManager;

@end

@implementation EDUMViewManagerAdapter

- (instancetype)initWithViewManager:(EDUMViewManager *)viewManager
{
  if (self = [super init]) {
    _viewManager = viewManager;
  }
  return self;
}

- (NSArray<NSString *> *)supportedEvents
{
  return [_viewManager supportedEvents];
}

// This class is not used directly --- usually it's subclassed
// in runtime by EDUMNativeModulesProxy for each exported view manager.
// Each created class has different class name, conforming to convention.
// This way we can provide React Native with different RCTViewManagers
// returning different modules names.

+ (NSString *)moduleName
{
  return NSStringFromClass(self);
}

- (UIView *)view
{
  return [_viewManager view];
}

// The adapter multiplexes custom view properties in one "big object prop" that is passed here.

RCT_CUSTOM_VIEW_PROPERTY(proxiedProperties, NSDictionary, UIView)
{
  __weak EDUMViewManagerAdapter *weakSelf = self;
  [json enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
    __strong EDUMViewManagerAdapter *strongSelf = weakSelf;
    [strongSelf.viewManager updateProp:key withValue:obj onView:view];
  }];
}

@end
