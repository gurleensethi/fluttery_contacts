import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttery_contacts/common/colors.dart';
import 'package:fluttery_contacts/common/spaces.dart';
import 'package:fluttery_contacts/contact_detail/contact_detail_page.dart';

typedef OnMenuOpened(ContactListItemState widget);
typedef OnMenuClosed();

class ContactListPage extends StatefulWidget {
  final List<Contact> contacts;
  final ScrollController controller;

  const ContactListPage({
    Key key,
    this.contacts,
    this.controller,
  })  : assert(contacts != null),
        super(key: key);

  @override
  ContactListPageState createState() {
    return new ContactListPageState();
  }
}

class ContactListPageState extends State<ContactListPage> {
  // Item that is currently selected (menu layer is shown).
  int _selectedItem = -1;

  // State object of the item which is selected.
  ContactListItemState selectedItemState;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.controller,
      shrinkWrap: true,
      itemBuilder: (builder, index) {
        final contact = widget.contacts[index];
        EdgeInsets topMargin;

        // Add padding to the top most element
        if (index == 0) {
          topMargin = EdgeInsets.only(top: 16.0);
        } else {
          topMargin = EdgeInsets.all(0.0);
        }

        return Container(
          margin: topMargin,
          child: ContactListItem(
            contact: contact,
            isSelected: index == _selectedItem,
            onMenuClosed: () {
              _selectedItem = -1;
            },
            onMenuOpened: (state) {
              if (_selectedItem != index) {
                print("$_selectedItem : ${selectedItemState?.mounted}");
                if (selectedItemState?.mounted == true) {
                  selectedItemState?.closeMenu();
                }
              }

              selectedItemState = state;
              _selectedItem = index;
            },
          ),
        );
      },
      itemCount: widget.contacts.length,
    );
  }
}

class ContactListItem extends StatefulWidget {
  final Contact contact;
  final OnMenuOpened onMenuOpened;
  final OnMenuClosed onMenuClosed;
  final bool isSelected;

  const ContactListItem({
    Key key,
    this.contact,
    this.onMenuOpened,
    this.onMenuClosed,
    this.isSelected,
  })  : assert(contact != null),
        super(key: key);

  @override
  ContactListItemState createState() {
    return new ContactListItemState();
  }
}

class ContactListItemState extends State<ContactListItem>
    with TickerProviderStateMixin {
  // Is the menu layer shown
  bool _isMenuVisible = false;
  AnimationController _menuAnimationController;
  Animation<double> _opacityAnimation;

  // Key to be used for base item to calculate the width/height when menu is shown
  GlobalKey _containerKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _menuAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));

    _menuAnimationController.addListener(() => setState(() {}));

    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_menuAnimationController);

    if (widget.isSelected) {
      _isMenuVisible = true;

      _menuAnimationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Show/Hide the menu layer
  void toggleMenuOptions() {
    if (_isMenuVisible) {
      widget.onMenuClosed();
      _menuAnimationController.reverse();
    } else {
      widget.onMenuOpened(this);
      _menuAnimationController.forward();
    }

    _isMenuVisible = !_isMenuVisible;
  }

  void closeMenu() {
    _menuAnimationController.reverse();
    _isMenuVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    // When list is scrolled, state of off-screen items is destroyed.
    // If the item is selected and is returning to the visible screen then
    // fire the callback so that the parent element has access to the newly
    // created state and can manipulate it as required.
    if (_isMenuVisible) {
      widget.onMenuOpened(this);
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Hero(
        tag: widget.contact.displayName,
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
          shadowColor: Colors.white54,
          elevation: 1.0,
          child: InkWell(
            borderRadius: BorderRadius.circular(6.0),
            onTap: toggleMenuOptions,
            child: Stack(
              children: <Widget>[
                Container(
                  key: _containerKey,
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.person,
                          color: Colors.grey[400],
                          size: 36.0,
                        ),
                      ),
                      Spaces.w12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Contact",
                              //widget.contact.displayName,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Spaces.h4,
                            Text(
                              //widget.contact.phones.toList()[0].value,
                              "1234567890",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: Container(
                      width: _opacityAnimation.value *
                          (_containerKey?.currentContext
                                  ?.findRenderObject()
                                  ?.semanticBounds
                                  ?.width ??
                              0),
                      height: (_containerKey?.currentContext
                              ?.findRenderObject()
                              ?.semanticBounds
                              ?.height ??
                          0),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.gradient2,
                            AppColors.gradient1,
                          ],
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Contact",
                                  //widget.contact.displayName,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Spaces.h4,
                                Text(
                                  //widget.contact.phones.toList()[0].value,
                                  "1234567890",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.info,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                            splashColor: Colors.red,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.call,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                            splashColor: Colors.red,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.message,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                            splashColor: Colors.black,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: toggleMenuOptions,
                            splashColor: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
