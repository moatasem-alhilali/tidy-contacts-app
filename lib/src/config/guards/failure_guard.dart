import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_manager/src/config/guards/base_guard.dart';
import 'package:hive_manager/src/core/provider/auto_route_notifier.dart';

/// A route guard that handles redirection based on the user's authentication state.
///
/// - If the user is not authenticated, they are redirected to the onboarding flow.
/// - If the user is in a "start-up" state and has biometric enabled but expired refresh token,
///   they are redirected to the biometric login screen.
/// - If the user is in a "start-up" state without biometric, they are redirected to the login screen.
/// - Otherwise, navigation proceeds as normal.
class FailureGuard extends BaseGuard {
  FailureGuard(this.ref);
  final Ref ref;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final autoRouteNotifier = ref.read(autoRouteProvider);
    final failureCode = autoRouteNotifier.failure?.code;

    // if (autoRouteNotifier.hasJailbreakOrRoot &&
    //     resolver.route.name !=
    //         onboarding.OnboardingDeviceUnavailableRoute.name) {
    //   resolver.redirectUntil(
    //     const onboarding.OnboardingDeviceUnavailableRoute(),
    //   );
    //   return;
    // }

    // if (autoRouteNotifier.isVpnConnected &&
    //     resolver.route.name != onboarding.OnboardingVpnProblemRoute.name) {
    //   resolver.redirectUntil(
    //     onboarding.OnboardingVpnProblemRoute(onResult: resolver.next),
    //   );
    //   return;
    // }

    // if (!autoRouteNotifier.hasInternet &&
    //     resolver.route.name != onboarding.OnboardingNoInternetRoute.name) {
    //   resolver.redirectUntil(
    //     onboarding.OnboardingNoInternetRoute(onResult: resolver.next),
    //   );
    //   return;
    // }

    // if (autoRouteNotifier.underMaintenance &&
    //     resolver.route.name !=
    //         onboarding.OnboardingUnderMaintenanceRoute.name) {
    //   resolver.redirectUntil(
    //     onboarding.OnboardingUnderMaintenanceRoute(onResult: resolver.next),
    //   );
    //   return;
    // }

    // if ((failureCode == FailureCode.SEC_003 ||
    //         autoRouteNotifier.failure?.statusCode == 401) &&
    //     resolver.route.name != onboarding.AuthPinLoginRoute.name &&
    //     resolver.route.name != onboarding.AuthLoginRoute.name) {
    //   resolver.redirectUntil(
    //     onboarding.AuthPinLoginRoute(
    //       onResult: resolver.next,
    //     ),
    //   );
    //   return;
    // }
    // if ((failureCode == FailureCode.SEC_001 ||
    //         autoRouteNotifier.failure?.statusCode == 402) &&
    //     resolver.route.name != onboarding.AuthLoginRoute.name) {
    //   router.pushAndPopUntil(
    //     const onboarding.AuthLoginRoute(),
    //     predicate: (route) => false,
    //   );
    // } else if ((failureCode == FailureCode.KYC_001 ||
    //         failureCode == FailureCode.KYC_003) &&
    //     resolver.route.name != kyc.KYCSetupNotFullySetupRoute.name) {
    //   router.push(
    //     kyc.KYCSetupNotFullySetupRoute(),
    //   );
    // } else if ((failureCode == FailureCode.KYC_002) &&
    //     resolver.route.name != kyc.KycUpdateRoute.name) {
    //   router.push(
    //     const kyc.KycUpdateRoute(),
    //   );
    // } else if ((failureCode == FailureCode.WTHD_003) &&
    //     resolver.route.name !=
    //         smartBasket.SmartBasketWithdrawWaitDaysRoute.name) {
    //   router.push(
    //     smartBasket.SmartBasketWithdrawWaitDaysRoute(
    //       description: autoRouteNotifier.failure!.message,
    //       errorCode: autoRouteNotifier.failure!.code,
    //     ),
    //   );
    // } else if ((failureCode == FailureCode.ACC_002) &&
    //     resolver.route.name != profile.BlockAccountErrorRoute.name) {
    //   router.push(
    //     const profile.BlockAccountErrorRoute(),
    //   );
    // } else if ([
    //       FailureCode.FND_001,
    //       FailureCode.FND_002,
    //       FailureCode.FND_004,
    //       FailureCode.BAL_001,
    //       FailureCode.FND_005,
    //     ].contains(failureCode) &&
    //     resolver.route.name != wallet.WalletFundErrorRoute.name) {
    //   router.push(
    //     wallet.WalletFundErrorRoute(
    //       errorMessage: autoRouteNotifier.failure!.message,
    //     ),
    //   );
    // } else if ((failureCode == FailureCode.USR_001) &&
    //     resolver.route.name != kyc.KYCAddEmailRoute.name) {
    //   router.push(
    //     kyc.KYCAddEmailRoute(),
    //   );
    // } else if ((failureCode == FailureCode.KYC_004 ||
    //         failureCode == FailureCode.KYC_005) &&
    //     resolver.route.name != kyc.KYCIdentityErrorRoute.name) {
    //   router.push(
    //     kyc.KYCIdentityErrorRoute(
    //       errorMessage: autoRouteNotifier.failure!.message,
    //     ),
    //   );
    // } else if ([
    //       FailureCode.INV_001,
    //       FailureCode.INV_002,
    //       FailureCode.INV_003,
    //       FailureCode.INV_004,
    //       FailureCode.INV_005,
    //       FailureCode.INV_007,
    //       FailureCode.INV_008,
    //       FailureCode.INV_009,
    //     ].contains(autoRouteNotifier.failure?.code) &&
    //     resolver.route.name !=
    //         smartBasket.SmartBasketOperationErrorRoute.name) {
    //   router.push(
    //     smartBasket.SmartBasketOperationErrorRoute(
    //       errorMessage: autoRouteNotifier.failure!.message,
    //     ),
    //   );
    // }
    ref.read(autoRouteProvider.notifier).clearFailure();
    resolver.next();
  }
}
