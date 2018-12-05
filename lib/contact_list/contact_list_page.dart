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
        return _ContactListItem(contact: contact);
      },
      itemCount: contacts.length,
    );
  }
}

class _ContactListItem extends StatelessWidget {
  final Contact contact;

  const _ContactListItem({Key key, this.contact})
      : assert(contact != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Hero(
        tag: contact.displayName,
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
          shadowColor: Colors.white54,
          elevation: 4.0,
          child: InkWell(
            borderRadius: BorderRadius.circular(6.0),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return ContactDetailPage(
                      contact: contact,
                    );
                  },
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.person,
                    color: Colors.grey,
                    size: 40.0,
                  ),
                  Spaces.w12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Contact",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spaces.h12,
                        Text(
                          //contact.phones.toList()[0].value,
                          "1234567890",
                          style: TextStyle(
                            fontSize: 16.0,
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
