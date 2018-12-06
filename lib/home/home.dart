import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttery_contacts/bloc_provider.dart';
import 'package:fluttery_contacts/common/list_scrollbar.dart';
import 'package:fluttery_contacts/common/spaces.dart';
import 'package:fluttery_contacts/contact_list/contact_list.dart';
import 'package:fluttery_contacts/data/resource.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  AnimationController _animationController;
  Animation<double> _marginsAnimation;
  static const double _TOP_BAR_MARGIN = 24.0;
  double _margins = _TOP_BAR_MARGIN;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..addListener(() => setState(() {
          _margins = _marginsAnimation.value;
        }));

    _marginsAnimation = Tween(begin: 0.0, end: _TOP_BAR_MARGIN).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _controller.addListener(() {
      setState(() {
        _margins = _TOP_BAR_MARGIN - _controller.position.pixels / 10;

        if (_margins > _TOP_BAR_MARGIN) _margins = _TOP_BAR_MARGIN;
        if (_margins < 0) _margins = 0.0;
      });
    });

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of(context).contactsBloc;

    return Scaffold(
      appBar: topAppBar,
      body: StreamBuilder<Resource<List<Contact>>>(
        stream: bloc.contacts,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.status == Status.SUCCESS) {
            return ListScrollbar(
              controller: _controller,
              child: ContactListPage(
                contacts: snapshot.data.data,
                controller: _controller,
              ),
              itemCount: snapshot.data.data.length,
              labelBuilder: (index) {
                final contact = snapshot.data.data[index];
                if (contact.displayName != null &&
                    contact.displayName.length > 0) {
                  return contact.displayName[0];
                }
                return '';
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget get topAppBar {
    return PreferredSize(
      child: Container(
        child: SafeArea(
          child: Container(
            padding:
                EdgeInsets.only(left: _margins, right: _margins, top: _margins),
            child: Material(
              borderRadius: BorderRadius.circular(_margins / 2),
              color: Colors.white,
              elevation: 6.0,
              shadowColor: Colors.grey[100],
              child: Container(
                padding: EdgeInsets.all(4.0),
                child: Row(
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.menu), onPressed: () {}),
                    Spaces.w16,
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration.collapsed(
                          hintText: 'Search Contacts',
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      preferredSize: Size(100.0, 100.0),
    );
  }
}
