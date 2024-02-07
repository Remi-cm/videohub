import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';
import 'package:videohub/core/models/orphanage_model.dart';
import 'package:videohub/g4all.dart';
import 'dart:io';
import 'core/providers/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/providers/user_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 15));
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
  //Firebase.initializeApp();
  initializeDateFormatting('fr_FR');
  if(kIsWeb){
    //setUrlStrategy(PathUrlStrategy());
  }
  else {
    Directory directory = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(directory.path);
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider(isSignedIn: null, user: null),),
      ],
      child: ChangeNotifierProvider<ThemeProvider>(
        create: (_) => ThemeProvider(false),
        child: const G4All()
      ),
    )
  );
}
