// import 'package:flutter/material.dart';
// import 'package:pinput/pinput.dart';
// import 'package:smart_auth/smart_auth.dart';

// /// SMS Retriever API implementation using smart_auth package.
// ///
// /// This implementation uses the SMS Retriever API which reads SMS automatically
// /// without requiring permissions. The SMS must contain the app signature.
// class SmsRetrieverApiImpl implements SmsRetriever {
//   const SmsRetrieverApiImpl(this.smartAuth);

//   final SmartAuth smartAuth;

//   @override
//   Future<void> dispose() {
//     return smartAuth.removeSmsListener();
//   }

//   @override
//   Future<String?> getSmsCode() async {
//     try {
//       final res = await smartAuth.getSmsCode();
//       if (res.succeed && res.codeFound) {
//         return res.code!;
//       }
//       return null;
//     } catch (e) {
//       // Handle any errors gracefully
//       debugPrint('SMS Retriever API Error: $e');
//       return null;
//     }
//   }

//   @override
//   bool get listenForMultipleSms => false;
// }

// /// SMS User Consent API implementation using smart_auth package.
// ///
// /// This implementation uses the SMS User Consent API which requires user
// /// approval but doesn't need app signature in the SMS.
// class SmsUserConsentApiImpl implements SmsRetriever {
//   const SmsUserConsentApiImpl(this.smartAuth, {this.phoneNumber});

//   final SmartAuth smartAuth;
//   final String? phoneNumber;

//   @override
//   Future<void> dispose() {
//     return smartAuth.removeSmsListener();
//   }

//   @override
//   Future<String?> getSmsCode() async {
//     try {
//       final res = await smartAuth.getSmsCode(
//         useUserConsentApi: true,
//         senderPhoneNumber: phoneNumber,
//       );
//       if (res.succeed && res.codeFound) {
//         return res.code!;
//       }
//       return null;
//     } catch (e) {
//       // Handle any errors gracefully
//       debugPrint('SMS User Consent API Error: $e');
//       return null;
//     }
//   }

//   @override
//   bool get listenForMultipleSms => false;
// }

// /// Advanced SMS Retriever implementation with enhanced features.
// ///
// /// This implementation provides additional features like:
// /// - Configurable timeout
// /// - Custom code patterns
// /// - Debug logging
// /// - Error handling
// class AdvancedSmsRetrieverImpl implements SmsRetriever {
//   const AdvancedSmsRetrieverImpl(
//     this.smartAuth, {
//     this.useUserConsentApi = false,
//     this.phoneNumber,
//     this.timeout = const Duration(seconds: 60),
//     this.codePattern,
//     this.enableDebugLogging = false,
//     this.onSmsReceived,
//     this.onError,
//   });

//   final SmartAuth smartAuth;
//   final bool useUserConsentApi;
//   final String? phoneNumber;
//   final Duration timeout;
//   final String? codePattern;
//   final bool enableDebugLogging;
//   final void Function(String sms, String? code)? onSmsReceived;
//   final void Function(String error)? onError;

//   @override
//   Future<void> dispose() {
//     return smartAuth.removeSmsListener();
//   }

//   @override
//   Future<String?> getSmsCode() async {
//     try {
//       if (enableDebugLogging) {
//         debugPrint('Starting SMS retrieval...');
//         debugPrint(
//           'Method: ${useUserConsentApi ? 'User Consent API' : 'SMS Retriever API'}',
//         );
//         debugPrint('Phone Number: $phoneNumber');
//         debugPrint('Timeout: ${timeout.inSeconds}s');
//       }

//       final res = await smartAuth
//           .getSmsCode(
//             useUserConsentApi: useUserConsentApi,
//             senderPhoneNumber: phoneNumber,
//           )
//           .timeout(timeout);

//       if (enableDebugLogging) {
//         debugPrint(
//           'SMS Response: succeed=${res.succeed}, codeFound=${res.codeFound}',
//         );
//         debugPrint('Raw SMS: ${res.sms}');
//         debugPrint('Extracted Code: ${res.code}');
//       }

//       if (res.succeed && res.codeFound) {
//         final code = res.code;

//         // Apply custom code pattern if provided
//         if (codePattern != null) {
//           final regex = RegExp(codePattern!);
//           final match = regex.firstMatch(res.sms ?? '');
//           if (match != null) {
//             final extractedCode = match.group(0) ?? code;
//             onSmsReceived?.call(res.sms ?? '', extractedCode);
//             return extractedCode;
//           }
//         }

//         onSmsReceived?.call(res.sms ?? '', code);
//         return code;
//       }

