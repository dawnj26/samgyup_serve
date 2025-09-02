import 'dart:async';
import 'dart:developer';

import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cache_repository/cache_repository.dart';
import 'package:flutter/widgets.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  await CacheRepository.initialize();
  await AppwriteRepository.initialize(
    environment: const Environment(
      appwritePublicEndpoint: 'https://syd.cloud.appwrite.io/v1',
      appwriteProjectId: '689ae709000e4caab4c5',
      appwriteProjectName: 'Samgyup Serve',
      databaseId: '689b1bd20018b604c958',
      inventoryCollectionId: '68a0142300285aedc1e0',
      menuCollectionId: '68a9869d001723644444',
      menuIngredientsCollectionId: '68a9a529003b46dde3f2',
      storageBucketId: '68a46eed00337cbc0a5f',
      packageCollectionId: '68b19d02000a97f35693',
    ),
  );

  runApp(await builder());
}
