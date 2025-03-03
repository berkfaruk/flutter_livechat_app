import 'package:flutter_livechat_app/repository/user_repository.dart';
import 'package:flutter_livechat_app/services/fake_auth_service.dart';
import 'package:flutter_livechat_app/services/firebase_auth_service.dart';
import 'package:flutter_livechat_app/services/firebase_storage_service.dart';
import 'package:flutter_livechat_app/services/firestore_db_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthService());
  locator.registerLazySingleton(() => FirestoreDBService());
  locator.registerLazySingleton(() => FirebaseStorageService());
  locator.registerLazySingleton(() => UserRepository());
}