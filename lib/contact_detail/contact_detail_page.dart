import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class ContactDetailPage extends StatelessWidget {
  final Contact contact;

  const ContactDetailPage({Key key, this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: contact.displayName,
        child: Container(
          child: Material(
            child: Center(
              child: Text(contact.displayName),
            ),
          ),
        ),
      ),
    );
  }
}
