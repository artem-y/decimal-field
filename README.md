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
Swift Package Manager is a preferred way to connect `DecimalField` to your Xcode project.
Setting exact version dependency rule is advised to prevent pulling in unwanted changes. You can find versions in the [Releases](https://github.com/artem-y/decimal-field/releases) section.  

## Licence
This repository is provided under the MIT licence (see [LICENSE](LICENSE)).  

## Contributing
Want to contribute? Feel free to create an issue and submit a pull request (you might need to fork the repository if you were not added as a collaborator).
