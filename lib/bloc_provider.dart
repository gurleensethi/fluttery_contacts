import 'package:flutter/material.dart';
import 'package:fluttery_contacts/contacts_bloc.dart';

class BlocProvider extends InheritedWidget {
  final ContactsBloc contactsBloc;

  BlocProvider({
    Key key,
    Widget child,
    this.contactsBloc,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static BlocProvider of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(BlocProvider) as BlocProvider);
  }
}
