##  BRPickerView组件说明

### 时间选择组件的使用
```
id showDateString = nil;
if ([showDateString isKindOfClass:[NSDate class]]) {
    showDateString = [NSDate dateWithString:showDateString];
}
if (!showDateString) {
    showDateString = [NSDate stringWithDate:[NSDate date]];
}
NSDate *sinceDate = [NSDate dateWithString:[NSString stringWithFormat:@"%ld0101080808",[NSDate date].year - 10] format:@"yyyyMMddHHmmss"];
[BRDatePickerView showDatePickerWithTitle:nil dateType:BRDatePickerModeYMD defaultSelValue:showDateString minDate:sinceDate maxDate:[NSDate date] isAutoSelect:NO themeColor:nil resultBlock:^(NSString *selectValue) {
    NSLog(@"%@", selectValue);
}];
```

### StringPicker组件的使用
```
NSArray *dataSourceArray = @[@"1", @"2", @"3"];
[BRStringPickerView showStringPickerWithTitle:nil dataSource:dataSourceArray defaultSelValue:nil isAutoSelect:NO themeColor:nil resultBlock:^(id selectValue) {
    NSLog(@"%@",selectValue);
} cancelBlock:^{
}];

```

### AddressPickerView组件的使用
```
[BRAddressPickerView showAddressPickerWithDefaultSelected:@[@"浙江省", @"杭州市", @"西湖区"] resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
    NSLog(@"%@-%@-%@", province.name, city.name, area.name);
}];
```
