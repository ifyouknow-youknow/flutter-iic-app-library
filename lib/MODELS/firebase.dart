import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iic_app_template_flutter/FUNCTIONS/misc.dart';
import 'package:iic_app_template_flutter/FUNCTIONS/server.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;
final storage = FirebaseStorage.instance;
FirebaseMessaging messaging = FirebaseMessaging.instance;

// AUTHENTICATION --------------------------------
//CREATE
Future<User?> auth_CreateUser(String email, String password) async {
  try {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  } catch (e) {
    print('Error: $e');
    return null;
  }
}

//SIGN IN
Future<User?> auth_SignIn(String email, String password) async {
  try {
    UserCredential user =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    return user.user;
  } catch (e) {
    print('Error: $e');
    return null;
  }
}

//CHECK USER
Future<User?> auth_CheckUser() async {
  try {
    // Check if user is authenticated
    final user = await auth.authStateChanges().first;
    return user!;
  } catch (e) {
    print('Error: $e');
    return null;
  }
}

//VERIFY EMAIL
Future<bool> auth_VerifyEmail() async {
  try {
    User? user = auth.currentUser;
    if (user != null) {
      return user.emailVerified;
    } else {
      return false;
    }
  } catch (e) {
    print('Error: $e');
    return false;
  }
}

//SEND VERIFICATION EMAIL
Future<bool> auth_SendEmailVerification() async {
  try {
    final user = auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      return true;
    } else if (user != null && user.emailVerified) {
      print('Email is already verified.');
      return false;
    } else {
      print('No user is currently signed in.');
      return false;
    }
  } catch (e) {
    print('Error: $e');
    return false;
  }
}

// SIGN OUT
Future<bool> auth_SignOut() async {
  try {
    await auth.signOut();
    return true;
  } catch (e) {
    print('Error: $e');
    return false;
  }
}

// FIREBASE --------------------------------------
//CREATE
Future<bool> firebase_CreateDocument(
    String coll, String documentId, Map<String, dynamic> args) async {
  try {
    final things = db.collection(coll);
    things.doc(documentId).set(args);
    return true;
  } catch (error) {
    print("Failed to add document: $error");
    return false;
  }
}

//UPDATE
Future<bool> firebase_UpdateDocument(
    String coll, String documentId, Map<String, dynamic> args) async {
  try {
    final things = db.collection(coll);
    things.doc(documentId).update(args);
    return true;
  } catch (error) {
    print("Failed to add document: $error");
    return false;
  }
}

//DELETE
Future<bool> firebase_DeleteDocument(String coll, String documentId) async {
  try {
    final things = db.collection(coll);
    things.doc(documentId).delete();
    return true;
  } catch (error) {
    print("Failed to add document: $error");
    return false;
  }
}

//GET ALL
Future<List<Map<String, dynamic>>> firebase_GetAllDocuments(String coll) async {
  // Fetch all documents from the specified collection
  QuerySnapshot querySnapshot = await db.collection(coll).get();

  // Map the documents to a list of maps with document ID included
  List<Map<String, dynamic>> allThings = querySnapshot.docs.map((doc) {
    return {
      'id': doc.id,
      ...doc.data() as Map<String, dynamic>,
    };
  }).toList();

  return allThings;
}

//GET ONE
Future<Map<String, dynamic>> firebase_GetDocument(
    String coll, String documentId) async {
  try {
    DocumentSnapshot snapshot = await db.collection(coll).doc(documentId).get();
    final obj = {'id': snapshot.id, ...snapshot.data() as Map<String, dynamic>};
    return obj;
  } catch (error) {
    print('Error: $error');
    return {}; // Return an empty map or you could return a map with an error message
  }
}

//GET ALL QUERIED
Future<List<Map<String, dynamic>>> firebase_GetAllDocumentsQueried(
    String coll, List<Map<String, dynamic>> queries) async {
  try {
    Query query = db.collection(coll);

    for (var queryItem in queries) {
      String field = queryItem['field'];
      String operator = queryItem['operator'];
      dynamic value = queryItem['value'];
      switch (operator) {
        case '==':
          query = query.where(field, isEqualTo: value);
          break;
        case '!=':
          query = query.where(field, isNotEqualTo: value);
          break;
        case '<':
          query = query.where(field, isLessThan: value);
          break;
        case '<=':
          query = query.where(field, isLessThanOrEqualTo: value);
          break;
        case '>':
          query = query.where(field, isGreaterThan: value);
          break;
        case '>=':
          query = query.where(field, isGreaterThanOrEqualTo: value);
          break;
        case 'array-contains':
          query = query.where(field, arrayContains: value);
          break;
        case 'array-contains-any':
          query = query.where(field, arrayContainsAny: value);
          break;
        case 'in':
          query = query.where(field, whereIn: value);
          break;
        case 'not-in':
          query = query.where(field, whereNotIn: value);
          break;
        default:
          throw ArgumentError('Invalid operator: $operator');
      }
    }

    QuerySnapshot querySnapshot = await query.get();
    List<Map<String, dynamic>> allThings = querySnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      };
    }).toList();

    return allThings;
  } catch (error) {
    print('Error: $error');
    return [];
  }
}

