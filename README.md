# DecimalField
Lightweight implementation of a text field that filters and manages decimal input. It only allows integer or floating point numbers and a minus by default. It also includes behaviour like trimming extra zeros in a decimal number when editing ends, or clearing out the zero when editing begins etc.

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
@IBOutlet weak var decimalField: DecimalField!
```
The implementation of `DecimalField` does not rely on its `delegate`, so feel free to assign and use one if necessary.  
By default, only integer or decimal numbers and a minus are allowed as input. If you don't want to allow minus, set `allowsNegativeNumbers` to `false`. Filtering applies to input from both UI and code.

## Installation
### Connecting to Xcode project:
1. `DecimalField` can be connected to your Xcode project using Swift Package Manager.  
To do it, go to `File` > `Add Packages...` in Xcode menu.  
2. In the window that pops up, paste the link to this repository from GitHub clone (`Code`) button.  
3. Select a dependency rule. Exact version is preferred to prevent pulling in unwanted changes. You can find versions in the [Releases](https://github.com/artem-y/decimal-field/releases) section.
4. Press `Add Package` button.
5. Add `DecimalField` dependency to targets where you need to import it. To do this, open `General` pane for each such target, scroll to find `Frameworks and Libraries` section, press plus (`+`) button, select `DecimalField` in the list that pops up and press `Add`.  

_Please Note: This process might differ slightly in different versions of Xcode. Please let me know if you found that any of these steps need correction._

## Licence
This repository is provided under the MIT licence (see [LICENSE](LICENSE)).  

## Contributing
Want to contribute? Feel free to create an issue and submit a pull request (you might need to fork the repository if you were not added as a collaborator).
