//
//  OrderTableViewController.m
//  Hello
//
//  Created by Derek Chou on 2015/12/7.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "OrderTableViewController.h"
#import "Common.h"
#import "AFNetworking.h"
#import "OrderCell.h"
#import "Order.h"
#import "User.h"
#import "Product.h"

@interface OrderTableViewController ()

@end

@implementation OrderTableViewController

- (void)loadOrderData:(NSString*)seq
{
  if (_orderArray == nil) {
    _orderArray = [NSMutableArray arrayWithCapacity:20];
  }
  
  NSString *url = [Common getSetting:@"Server URL"];
  NSString *urlString = [NSString stringWithFormat:@"%@%s", url, "order"];
  
  NSString *userType = [Common getSetting:@"User Type"];
  NSString *userID = [Common getSetting:@"User ID"];
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager GET:urlString parameters:@{@"type":userType, @"id":userID, @"seq":seq}
       success:^(AFHTTPRequestOperation *operation, id responseObj) {
         _orderArray = responseObj;
         [Order updateWithArray:_orderArray];
         self.currentOrders = [Order getCurrent];
         self.historyOrders = [Order getHistory];
         [self checkUserAndProduct];
//         [self.tableView reloadData];
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"loadOrderData Error: %@", error);
       }
   ];
}

- (AFHTTPRequestOperation*)loadUserByType:(NSString*)type AndID:(NSString*)userID {
  NSString *url = [Common getSetting:@"Server URL"];
  NSString *urlString = [NSString stringWithFormat:@"%@%s", url, "user"];
  
  NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET"
                              URLString:urlString parameters:@{@"type":type, @"id":userID} error: nil];
  
  AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  op.responseSerializer = [AFJSONResponseSerializer serializer];
  
  [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObj)
  {
    if ([responseObj isKindOfClass:[NSArray class]] && [responseObj count] > 0) {
      [User addWithDic:responseObj[0]];
    }
  }
  failure:^(AFHTTPRequestOperation *operation, NSError *error)
  {
    NSLog(@"loadUserByType Error: %@", error);
  }];
  
  return op;
}

- (AFHTTPRequestOperation*)loadProductByID:(NSString*)prodID {
  NSString *url = [Common getSetting:@"Server URL"];
  NSString *urlString = [NSString stringWithFormat:@"%@%s", url, "product/byProductID"];
  
  NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET"
                        URLString:urlString parameters:@{@"productID":prodID} error: nil];
  
  AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  op.responseSerializer = [AFJSONResponseSerializer serializer];
  
  [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObj)
  {
    if ([responseObj isKindOfClass:[NSArray class]] && [responseObj count] > 0) {
      [Product addWithDic:responseObj[0]];
    }
  }
  failure:^(AFHTTPRequestOperation *operation, NSError *error)
  {
    NSLog(@"loadProductByID Error: %@", error);
  }];
  
  return op;
}

