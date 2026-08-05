import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_manager/src/core/models/session.dart';
import 'package:hive_manager/src/core/network/dio/api_keys.dart';
import 'package:hive_manager/src/core/provider/language_state.dart';

import 'package:hive_manager/src/core/utils/logger.dart';

// import 'package:hive_manager/src/core/network/dio/api_keys.dart';
// import 'package:hive_manager/src/core/provider/language_state.dart';
// import 'package:hive_manager/src/features/onboarding/presentation/providers/authentication/session_state.dart';
// import 'package:hive_manager/src/features/profile/presentation/providers/profile_state.dart';
// import 'package:hive_manager/src/features/profile/presentation/providers/session_timeout_provider.dart';

part 'dio_add_language_interceptor.dart';
part 'dio_error_retry_interceptor.dart';
part 'network_info.dart';
