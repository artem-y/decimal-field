# DecimalField
Text field that filters and manages decimal input.  

## Usage
To use `DecimalField` in an iOS target (given it has been added to this target), it needs to be imported like this:
```swift
import DecimalField
```
Then it can be added and used as a usual text field, programmatically:
```swift
let decimalField = DecimalField()
view.addSubview(decimalField)
```
or from `.xib`/`.storyboard` file:
```swift
@IBOutlet weak var decimalField!
```
The implementation of `DecimalField` does not rely on its `delegate` so feel free to assign and use it if necessary.

## Installation
### Connecting to Xcode project:
1. `DecimalField` can be connected to your Xcode project using Swift Package Manager.  
To do it, go to `File` > `Add Packages...` in Xcode menu.  
2. In the window that pops up, paste the link to this repository from GitHub clone (`Code`) button.  
3. Select a dependency rule. Exact version is preferred to prevent pulling in unwanted changes.
4. Press `Add Package` button.
5. Add `DecimalField` dependency to targets where you need to import it. To do this, open `General` pane for each such target, scroll to find `Frameworks and Libraries` section, press plus (`+`) button, select `DecimalField` in the list that pops up and press `Add`.  

_Please Note: This process might differ slightly in different versions of Xcode. Please let me know if you found that any of these steps need correction._

## Licence
MIT (see [LICENSE](LICENSE))
