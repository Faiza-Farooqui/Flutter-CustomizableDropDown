# Awesome DropDown

A customizable drop-down library that handles all the touch and clicks events, including iOS and mobile back-pressed callbacks.

## Installation

Add following dependency in pubspec.yaml file. And add this import to your file.

```bash
awesome_dropdown:^0.0.2

import 'package:awesome_dropdown/awesome_dropdown.dart';
```

## Quick Start

```python
Add AwesomeDropdown to the widget tree

AwesomeDropDown(
                  isPanDown: _isPanDown,
                  dropDownList: _list,
                  dropDownIcon: Icon(Icons.arrow_drop_down, color: Colors.grey, size: 23,),
                  selectedItem: _selectedItem,
                  onDropDownItemClick: (selectedItem) {
                    _selectedItem = selectedItem;
                  },
                  dropStateChanged: (isOpened) {
                    _isDropDownOpened = isOpened;
                    if (!isOpened) {
                      _isBackPressedOrTouchedOutSide = false;                    }
                  },
                ),                ​
```

## Custom Body

```python

AwesomeDropDown(
                   ​isPanDown: _isPanDown,
                   ​isBackPressedOrTouchedOutSide:
                   ​_isBackPressedOrTouchedOutSide,
                   ​dropDownBGColor: Colors.white,
                   ​padding: 8,
                   ​dropDownIcon: Icon(Icons.arrow_drop_down, color: Colors.grey, size: 23,),
                   ​elevation: 5,
                   ​dropDownBorderRadius: 10,
                   ​dropDownTopBorderRadius: 50,
                   ​dropDownBottomBorderRadius: 50,
                   ​dropDownIconBGColor: Colors.transparent,
                   ​dropDownList: _list,
                   ​selectedItem: _selectedItem,
                   ​numOfListItemToShow: 4,
                   ​selectedItemTextStyle: TextStyle(
                       ​color: Colors.black,
                       ​fontSize: 16,
                       ​fontWeight: FontWeight.normal),
                   ​dropDownListTextStyle: TextStyle(
                       ​color: Colors.grey,
                       ​fontSize: 15,
                       ​backgroundColor: Colors.transparent),
                   ​onDropDownItemClick: (selectedItem) {
                     ​_selectedItem = selectedItem;
                   ​},
                   ​dropStateChanged: (isOpened) {
                     ​_isDropDownOpened = isOpened;
                     ​if (!isOpened) {
                       ​_isBackPressedOrTouchedOutSide = false;
                     ​}
                   ​},
                 ​),
```
## Screenshot
![awesome_dropDown](https://user-images.githubusercontent.com/36657067/116820134-420b2400-ab28-11eb-826a-caa69072ba6b.gif)
## Developer Team
Faiza Farooqui & my team members (Hina Hussain, Kamran Khan, Abdul Sattar)

## License
[MIT](https://choosealicense.com/licenses/mit/)
