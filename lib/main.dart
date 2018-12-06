import 'package:flutter/material.dart';
import 'package:fluttery_contacts/bloc_provider.dart';
import 'package:fluttery_contacts/contacts_bloc.dart';
import 'package:fluttery_contacts/data/contacts_repository.dart';
import 'package:fluttery_contacts/home/home.dart';

void main() {
  runApp(getProvider(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF6F6F6),
        fontFamily: 'Montserrat',
        textTheme: Theme.of(context).textTheme.apply(
          displayColor: const Color(0xFF6E6E6E),
          bodyColor: const Color(0xFF6E6E6E),
        )
      ),
      home: HomePage(),
    );
  }
}

BlocProvider getProvider(Widget child) {
  final contactsRepository = ContactsRepository();

  return BlocProvider(
    contactsBloc: ContactsBloc(
      repository: contactsRepository,
    ),
    child: child,
  );
}
