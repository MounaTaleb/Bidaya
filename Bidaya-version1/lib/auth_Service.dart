import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // 📝 Inscription avec Email + Mot de passe
  Future<UserCredential?> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ✅ Envoyer email de vérification automatiquement
      await userCredential.user?.sendEmailVerification();

      print('📧 Email de vérification envoyé à $email');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseException(e);
    }
  }

  // 🔑 Connexion avec Email + Mot de passe
  Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseException(e);
    }
  }

  Future<bool> isEmailVerified() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.reload(); // Recharger les données
      return user.emailVerified; // Retourner le statut
    }
    return false;
  }

  // 🔄 Renvoyer email de vérification
  Future<void> resendVerificationEmail() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
        print('📧 Email de vérification renvoyé');
      }
    } catch (e) {
      throw 'Erreur lors de l\'envoi: $e';
    }
  }

  // 🔐 Connexion avec Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw 'Connexion Google annulée';
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      print('✅ Connecté avec Google: ${userCredential.user?.email}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseException(e);
    } catch (e) {
      throw 'Erreur Google Sign-In: $e';
    }
  }

  // 👤 Obtenir l'utilisateur actuel
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // 🚪 Déconnexion
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      print('✅ Déconnecté');
    } catch (e) {
      throw 'Erreur lors de la déconnexion: $e';
    }
  }

  // 📊 Stream de l'état d'authentification
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ⚠️ Gestion des erreurs Firebase
  String _handleFirebaseException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'كلمة المرور ضعيفة جداً (6 أحرف على الأقل)';
      case 'email-already-in-use':
        return 'هذا البريد الإلكتروني مسجل بالفعل';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صحيح';
      case 'user-not-found':
        return 'لم يتم العثور على حساب بهذا البريد';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      case 'user-disabled':
        return 'هذا الحساب معطّل';
      case 'too-many-requests':
        return 'محاولات كثيرة جداً، حاول لاحقاً';
      case 'operation-not-allowed':
        return 'هذه العملية غير مسموحة';
      case 'network-request-failed':
        return 'خطأ في الاتصال بالإنترنت';
      default:
        return 'خطأ: ${e.message ?? e.code}';
    }
  }
}
