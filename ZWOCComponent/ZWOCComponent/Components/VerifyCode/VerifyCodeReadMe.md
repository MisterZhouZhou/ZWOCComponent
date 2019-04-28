##  VerifyCode组件说明


### 基本使用方式

```
ZWVerifyCodeCursorView *code4View = [[ZWVerifyCodeCursorView alloc] initWithCount:4 margin:20];
code4View.frame = CGRectMake(20, 90, KScreenWidth-40, 40);
code4View.lineColor = [UIColor greenColor];
code4View.itemMargin = 10;
code4View.codeColor  = [UIColor blueColor];
code4View.codeFont   = [UIFont systemFontOfSize:20];
code4View.codeMode   = CodeMode_Border;
code4View.inputEndBlock = ^(NSString *code){
NSLog(@"%@", code);
};
[self.view addSubview:code4View];
```
