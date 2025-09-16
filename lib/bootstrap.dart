import 'dart:async';
import 'dart:developer';

import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log(
      '\n🔄 STATE CHANGE\n'
      '   Bloc: ${bloc.runtimeType}\n'
      '   From: ${change.currentState}\n'
      '   To:   ${change.nextState}',
      name: 'BlocObserver',
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log(
      '\n❌ BLOC ERROR\n'
      '   Bloc: ${bloc.runtimeType}\n'
      '   Error: $error\n'
      '   Stack: ${stackTrace.toString().split('\n').take(3).join('\n')}',
      name: 'BlocObserver',
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

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
      tableCollectionId: '68bad636002d8c251fd0',
      deviceCollectionId: '68c13f6f0034f3a61008',
      orderCollectionId: '68c5090f000f2fdf9840',
      reservationCollectionId: '68c7c9f9002641fe6f53',
      invoiceCollectionId: '68c9388e001187b3f52a',
    ),
  );

  runApp(await builder());
}
