

#import "MEMenuViewController.h"
#import "UIViewController+ECSlidingViewController.h"


@interface MEMenuViewController ()
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) UINavigationController *transitionsNavigationController;
@end

@implementation MEMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // topViewController is the transitions navigation controller at this point.
    // It is initially set as a User Defined Runtime Attributes in storyboards.
    // We keep a reference to this instance so that we can go back to it without losing its state.
    self.transitionsNavigationController = (UINavigationController *)self.slidingViewController.topViewController;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - Properties

- (NSArray *)menuItems {
    if (_menuItems) return _menuItems;
    
    _menuItems = @[@"Inicio",@"Mapa de Lugares", @"Redes sociales"];
    
    return _menuItems;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString *menuItem = self.menuItems[indexPath.row];
    
    cell.textLabel.text = menuItem;
    cell.textLabel.textColor = [UIColor blackColor];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *menuItem = self.menuItems[indexPath.row];
    
    // This undoes the Zoom Transition's scale because it affects the other transitions.
    // You normally wouldn't need to do anything like this, but we're changing transitions
    // dynamically so everything needs to start in a consistent state.
    self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
    
            
  
    if ([menuItem isEqualToString:@"Inicio"]) {
        self.slidingViewController.topViewController = self.transitionsNavigationController;
    } else if ([menuItem isEqualToString:@"Mapa de Lugares"]) {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mapNavigationController"];
    }
    else if([menuItem isEqualToString:@"LogOut"]){
     
    }
    else if([menuItem isEqualToString:@"Redes sociales"]){
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"socialNavigationController"];
    }else if([menuItem isEqualToString:@"Información"]){
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"informationNavigationController"];
    }
    if(indexPath.row == 4)
    {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"configurationNavigationController"];

        
    }
    
    
    [self.slidingViewController resetTopViewAnimated:YES];
}

@end
