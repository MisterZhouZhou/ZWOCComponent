##  LimitPointTextField组件说明

### 小数点位数限制输入框的使用(整数位限制，小数点位数限制)
```
    LimitPointTextField *field = [[LimitPointTextField alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth-20, 40)];
    field.backgroundColor = [UIColor redColor];
    [self.view addSubview:field];

    LimitPointTextField *field2 = [[LimitPointTextField alloc]initWithFrame:CGRectMake(10, 60, KScreenWidth-20, 40)];
    field2.backgroundColor = [UIColor blueColor];
    field2.limitNumPoint = 3;
    [self.view addSubview:field2];
```

