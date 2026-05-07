import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:icdevicemanager_flutter/ic_bluetooth_sdk.dart';
import 'package:icdevicemanager_flutter/icdevicemanager_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/app_env.dart';
import 'models/app_models.dart';
import 'services/api_service.dart';
import 'services/health_service.dart';
import 'theme/app_palette.dart';

part 'app/app_routes.dart';
part 'app/kinetic_app.dart';
part 'app/home_flow.dart';
part 'screens/marketing_screen.dart';
part 'screens/login_screen.dart';
part 'screens/signup_screen.dart';
part 'screens/dashboard_screens.dart';
part 'screens/profile_screen.dart';
part 'screens/profile_edit_screen.dart';
part 'screens/create_challenge_screen.dart';
part 'screens/challenge_detail_screen.dart';
part 'screens/challenge_screens.dart';
part 'screens/body_composition_screen.dart';
part 'screens/logout_loading_screen.dart';
part 'components/profile_components.dart';
part 'components/navigation.dart';
part 'components/cards.dart';
part 'components/auth_controls.dart';
part 'components/buttons.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String? startupError;
  try {
    await dotenv.load(fileName: '.env');
  } catch (error) {
    startupError = 'Unable to load .env: $error';
  }

  runApp(KineticApp(startupError: startupError));
}
