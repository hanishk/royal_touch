import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:royaltouch/api/square_api.dart';
import 'package:royaltouch/firebase/models.dart';
import 'package:royaltouch/pages/appointments/model.dart' as appointment_model;
import 'package:royaltouch/pages/payment/models/create_customer.dart';
import 'package:royaltouch/pages/payment/models/create_customer_success_res.dart'
    as ccsr;
import 'package:royaltouch/shared_prefs/shared_prefs.dart';

class AppCloudFirestore {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static String allServices = '/all_services';
  static String allUsers = '/all_users';
  static String allTechnicians = '/technician';

  static Future<List<AllServices>> getAllServices() async {
    final CollectionReference _services = firestore.collection(allServices);

    final List<AllServices> list = [];
    list.addAll(await SharedPrefs().getServices());
    if (list.isEmpty) {
      await _services.get().then((snapshot) async {
        for (QueryDocumentSnapshot querySnapshot in snapshot.docs) {
          final Map map = querySnapshot.data();
          map['id'] = querySnapshot.id;
          list.add(AllServices.fromMap(map));
        }
      });
      await SharedPrefs().saveServices(list);
    } else {
      updateServicesCache();
    }

    return list;
  }

  static Future updateServicesCache() async {
    final CollectionReference _services = firestore.collection(allServices);
    final List<AllServices> list = [];
    await _services.get().then((snapshot) async {
      for (QueryDocumentSnapshot querySnapshot in snapshot.docs) {
        final Map map = querySnapshot.data();
        map['id'] = querySnapshot.id;
        list.add(AllServices.fromMap(map));
      }
    });
    await SharedPrefs().saveServices(list);
  }

  static Stream<QuerySnapshot> getAppointmentsStream(String path) {
    final CollectionReference _appointments = firestore.collection(path);
    return _appointments.snapshots();
  }

  static Future<List<appointment_model.AppointmentModel>> getAllAppointments(
      String path) async {
    final CollectionReference _appointments = firestore.collection(path);

    final List<appointment_model.AppointmentModel> list = [];
    await _appointments.get().then((snapshot) async {
      for (QueryDocumentSnapshot querySnapshot in snapshot.docs) {
        final Map map = querySnapshot.data();
        map.addAll(
          <String, dynamic>{
            'doc_path': path + '/' + querySnapshot.id,
          },
        );
        list.add(appointment_model.AppointmentModel.fromJson(map));
      }
    });
    list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return list.reversed.toList();
  }

  static Future<UserDetails> getUserDetails(String email) async {
    final CollectionReference _users = firestore.collection(allUsers);
    UserDetails details;
    await _users.doc(email).get().then((DocumentSnapshot snapshot) async {
      if (snapshot != null) {
        details = UserDetails.fromMap(snapshot);
      }
    });
    return details;
  }

  static Future<bool> saveUserDetails(UserDetails userDetails) async {
    try {
      final CollectionReference _users = firestore.collection(allUsers);
      if (userDetails.location == null) {
        final CollectionReference _tech = firestore.collection(allTechnicians);
        await _tech.get().then((QuerySnapshot snapshot) {
          userDetails.location = allTechnicians + '/' + snapshot.docs.first.id;
        });
      }
      final ccsr.CreateCustomerSuccessResponse result =
          await SquareApi().createCustomerSquare(
        createCustomer: CreateCustomer(
          address: Address(
            addressLine1: userDetails.address,
          ),
          emailAddress: userDetails.email,
          givenName: userDetails.name,
          idempotencyKey: userDetails.email,
          nickname: userDetails.name,
          phoneNumber: userDetails.contact,
        ),
      );
      await _users
          .doc(userDetails.email)
          .set(userDetails.toMap())
          .then((value) async {
        print('USER UPDATED');
      });
      await updateDoc(allUsers + '/' + userDetails.email, <String, dynamic>{
        'sq_customer': result.toJson(),
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<List<Technician>> getAllTech() async {
    final CollectionReference _services = firestore.collection(allTechnicians);
    List<Technician> list = [];
    await _services.get().then((snapshot) async {
      for (QueryDocumentSnapshot querySnapshot in snapshot.docs) {
        if (list.isEmpty) {
          list = [];
        }
        list.add(Technician.fromMap(querySnapshot));
      }
    });
    return list;
  }

  static Future<Technician> getTechByPath(String path) async {
    final DocumentReference _tech = firestore.doc(path);
    Technician technician;
    await _tech.get().then(
          (value) => technician = Technician.fromMap(value),
        );
    return technician;
  }

  static Future<DocumentReference> makeNewDoc(String path) async {
    final CollectionReference _collection = firestore.collection(path);
    DocumentReference reference;
    reference = await _collection.add(<String, String>{});
    return reference;
  }

  static Future<bool> updateDoc(String path, Map data) async {
    try {
      final DocumentReference _doc = firestore.doc(path);
      await _doc.update(data);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