//       if (enableDebugLogging) {
//         debugPrint('No SMS code found');
//       }
//       return null;
//     } catch (e) {
//       final errorMessage = 'SMS Retrieval Error: $e';
//       if (enableDebugLogging) {
//         debugPrint(errorMessage);
//       }
//       onError?.call(errorMessage);
//       return null;
//     }
//   }

//   @override
//   bool get listenForMultipleSms => false;
// }

// /// Factory class for creating SMS retriever implementations.
// class SmsRetrieverFactory {
//   /// Creates an SMS Retriever API implementation.
//   static SmsRetriever createSmsRetrieverApi({
//     SmartAuth? smartAuth,
//     bool enableDebugLogging = false,
//     void Function(String sms, String? code)? onSmsReceived,
//     void Function(String error)? onError,
//   }) {
//     return AdvancedSmsRetrieverImpl(
//       smartAuth ?? SmartAuth(),
//       enableDebugLogging: enableDebugLogging,
//       onSmsReceived: onSmsReceived,
//       onError: onError,
//     );
//   }

//   /// Creates an SMS User Consent API implementation.
//   static SmsRetriever createSmsUserConsentApi({
//     SmartAuth? smartAuth,
//     String? phoneNumber,
//     Duration timeout = const Duration(seconds: 60),
//     String? codePattern,
//     bool enableDebugLogging = false,
//     void Function(String sms, String? code)? onSmsReceived,
//     void Function(String error)? onError,
//   }) {
//     return AdvancedSmsRetrieverImpl(
//       smartAuth ?? SmartAuth(),
//       useUserConsentApi: true,
//       phoneNumber: phoneNumber,
//       timeout: timeout,
//       codePattern: codePattern,
//       enableDebugLogging: enableDebugLogging,
//       onSmsReceived: onSmsReceived,
//       onError: onError,
//     );
//   }

//   /// Creates a basic SMS Retriever API implementation (simple version).
//   static SmsRetriever createBasicSmsRetrieverApi({SmartAuth? smartAuth}) {
//     return SmsRetrieverApiImpl(smartAuth ?? SmartAuth());
//   }

//   /// Creates a basic SMS User Consent API implementation (simple version).
//   static SmsRetriever createBasicSmsUserConsentApi({
//     SmartAuth? smartAuth,
//     String? phoneNumber,
//   }) {
//     return SmsUserConsentApiImpl(
//       smartAuth ?? SmartAuth(),
//       phoneNumber: phoneNumber,
//     );
//   }
// }

// /// Helper widget that provides SMS retriever functionality.
// class SmsRetrieverProvider extends StatefulWidget {
//   const SmsRetrieverProvider({
//     required this.child,
//     super.key,
//     this.enableSmsRetrieverApi = false,
//     this.enableSmsUserConsentApi = false,
//     this.phoneNumber,
//     this.timeout = const Duration(seconds: 60),
//     this.codePattern,
//     this.enableDebugLogging = false,
//     this.onSmsReceived,
//     this.onError,
//   });

//   final Widget child;
//   final bool enableSmsRetrieverApi;
//   final bool enableSmsUserConsentApi;
//   final String? phoneNumber;
//   final Duration timeout;
//   final String? codePattern;
//   final bool enableDebugLogging;
//   final void Function(String sms, String? code)? onSmsReceived;
//   final void Function(String error)? onError;

//   @override
//   State<SmsRetrieverProvider> createState() => _SmsRetrieverProviderState();
// }

// class _SmsRetrieverProviderState extends State<SmsRetrieverProvider> {
//   SmsRetriever? _smsRetriever;

//   @override
//   void initState() {
//     super.initState();
//     _initializeSmsRetriever();
//   }

//   void _initializeSmsRetriever() {
//     if (widget.enableSmsRetrieverApi) {
//       _smsRetriever = SmsRetrieverFactory.createSmsRetrieverApi(
//         enableDebugLogging: widget.enableDebugLogging,
//         onSmsReceived: widget.onSmsReceived,
//         onError: widget.onError,
//       );
//     } else if (widget.enableSmsUserConsentApi) {
//       _smsRetriever = SmsRetrieverFactory.createSmsUserConsentApi(
//         phoneNumber: widget.phoneNumber,
//         timeout: widget.timeout,
//         codePattern: widget.codePattern,
//         enableDebugLogging: widget.enableDebugLogging,
//         onSmsReceived: widget.onSmsReceived,
//         onError: widget.onError,
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _smsRetriever?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return widget.child;
//   }

//   SmsRetriever? get smsRetriever => _smsRetriever;
// }

// /// Extension to provide SMS retriever functionality to widgets.
// extension SmsRetrieverExtension on BuildContext {
//   SmsRetriever? get smsRetriever {
//     final provider = findAncestorStateOfType<_SmsRetrieverProviderState>();
//     return provider?.smsRetriever;
//   }
// }
