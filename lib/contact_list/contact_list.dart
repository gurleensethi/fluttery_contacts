import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttery_contacts/common/spaces.dart';
import 'package:fluttery_contacts/contact_detail/contact_detail_page.dart';

class ContactListPage extends StatelessWidget {
  final List<Contact> contacts;
  final ScrollController controller;

  const ContactListPage({
    Key key,
    this.contacts,
    this.controller,
  })  : assert(contacts != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      shrinkWrap: true,
      itemBuilder: (builder, index) {
        final contact = contacts[index];
        EdgeInsets topMargin;

        if (index == 0) {
          topMargin = EdgeInsets.only(top: 16.0);
        } else {
          topMargin = EdgeInsets.all(0.0);
        }

        return Container(
          margin: topMargin,
          child: _ContactListItem(contact: contact),
        );
      },
      itemCount: contacts.length,
    );
  }
}

class _ContactListItem extends StatefulWidget {
  final Contact contact;

  const _ContactListItem({Key key, this.contact})
      : assert(contact != null),
        super(key: key);

  @override
  _ContactListItemState createState() {
    return new _ContactListItemState();
  }
}

class _ContactListItemState extends State<_ContactListItem>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 4.0, horizontal: 16.0),
      child: Hero(
        tag: widget.contact.displayName,
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
          shadowColor: Colors.white54,
          elevation: 1.0,
          child: InkWell(
            borderRadius: BorderRadius.circular(6.0),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return ContactDetailPage(
                      contact: widget.contact,
                    );
                  },
                ),
              );
            },
            child: Container(
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
          ),
        ),
      ),
    );
  }
}
