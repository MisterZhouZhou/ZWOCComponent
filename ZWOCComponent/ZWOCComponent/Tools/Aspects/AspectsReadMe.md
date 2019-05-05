##  Aspects组件的使用

### Aspects的使用方式
```
+ (void)load{
static dispatch_once_t onceToken;
dispatch_once(&onceToken, ^{

    [self aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo>aspectInfo){
        [self viewDidLoad:[aspectInfo instance]];
    } error:nil];
});
}

+ (void)viewDidLoad:(UIViewController *)viewController{
    NSLog(@"[%@ viewDidLoad]", [viewController class]);
}
```