- (void)checkUserAndProduct {
  NSMutableArray *opAry = [[NSMutableArray alloc]initWithCapacity:10];
  NSMutableDictionary *tmpUserDic = [NSMutableDictionary new];
  NSMutableDictionary *tmpProdDic = [NSMutableDictionary new];
  
  NSArray *orders;
  if (_tabTag == 0) {
    orders = self.currentOrders;
  } else
    orders = self.historyOrders;
  for (Order *order in orders) {
    //避免重複查詢相同的User
    NSArray *other = [Common getOtherSide:order];
    NSString *tmpKey = [NSString stringWithFormat:@"%@@%@", other[0], other[1]];
    if (![tmpUserDic valueForKey:tmpKey]) {
      [tmpUserDic setObject:@"" forKey:tmpKey];
      
      User *user = [User getByType:other[0] AndID:other[1]];
      if (user == nil) {
        AFHTTPRequestOperation* op = [self loadUserByType:other[0] AndID:other[1]];
        [opAry addObject:op];
      }
    }
    
    //避免重複查詢相同的Product
    if (![tmpProdDic valueForKey:order.productID]) {
      [tmpProdDic setObject:@"" forKey:order.productID];
      
      Product *prod = [Product getByID:order.productID];
      if (prod == nil) {
        AFHTTPRequestOperation* op = [self loadProductByID:order.productID];
        [opAry addObject:op];
      }
    }
    
  }
  
  NSArray *operations = [AFURLConnectionOperation batchOfRequestOperations:opAry
          progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations)
  {
    NSLog(@"%i of %i complete", numberOfFinishedOperations, totalNumberOfOperations);

  } completionBlock:^(NSArray *operations)
  {
    NSLog(@"All operations in batch complete");
    [self.tableView reloadData];
  }];
  [[NSOperationQueue mainQueue] addOperations:operations waitUntilFinished:NO];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  //避免第一個cell被tab bar擋住
  //UIEdgeInsets adjustForTabbarInsets = UIEdgeInsetsMake(CGRectGetHeight(self.tabBarController.tabBar.frame), 0, 0, 0);
  UIEdgeInsets adjustForTabbarInsets = UIEdgeInsetsMake(44, 0, 0, 0);
  self.tableView.contentInset = adjustForTabbarInsets;
  self.tableView.scrollIndicatorInsets = adjustForTabbarInsets;
  UITabBarItem *tab = self.tabBarController.tabBar.selectedItem;
  NSLog(@"%@", [NSString stringWithFormat:@"tab tag = %ld", (long)tab.tag]);
  self.tabTag = tab.tag;
  
  if (_tabTag == 0)
    [self loadOrderData:@"0"];
  else {
    self.historyOrders = [Order getHistory];
    [self checkUserAndProduct];
  }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (_tabTag == 0) {
    return [self.currentOrders count];
  }
  return [self.historyOrders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellID = @"OrderCell";
  
  //cell如不存在，則建立之
  OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (cell == nil) {
    cell = [[OrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
  }
  
  int row = indexPath.row;
  Order *order;
  if (_tabTag == 0)
    order = (Order*)self.currentOrders[row];
  else
    order = (Order*)self.historyOrders[row];
  
  NSArray *other = [Common getOtherSide:order];
  User *user = [User getByType:other[0] AndID:other[1]];
  Product *product = [Product getByID:order.productID];
  int userLevel = 0;
  cell.travelDateLabel.text = [NSString stringWithFormat:@"[%@]", order.travelDay];
  if (user != nil) {
    cell.userNameLabel.text = user.name;
    userLevel = [user.level integerValue];
  }
  if (product != nil) {
    cell.productTitleLabel.text = product.title;
    cell.productPriceLabel.text = [NSString stringWithFormat:@"%@ $%@", product.currency, product.price];
  }
  
  __weak OrderCell *weakCell = cell;
  //取得使用者頭像
  NSString *photoURL = [Common getPhotoURLByType:other[0] AndID:other[1]];
  NSString *photoFileName = [[photoURL componentsSeparatedByString:@"//"] lastObject];
  photoFileName = [photoFileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
  NSString *photoFullName = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), photoFileName];
  //check img exist
  BOOL photoExist = [[NSFileManager defaultManager] fileExistsAtPath:photoFullName];
  if(!photoExist){
    [Common downloadImage:photoURL ToBtn:weakCell.photoButton Cell:weakCell SavePath:photoFullName];
  } else {
    UIImage *img = [[UIImage alloc] initWithContentsOfFile:photoFullName];

    [weakCell.photoButton setImage:img forState:UIControlStateNormal];
    [weakCell setNeedsLayout];
  }
  //畫圓框
  [cell.photoButton drawCircleButton:[Common getUserLevelColor:userLevel]];
  
  //狀態圖示
  if (![order.cancelDT isEqualToString:@""])
    cell.statImage.image = [UIImage imageNamed:@"OrderCancel"];
  else if ([order.sellerConfirmDT isEqualToString:@""] && [order.buyerConfirmDT isEqualToString:@""])
    cell.statImage.image = [UIImage imageNamed:@"OrderNew"];
  else if (![order.sellerConfirmDT isEqualToString:@""] && ![order.buyerConfirmDT isEqualToString:@""])
    cell.statImage.image = [UIImage imageNamed:@"OrderOK"];
  else
    cell.statImage.image = [UIImage imageNamed:@"OrderWait"];
  
  return cell;
}


@end
