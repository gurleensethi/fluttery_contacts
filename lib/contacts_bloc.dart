import 'package:fluttery_contacts/data/contacts_repository.dart';
import 'package:fluttery_contacts/data/resource.dart';
import 'package:rxdart/rxdart.dart';
import 'package:contacts_service/contacts_service.dart';

class ContactsBloc {
  final ContactsRepository repository;
  final _contacts = BehaviorSubject<Resource<List<Contact>>>();

  ContactsBloc({this.repository}) {
    repository.getAll().listen(_contacts.add);
  }

  Stream<Resource<List<Contact>>> get contacts => _contacts.stream;

  void dispose() {
    _contacts.close();
  }
}
