import 'package:flutter/material.dart';
import 'package:awesome_dropdown/awesome_dropdown.dart';

void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Awesome DropDown Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SimpleDropDown(),
      debugShowCheckedModeBanner: false,
    );
  }
}
///==================================== EXAMPLE 1 =================================================================
class SimpleDropDown extends StatefulWidget {
  @override
  _SimpleDropDownState createState() => _SimpleDropDownState();
}
class _SimpleDropDownState extends State<SimpleDropDown> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Awesome DropDown"),),
      body: AwesomeDropDown(
        dropDownList: ["Abc","DEF","GHI","JKL","MNO","PQR"],
      ),
    );
  }
}

///==================================== EXAMPLE 2 =================================================================

class DropDownWithPanDownAndDrawer extends StatefulWidget {
  @override
  _DropDownWithPanDownAndDrawerState createState() => _DropDownWithPanDownAndDrawerState();
}

class _DropDownWithPanDownAndDrawerState extends State<DropDownWithPanDownAndDrawer> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isBackPressedOrTouchedOutSide = false,
      _isDropDownOpened = false,
      _isPanDown = false;
  List<String> _list;
  String _selectedItem = '';

  @override
  void initState() {
    _list = ["Abc","DEF","GHI","JKL","MNO","PQR"];
    _selectedItem = 'Select Item';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// we need to wrap our Scaffold in GestureDetector in order to get required functionalities
    ///  i.e. close the dropdown on drawer click and touch on outside
    return GestureDetector(
      onTap: _removeFocus,
      onPanDown: (focus) {
        _isPanDown = true;
        _removeFocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        /// I have maintain open and close state of drop down with the drawer
        /// if drop down is opened and user wants to open Drawer, it will first close the drop down then open the drawer
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Drawer Header'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('Item 1'),
                onTap: () {
                },
              ),
              ListTile(
                title: Text('Item 2'),
                onTap: () {
                },
              ),
            ],
          ),
        ),
        appBar: PreferredSize(
          preferredSize: AppBar().preferredSize,
          child: SafeArea(
            child: PreferredSize(
                preferredSize: Size.fromHeight(100.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left:60),
                      child: Text('Awesome DropDown',
                          style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                        margin: EdgeInsets.only(right: 8),
                        child: IconButton(icon: Icon(Icons.menu,size: 30,color: Colors.blueAccent,),
                            onPressed:(){
                              _onDrawerBtnPressed();
                            }//_onDrawerBtnPressed
                        )
                    )
                  ],
                )
            ),
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 15, left: 16, right: 20),
          child: AwesomeDropDown(
            isPanDown: _isPanDown,
            dropDownList: _list,
            isBackPressedOrTouchedOutSide:
            _isBackPressedOrTouchedOutSide,
            selectedItem: _selectedItem,
            onDropDownItemClick: (selectedItem) {
              _selectedItem = selectedItem;
            },
            dropStateChanged: (isOpened) {
              _isDropDownOpened = isOpened;
              if (!isOpened) {
                _isBackPressedOrTouchedOutSide = false;
              }
            },
          ),
        ),
      ),
    );
  }

  /// this func is used to close dropDown (if open) when you tap or pandown anywhere in the screen
  void _removeFocus() {
    if (_isDropDownOpened) {
      setState(() {
        _isBackPressedOrTouchedOutSide = true;
      });
    }
  }
  /// this func will call on DrawerIconPressed, it closes the dropDown if open and then open the drawer
  void _onDrawerBtnPressed(){
    if (_isDropDownOpened) {
      setState(() {
        _isBackPressedOrTouchedOutSide = true;
      });
    }else{
      _scaffoldKey.currentState.openEndDrawer();
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }
}

///==================================== EXAMPLE 3 =================================================================

class DropDownWithiOsBackIcon extends StatefulWidget {
  @override
  _DropDownWithiOsBackIconState createState() => _DropDownWithiOsBackIconState();
}

