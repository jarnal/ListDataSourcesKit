# ListDataSourcesKit

Framework allowing to remove data source boilerplate for UITableView and UICollectionView.

💡 The original idea is not mine, it's from [Jesse Squires](https://github.com/jessesquires).

You can find the base that I used here [https://github.com/jessesquires/JSQDataSourcesKit](https://github.com/jessesquires/JSQDataSourcesKit).

Some parts of this framework are from this bundle, the implementation, on the other hand, is different.

## ⬇️ Installation

### Cocoapods

Add my personal repo to your Podfile:

```ruby
source 'https://github.com/jarnal/PodsRepository.git'
```

Add the following line to your Podfile::

```ruby
pod "ListDataSourcesKit"
```

Soon il will be directly available in cocoapods repo.

## 🔎 About

As an iOS Developer, you spend a lot of time configuring your `UITableView` for each of your screens.

For that, you need to define a `UITableViewDataSource` and `UITableViewDelegate`.

It seems legit to have a particular delegate for each screen, you can't handle events on all `UITableViews` the same way.

But regarding data source, you always return the informations contained in a list of data and create a `UITableViewCell` that you dequeue and configure.

This framework was designed to avoid all the data source part boilerplate.

Follow along to see how it works.

## 📲 Example

You can see the implementation of the framework for different types of data containers inside example `ListDataSourcesKitExample`.

You will find an implementation to use it with:

* Array
* CoreData
* Realm

Enjoy 🎉 !

## 🔦 How does it work ?

### Array

#### 🚧 Implementation
Lets assume that you want to use a simple array to populate your UITableView.

You have to subclass `ArrayEntityDataHandler` with:

* The type of 'DataListView' (UITableView or UICollectionView)
* The model of data
* The cell that will be rendered

Let's see a complete example:

```swift

// User Model
class User {
    
    var id: String!
    var firstName: String!
    var lastName: String!
    var age: Int?
    
    var fullName: String {
        return firstName
    }
}

// User cell viewmodel
struct UserCellViewModel {

    var fullName: String
}

// User cell
class UserCell: UITableViewCell, ConfigurableNibReusableCell {
    
    typealias Model = UserCellViewModel
    
    @IBOutlet weak var fullNameLabel: UILabel!
    
    // Mandatory for ConfigurableNibReusableCell
    func configure(withModel model: UserCellViewModel) {
        self.fullNameLabel.text = model.fullName
    }
}

/// User data source using ArrayEntityDataHandler
class UserArrayEntityHandler: ArrayEntityDataHandler<UITableView, User, UserCell> {
    
    // Mandatory for EntityDataHandler
    override func buildViewModel(withEntity entity: RealmUser) -> UserCellViewModel {
        return UserCellViewModel(fullName: entity.fullName)
    }
}
```

⚠️ After that, don't forget to create your cell inside your storyboard and to add an `Identifier` with the same name of cell class (here UserCell).

At this point, we have all parts needed to populate our `UITableView`:

```swift

class MyViewController: UIViewController {
    
   @IBOutlet weak var tableView: UITableView!
  
  	var arrayDataHandler: UserArrayEntityHandler!
  
   override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
       populateTableView()
   }
    
   func populateTableView() {
        
       let user1 = User()
       user1.firstName = "John"
       user1.lastName = "Doe"

       let user2 = User()
       user2.firstName = "Peter"
       user2.lastName = "Pan"
        
       let data = [user1, user2]
       arrayDataHandler = UserArrayEntityHandler(forTableView: self.tableView, withData: data)
   }

}
```

### CoreData

#### 🚧 Implementation

Let's see an example using CoreData.

We keep the same model (User), viewmodel (UserCellViewModel) and cell (UserCell).

```swift

class UserCoreDataDataHandler<ListDataView: CellParentViewProtocol, DataCellView: ConfigurableNibReusableCell>: CoreDataEntityDataHandler<ListDataView, User, DataCellView> {
    
    // You can set sortDescriptor from outside or override it like this if it's not going to change
    override var sortDescriptors: [NSSortDescriptor]? {
        get { return [NSSortDescriptor(key: #keyPath(User.firstname), ascending: true)] }
        set { /*🔴*/ }
    }
    
    override func buildViewModel(withEntity entity: User) -> DataCellView.Model {
   		return UserCellViewModel(fullName: entity.fullName) as! DataCellView.Model
    }
    
}
```

💡 Here the implementation uses generics, so with the same `EntityDataHandler` you can configure a `UITableView` or `UICollectionView`.

At this point, we have all parts needed to populate our `UITableView`:

```swift
class MyViewController: UIViewController {
    
   @IBOutlet weak var tableView: UITableView!
  	
  	var coreDataHander: UserCoreDataDataHandler<UITableView, UserCell>!
  	
  	// Managed object context containing model data
	var myManagedObjectContext: NSManagedObjectContext!
  	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		populateTableView()
	}
    
	func populateTableView() {
		coreDataHander = UserCoreDataDataHandler(forTableView: self.tableView, managedObjectContext: myManagedObjectContext)
	}
}
```

#### 👂 Events

For `CoreDataEntityDataHandler` you can receive events on what's going on inside database:
 
```swift
public var willChangeContent: BridgedFetchedResultsDelegate.WillChangeContentHandler?
public var didChangeSection: BridgedFetchedResultsDelegate.DidChangeSectionHandler?
public var didChangeObject: BridgedFetchedResultsDelegate.DidChangeObjectHandler?
public var didChangeContent: BridgedFetchedResultsDelegate.DidChangeContentHandler?
```

Those are the events that you can observe, to do so, you juste need to set the closure when creating dataHandler:

```swift
func populateTableView() {

  coreDataHander = UserCoreDataDataHandler(forTableView: self.tableView, managedObjectContext: DataCoordinator.shared.container.viewContext)
  coreDataHander.didChangeContent = { [weak self] (controller) in
    // Custom logic
  }
  coreDataHander.didChangeObject = { [weak self] (controller, object, indexPath, changeType, newIndexPath) in
    // Custom logic
  }
}
```
You can react to changes in the best way for you app 👍

### Realm and yours

In the example you will find another implementation for Realm database.

It's not present directly in framework because Realm pod is quite heavy, if you really need it, import implementation from example and add

```swift
pod 'RealmSwift'
```
to your podfile.

## 💅 Customize

We saw previously the different implementations that are ready to use.

Now it's up to you to implement it for another need that you have !

## 📄 What's next ?

- ❌ Testing
- ❌ UICollection configuration for all implementations

## 🗣 Discussion

If you have a suggestion or any ideas to improve this project, email me at jonathan.arnal89@gmail.com.