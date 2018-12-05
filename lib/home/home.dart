import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttery_contacts/bloc_provider.dart';
import 'package:fluttery_contacts/common/list_scrollbar.dart';
import 'package:fluttery_contacts/contact_list/contact_list_page.dart';
import 'package:fluttery_contacts/data/resource.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of(context).contactsBloc;

    return Scaffold(
      appBar: AppBar(),
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
}