class _DropDownWithiOsBackIconState extends State<DropDownWithiOsBackIcon> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isBackPressedOrTouchedOutSide = false,
      _isDropDownOpened = false,
      _isPanDown = false, _navigateToPreviousScreenOnIOSBackPress = true;
  List<String> _list;
  String _selectedItem = '';

  @override
  void initState() {
    _list = ["Abc","DEF","GHI","JKL","MNO","PQR"];
    _selectedItem = 'Select Item';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _removeFocus,
      onPanDown: (focus) {
        _isPanDown = true;
        _removeFocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        /// in appBar I have added iOS back button and open and close state of drop down is work like a charm when iOS back button pressed
        appBar: PreferredSize(
          preferredSize: AppBar().preferredSize,
          child: SafeArea(
            child: PreferredSize(
                preferredSize: Size.fromHeight(100.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 30,
                      child: Container(
                          margin: EdgeInsets.only(left: 8,),
                          child: IconButton(
                            color: Colors.black,
                            icon: Icon(
                              Icons.arrow_back_ios,
                            ),
                            onPressed: _onWillPop,
                          )),),
                    Container(
                      margin: EdgeInsets.only(right: 60,),
                      child: Text('Awesome DropDown',
                          style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
                    ),
                  ],
                )
            ),
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 15, left: 16, right: 20),
              child: AwesomeDropDown(
                isPanDown: _isPanDown,
                dropDownList: _list,
                isBackPressedOrTouchedOutSide:
                _isBackPressedOrTouchedOutSide,
                selectedItem: _selectedItem,
                onDropDownItemClick: (selectedItem) {
                  _selectedItem = selectedItem;
                },
                dropStateChanged: (isOpened) {
                  _isDropDownOpened = isOpened;
                  if (!isOpened) {
                    _isBackPressedOrTouchedOutSide = false;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  /// this func is used to close dropDown (if open) when you tap or pandown anywhere in the screen
  /// this method is also used for iOS backPressed as mentioned in gif
  void _removeFocus() {
    if (_isDropDownOpened) {
      setState(() {
        _isBackPressedOrTouchedOutSide = true;
      });
      _navigateToPreviousScreenOnIOSBackPress = false;
    }
  }
  /// this func will call on mob backPressed and iOS back pressed
  /// if dropdown opens it will close the dropdown else it will pop the screen
  Future<bool> _onWillPop() {
    if (_scaffoldKey.currentState.isEndDrawerOpen) {
      Navigator.of(context).pop();
      return Future.value(false);
    } else {
      if (_isDropDownOpened) {
        setState(() {
          _isBackPressedOrTouchedOutSide = true;
        });
        FocusManager.instance.primaryFocus.unfocus();
        return Future.value(false);
      } else {
        if(_navigateToPreviousScreenOnIOSBackPress){
          Navigator.of(context).pop();
          return Future.value(true);
        }else{
          _navigateToPreviousScreenOnIOSBackPress = true;
          return Future.value(false);
        }
      }
    }
  }
}
///==================================== EXAMPLE 4 =================================================================

class FullyFunctionalAwesomeDropDown extends StatefulWidget {
  @override
  _FullyFunctionalAwesomeDropDownState createState() => _FullyFunctionalAwesomeDropDownState();
}

class _FullyFunctionalAwesomeDropDownState extends State<FullyFunctionalAwesomeDropDown> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isBackPressedOrTouchedOutSide = false,
      _isDropDownOpened = false,
      _isPanDown = false, _navigateToPreviousScreenOnIOSBackPress = true;
  List<String> _list;
  String _selectedItem = 'Select Country';

  @override
  void initState() {
    _list = ["Abc","DEF","GHI","JKL","MNO","PQR"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        /// user has to wrap it's main body to GestureDetector so all the implemented functionalities would be work
        /// perfectly. this is used to close the drop down on [out side touch, ios back pressed, drawer open, pan down, scrolling]
        child: GestureDetector(
          onTap: _removeFocus,
          onPanDown: (focus) {
            _isPanDown = true;
            _removeFocus();
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            key: _scaffoldKey,
            /// I have maintain open and close state of drop down with the drawer
            /// if drop down is opened and user wants to open Drawer, it will first close the drop dwon then open the drawer
            endDrawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Text('Drawer Header'),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                  ),
                  ListTile(
                    title: Text('Item 1'),
                    onTap: () {
                    },
                  ),
                  ListTile(
                    title: Text('Item 2'),
                    onTap: () {
                    },
                  ),
                ],
              ),
            ),
            /// in appBar I have added iOS back button and open and close state of drop down is work like a charm when iOS back button
            /// pressed
            appBar: PreferredSize(
              preferredSize: AppBar().preferredSize,
              child: SafeArea(
                child: PreferredSize(
                    preferredSize: Size.fromHeight(100.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 30,
                          child: Container(
                              margin: EdgeInsets.only(left: 8,),
                              child: IconButton(
                                color: Colors.black,
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                ),
                                onPressed: _onWillPop,
                              )),),
                        Text('Awesome DropDown',
                            // textScaleFactor: 1.0,
                            style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
                        Container(
                          child: Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: IconButton(icon: Icon(Icons.menu,size: 30,color: Colors.blueAccent,),
                                  onPressed:(){
                                    _onDrawerBtnPressed();
                                  }//_onDrawerBtnPressed
                              )
                          ),
                        )
                      ],
                    )
                ),
              ),
            ),
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 15, left: 16, right: 20),
                  child: AwesomeDropDown(
                    isPanDown: _isPanDown,
                    isBackPressedOrTouchedOutSide:
                    _isBackPressedOrTouchedOutSide,
                    dropDownBGColor: Colors.white,
                    padding: 8,
                    dropDownIcon: Icon(Icons.arrow_drop_down, color: Colors.grey, size: 23,),
                    elevation: 5,
                    dropDownBorderRadius: 10,
                    dropDownTopBorderRadius: 50,
                    dropDownBottomBorderRadius: 50,
                    dropDownIconBGColor: Colors.transparent,
                    dropDownList: _list,
                    selectedItem: _selectedItem,
                    numOfListItemToShow: 4,
                    selectedItemTextStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                    dropDownListTextStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        backgroundColor: Colors.transparent),
                    onDropDownItemClick: (selectedItem) {
                      _selectedItem = selectedItem;
                    },
                    dropStateChanged: (isOpened) {
                      _isDropDownOpened = isOpened;
                      if (!isOpened) {
                        _isBackPressedOrTouchedOutSide = false;
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
  /// this func is used to close dropDown (if open) when you tap or pandown anywhere in the screen
  /// this method is also used for iOS backPressed as mentioned in gif
  void _removeFocus() {
    if (_isDropDownOpened) {
      setState(() {
        _isBackPressedOrTouchedOutSide = true;
      });
      _navigateToPreviousScreenOnIOSBackPress = false;
    }
  }
  /// this func will call on mob backPressed and on iOS back pressed
  /// if dropdown opens it will close the dropdown else it will pop the screen
  Future<bool> _onWillPop() {
    if (_scaffoldKey.currentState.isEndDrawerOpen) {
      Navigator.of(context).pop();
      return Future.value(false);
    } else {
      if (_isDropDownOpened) {
        setState(() {
          _isBackPressedOrTouchedOutSide = true;
        });
        FocusManager.instance.primaryFocus.unfocus();
        return Future.value(false);
      } else {
        if(_navigateToPreviousScreenOnIOSBackPress){
          Navigator.of(context).pop();
          return Future.value(true);
        }else{
          _navigateToPreviousScreenOnIOSBackPress = true;
          return Future.value(false);
        }
      }
    }
  }
  /// this func will call on DrawerIconPressed, it closes the dropDown if open and then open the drawer
  void _onDrawerBtnPressed(){
    if (_isDropDownOpened) {
      setState(() {
        _isBackPressedOrTouchedOutSide = true;
      });
    }else{
      _scaffoldKey.currentState.openEndDrawer();
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }
}

