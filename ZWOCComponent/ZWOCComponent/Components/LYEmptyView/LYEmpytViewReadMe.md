##  LYEmptyView组件的使用

### UITableView的默认图使用方式
```
self.tableView.frame = self.view.bounds;
[self.view addSubview:self.tableView];
self.tableView.ly_emptyView = [CDDEmptView noDataEmptyWithImageString:@"person_icon" detailStr:@"暂无征信驳回/未提交数据"];
```

