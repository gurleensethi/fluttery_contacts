import 'package:contacts_service/contacts_service.dart';
import 'package:fluttery_contacts/data/resource.dart';
import 'package:rxdart/rxdart.dart';

/// Repository that provides functions to read and manipulate contacts
/// on device.
class ContactsRepository {
  /// Get a list of contacts
  /// Returns a stream of contacts.
  Stream<Resource<List<Contact>>> getAll() {
    final controller = BehaviorSubject<Resource<List<Contact>>>();

    controller.add(Resource.loading());

    ContactsService.getContacts().asStream().listen((data) {
      controller.add(Resource.success(data: data.toList()));
      controller.close();
    });

    return controller;
  }
}
