# DecimalField
Lightweight implementation of a text field that filters and manages decimal input. It only allows integer or floating point numbers and a minus by default. It also includes few other behaviours that are often needed:
- trimming zeros in a decimal number when editing ends
- resetting the input to zero when editing ends and the field is empty
- clearing the field when editing begins and the text is zero  

These are "always on" by default.  
Clearing zero when editing begins can be disabled by turning off the `isClearingZeroWhenEditingBegins` flag.   
To disable trimming zeros in a floating point number and ensuring the text is not empty when editing ends, turn off the `trimsAndSetsNonEmptyWhenEditingEnds` flag.  
Other behaviour will also become customizable in the future. 

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

To make it even safer, please feel free to fork the repository.

## Licence
This repository is provided under the MIT licence (see [LICENSE](LICENSE)).  

## Contributing
Want to contribute? Feel free to create an issue and submit a pull request (you might need to fork the repository if you were not added as a collaborator).
