##  ZWTextView使用说明
### 使用方式

```
ZWTextView *inputView = [[ZWTextView alloc]initWithFrame:CGRectMake(0, 100, 300, 40)];

inputView.font = [UIFont systemFontOfSize:18];
inputView.placeholder = @"CrabMan的测试文字";
inputView.cornerRadius = 4;
inputView.placeholderColor = [UIColor redColor];
//_inputView.placeholderFont = [UIFont systemFontOfSize:22];
// 设置文本框最大行数
inputView.textHeightChangeBlock = ^(NSString *text, CGFloat textHeight){
CGRect frame = inputView.frame;
frame.size.height = textHeight;
inputView.frame = frame;
};
//    inputView.maxNumberOfLines = 4;
[self.view addSubview:inputView];
```