//GET ALL ORDERED
Future<List<Map<String, dynamic>>> firebase_GetAllDocumentsOrdered(
    String coll, String orderField, String direction) async {
  try {
    Query query = db
        .collection(coll)
        .orderBy(orderField, descending: direction == 'desc');
    QuerySnapshot querySnapshot = await query.get();

    List<Map<String, dynamic>> allThings = querySnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      };
    }).toList();

    return allThings;
  } catch (error) {
    print('Error: $error');
    return [];
  }
}

//GET ALL QUERIED ORDERED
Future<List<Map<String, dynamic>>> firebase_GetAllDocumentsOrderedQueried(
    String coll,
    List<Map<String, dynamic>> queries,
    String orderField,
    String direction) async {
  try {
    Query query = db.collection(coll);

    // Apply the queries
    for (var queryItem in queries) {
      String field = queryItem['field'];
      String operator = queryItem['operator'];
      dynamic value = queryItem['value'];

      switch (operator) {
        case '==':
          query = query.where(field, isEqualTo: value);
          break;
        case '!=':
          query = query.where(field, isNotEqualTo: value);
          break;
        case '<':
          query = query.where(field, isLessThan: value);
          break;
        case '<=':
          query = query.where(field, isLessThanOrEqualTo: value);
          break;
        case '>':
          query = query.where(field, isGreaterThan: value);
          break;
        case '>=':
          query = query.where(field, isGreaterThanOrEqualTo: value);
          break;
        case 'array-contains':
          query = query.where(field, arrayContains: value);
          break;
        case 'array-contains-any':
          query = query.where(field, arrayContainsAny: value);
          break;
        case 'in':
          query = query.where(field, whereIn: value);
          break;
        case 'not-in':
          query = query.where(field, whereNotIn: value);
          break;
        default:
          throw ArgumentError('Invalid operator: $operator');
      }
    }

    // Apply ordering
    query = query.orderBy(orderField, descending: direction == 'desc');

    // Fetch the documents
    QuerySnapshot querySnapshot = await query.get();

    // Map the documents to a list of maps
    List<Map<String, dynamic>> allThings = querySnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      };
    }).toList();

    return allThings;
  } catch (error) {
    print('Error: $error');
    return [];
  }
}

//GET ALL LISTENER
Stream<List<Map<String, dynamic>>> firebase_GetAllDocumentsListener(
    String coll,
    Function(Map<String, dynamic>) createFunc,
    Function(Map<String, dynamic>) updateFunc,
    Function(Map<String, dynamic>) removeFunc) {
  return FirebaseFirestore.instance
      .collection(coll)
      .snapshots()
      .map((querySnapshot) {
    List<Map<String, dynamic>> documents = [];

    for (var change in querySnapshot.docChanges) {
      if (change.type == DocumentChangeType.added) {
        print("Document added: ${change.doc.data()}");
        createFunc(change.doc.data() as Map<String, dynamic>);
      } else if (change.type == DocumentChangeType.modified) {
        print("Document modified: ${change.doc.data()}");
        updateFunc(change.doc.data() as Map<String, dynamic>);
      } else if (change.type == DocumentChangeType.removed) {
        print("Document removed: ${change.doc.data()}");
        removeFunc(change.doc.data() as Map<String, dynamic>);
      }
    }

    querySnapshot.docs.forEach((doc) {
      documents.add(doc.data() as Map<String, dynamic>);
    });

// RETURNS DOCUMENTS IN THE LISTENER, NOT AS RETURN.
// .listen((documents) { print(documents);});
    return documents;
  });
}

//STORAGE
// DOWNLOAD MEDIA
Future<String?> storage_DownloadMedia(String path) async {
  try {
    final storageRef = storage.ref();
    final url = await storageRef.child(path).getDownloadURL();
    print("Download URL: $url");
    return url;
  } catch (e) {
    print('Error fetching download URL: $e');
    return null; // Handle error gracefully in your application
  }
}

// UPLOAD MEDIA
Future<bool> storage_UploadMedia(String path, File file) async {
  try {
    final storageRef = storage.ref().child(path);
    await storageRef.putFile(file);
    return true; // Upload completed successfully
  } catch (e) {
    print('Error uploading media: $e');
    return false; // Handle error gracefully in your application
  }
}

// MESSAGING
// SET UP

Future<void> messaging_SetUp() async {
  await messaging.requestPermission();
  fetchAPNSToken();
  // Fetch the device token
  String? token = await FirebaseMessaging.instance.getToken();
  print("Device Token: $token");
  // setInDevice('token', token);

  // Set up foreground message handler
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Message received in foreground: ${message.messageId}');
    // Handle foreground message
  });

  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  // Set up notification handling when the app is launched from a notification
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      print('App launched from notification: ${message.messageId}');
      // Handle notification tap
    }
  });
}

Future<void> messaging_IosSetUp() async {
  await messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  messaging.getInitialMessage().then(handleMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

void handleMessage(RemoteMessage? message) {
  if (message == null) {
    return;
  }
}

Future<void> fetchAPNSToken() async {
  final token = await messaging.getAPNSToken();
  print('APNS Token: $token');
}

Future<void> sendPushNotification(token, title, message) async {
  server_POST('send-notification',
      {'token': token, 'title': '$title', 'message': '$message'});
}