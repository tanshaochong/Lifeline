import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailandPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    final User user = result.user!;
    await userInitData(user);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> userInitData(User user) async {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('users');

    final userData = {
      "email": user.email,
      "last_course": 0,
      "courses_completion": {
        "010101": false,
        "010102": false,
        "010103": false,
        "010104": false,
        "010105": false,
        "010201": false,
        "010202": false,
        "010203": false,
        "010204": false,
        "010205": false,
        "010301": false,
        "010302": false,
        "010303": false,
        "010304": false,
        "010305": false,
        "010401": false,
        "010402": false,
        "010403": false,
        "010404": false,
        "010405": false,
        "020101": false,
        "020102": false,
        "020103": false,
        "020104": false,
        "020201": false,
        "020202": false,
        "020203": false,
        "020301": false,
        "020302": false,
        "020303": false,
        "020304": false,
        "020401": false,
        "020402": false,
        "020403": false,
        "020404": false,
        "020501": false,
        "020502": false,
        "020503": false,
        "020504": false,
        "020601": false,
        "020602": false,
        "020603": false,
        "020604": false,
        "020701": false,
        "020702": false,
        "020703": false,
        "020704": false,
        "030101": false,
        "030102": false,
        "030103": false,
        "030201": false,
        "030202": false,
        "030203": false,
        "030301": false,
        "030302": false,
        "030303": false,
        "030401": false,
        "030402": false,
        "030403": false,
        "030501": false,
        "030502": false,
        "030503": false,
        "030601": false,
        "030602": false,
        "030603": false,
        "040101": false,
        "040102": false,
        "040103": false,
        "040104": false,
        "040201": false,
        "040202": false,
        "040203": false,
        "040204": false,
        "040301": false,
        "040302": false,
        "040303": false,
        "040304": false,
        "040401": false,
        "040402": false,
        "040403": false,
        "040501": false,
        "040502": false,
        "040503": false,
        "050101": false,
        "050102": false,
        "050103": false,
        "050201": false,
        "050202": false,
        "050203": false,
        "050301": false,
        "050302": false,
        "050303": false,
        "050401": false,
        "050402": false,
        "050403": false,
        "050501": false,
        "050502": false,
        "050601": false,
        "050602": false,
        "050603": false,
        "050701": false,
        "050702": false
      }
    };

    dbRef.child(user.uid).set(userData);
  }
}
