import 'package:cloud_firestore/cloud_firestore.dart';
import 'model.dart';


class firebaseService {
  final CollectionReference usersCollection = FirebaseFirestore.instance
      .collection('contexts');

  Future<void> addUserToFirestore(User user, String userID) async {
    try {
      user.userId = userID;
      Map<String, dynamic> userData = user.toJson();

      DocumentReference userDocRef = usersCollection.doc(userID);
      await userDocRef.set(userData);
    } catch (e) {
      print('Error adding user to Firestore: $e');
    }
  }

  Future<void> createtoFirestore(String userID) async {
    User user = User(userId: userID, contexts: []);
    await addUserToFirestore(user, userID);
  }


  Future<void> addContextToUser(String userId, Context context) async {
    try {
      Map<String, dynamic> contextData = context.toJson();

      DocumentReference userDocRef = usersCollection.doc(userId);

      await userDocRef.update({
        'contexts': FieldValue.arrayUnion([contextData]),
      });

    } catch (e) {
      print('Error adding context to Firestore: $e');
    }
  }



  Future<User?> getUserFromFirestore(String userId) async {
    try {
      DocumentSnapshot userDocSnapshot = await usersCollection.doc(userId).get();
      if (userDocSnapshot.exists) {
        User user = User.fromJson(userDocSnapshot.data() as Map<String, dynamic>);
        return user;
      }
    } catch (e) {
      return null;
    }
  }


  Future<void> addNewsToContext(String userId, String contextId, News news) async {
    try {
      Map<String, dynamic> newsData = news.toJson();

      DocumentReference userDocRef = usersCollection.doc(userId);

      DocumentSnapshot userData = await userDocRef.get();
      Map<String, dynamic>? userDataMap = userData.data() as Map<String, dynamic>?;

      int contextIndex = -1;
      List<dynamic> contexts = userDataMap?['contexts'] ?? [];
      for (int i = 0; i < contexts.length; i++) {
        if (contexts[i]['contextId'] == contextId) {
          contextIndex = i;
          break;
        }
      }

      if (contextIndex != -1) {
        contexts[contextIndex]['news'] = [...(contexts[contextIndex]['news'] ?? []), newsData];

        await userDocRef.update({'contexts': contexts});

      }
    } catch (e) {
      print('Error adding news to Firestore: $e');
    }
  }



}