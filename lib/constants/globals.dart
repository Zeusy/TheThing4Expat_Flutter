library globals;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

String nameUser = 'name';
User currentUser;
GoogleSignIn googleSignIn = GoogleSignIn(scopes: <String>[
  'openid',
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
  'https://www.googleapis.com/auth/userinfo.profile',
  'https://www.googleapis.com/auth/userinfo.email',
],);
GoogleSignInAccount currentGoogleUser;