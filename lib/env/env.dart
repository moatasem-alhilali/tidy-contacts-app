// lib/prod_env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(name: 'Env', path: '.env', obfuscate: true)
final class Env {
  @override
  @EnviedField(varName: 'BASE_URL')
  // static String BASE_URL = _Env.BASE_URL;
  static String BASE_URL = 'https://iso-click.com/api';

  static String BASE = 'https://iso-click.com';
  // static String BASE_URL = 'https://dev.pinpaiss.net/api/v1';
}
