import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app_test/constants/globals.dart';
import 'package:google_sign_in/google_sign_in.dart';



final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String name;
String email;
String imageUrl;

Future<String> signInWithGoogle() async {
  await Firebase.initializeApp();

  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential authResult = await _auth.signInWithCredential(credential);
  final User user = authResult.user;

  if(user != null) {
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);

    // Add the following lines after getting the user
    // Checking if email and name is null
    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoURL != null);
    // Store the retrieved data
    name = user.displayName;
    email = user.email;
    imageUrl = user.photoURL;

    // Short name
    if(name.contains(" ")) {
      name = name.substring(0, name.indexOf(" "));
    }

    print('signInWithGoogle succeded: $user');

    FirebaseFirestore Firestore = FirebaseFirestore.instance;

    /*final QuerySnapshot result = await Firestore.collection('users').where('id', isEqualTo: user.uid).get();//Documents();
    final List < DocumentSnapshot > documents = result.documents;
    if (documents.length == 0) {
      // Update data to server if new user
      Firestore.collection('users').document(user.uid).setData({ 'nickname': name, 'photoUrl': imageUrl, 'id': user.uid });
    }*/
    DocumentSnapshot documentSnapshot = await Firestore.collection('users').doc(user.uid).get();
    if(!documentSnapshot.exists) {
      await Firestore.collection('users').doc(user.uid).set({
        'email': email,
        'nickname': name,
        'photoUrl': imageUrl,
        'address': {
          'country': null,
          'street': null,
          'cp': null,
          'city': null,
        },
        'birthday': '01/01/1970',
        'id': user.uid,
      }).then((value) => print("success"));
    }
    return '$user';
  }
  return null;
}

Future<void> signOutGoogle() async {
  await googleSignIn.signOut();
  print("User Signed Out");
}