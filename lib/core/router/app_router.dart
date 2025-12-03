import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:team_wellness/presentation/screens/auth/login_screen.dart';
import 'package:team_wellness/presentation/screens/auth/onboarding_screen.dart';
import 'package:team_wellness/presentation/screens/auth/profile_blockchain_upload_screen.dart';
import 'package:team_wellness/presentation/screens/auth/profile_sbt_complete_screen.dart';
import 'package:team_wellness/presentation/screens/auth/profile_setup_screen.dart';
import 'package:team_wellness/presentation/screens/auth/sign_up_screen.dart';
import 'package:team_wellness/presentation/screens/coaching/coaching_progress_screen.dart';
import 'package:team_wellness/presentation/screens/coaching/program_detail_screen.dart';
import 'package:team_wellness/presentation/screens/coaching/program_search_screen.dart';
import 'package:team_wellness/presentation/screens/coaching/trainer_detail_screen.dart';
import 'package:team_wellness/presentation/screens/coaching/trainer_search_screen.dart';
import 'package:team_wellness/presentation/screens/community/community_screen.dart';
import 'package:team_wellness/presentation/screens/community/write_post_screen.dart';
import 'package:team_wellness/presentation/screens/home/home_dashboard_screen.dart';
import 'package:team_wellness/presentation/screens/home/main_navigation_screen.dart';
import 'package:team_wellness/presentation/screens/profile/activity_detail_screen.dart';
import 'package:team_wellness/presentation/screens/profile/my_page_screen.dart';
import 'package:team_wellness/presentation/screens/splash/splash_screen.dart';
import 'package:team_wellness/presentation/screens/wallet/reward_wallet_screen.dart';
import 'package:team_wellness/presentation/screens/analysis/sbt_analysis_screen.dart';
import 'package:team_wellness/presentation/screens/trainer/trainer_education_screen.dart';
import 'package:team_wellness/presentation/screens/trainer/trainer_certification_screen.dart';
import 'package:team_wellness/presentation/screens/trainer/trainer_performance_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _sectionHomeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'sectionHome');
final GlobalKey<NavigatorState> _sectionSearchNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'sectionSearch');
final GlobalKey<NavigatorState> _sectionCommunityNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'sectionCommunity');
final GlobalKey<NavigatorState> _sectionWalletNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'sectionWallet');
final GlobalKey<NavigatorState> _sectionProfileNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'sectionProfile');

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: <RouteBase>[
      // --- Splash ---
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      // --- Auth & Onboarding ---
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/profile-setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      GoRoute(
        path: '/profile-upload',
        builder: (context, state) => const ProfileBlockchainUploadScreen(),
      ),
      GoRoute(
        path: '/profile-complete',
        builder: (context, state) => const ProfileSbtCompleteScreen(),
      ),

      // --- Main Shell (Bottom Navigation) ---
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainNavigationScreen(navigationShell: navigationShell);
        },
        branches: [
          // Tab 1: Home
          StatefulShellBranch(
            navigatorKey: _sectionHomeNavigatorKey,
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeDashboardScreen(),
                routes: [
                   // Sub-routes from Home that should hide bottom nav? 
                   // Typically "parentNavigatorKey: _rootNavigatorKey" is used if you want to cover the tabs.
                   // For now, we'll keep them inside the stack or root depending on UX.
                   // Let's put details on ROOT navigator to hide bottom bar.
                ],
              ),
            ],
          ),

          // Tab 2: Search (Trainer/Program)
          StatefulShellBranch(
            navigatorKey: _sectionSearchNavigatorKey,
            routes: [
              GoRoute(
                path: '/search',
                builder: (context, state) => const TrainerSearchScreen(),
                routes: [
                   GoRoute(
                    path: 'program', // /search/program
                    builder: (context, state) => const ProgramSearchScreen(),
                  ),
                ],
              ),
            ],
          ),

          // Tab 3: Community
          StatefulShellBranch(
            navigatorKey: _sectionCommunityNavigatorKey,
            routes: [
              GoRoute(
                path: '/community',
                builder: (context, state) => const CommunityScreen(),
              ),
            ],
          ),

          // Tab 4: Wallet
          StatefulShellBranch(
            navigatorKey: _sectionWalletNavigatorKey,
            routes: [
              GoRoute(
                path: '/wallet',
                builder: (context, state) => const RewardWalletScreen(),
              ),
            ],
          ),

          // Tab 5: Profile
          StatefulShellBranch(
            navigatorKey: _sectionProfileNavigatorKey,
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const MyPageScreen(),
              ),
            ],
          ),
        ],
      ),

      // --- Root Level Detail Routes (Hide Bottom Nav) ---
      GoRoute(
        path: '/community/write',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const WritePostScreen(),
      ),
      GoRoute(
        path: '/coaching/trainer/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return TrainerDetailScreen(trainerId: id);
        },
      ),
      GoRoute(
        path: '/coaching/program/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ProgramDetailScreen(programId: id);
        },
      ),
      GoRoute(
        path: '/coaching/progress/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return CoachingProgressScreen(programId: id);
        },
      ),
      GoRoute(
        path: '/profile/activity/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ActivityDetailScreen(activityId: id);
        },
      ),
      // --- SBT Analysis ---
      GoRoute(
        path: '/analysis/sbt',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SbtAnalysisScreen(),
      ),
      // --- Trainer Management ---
      GoRoute(
        path: '/trainer/education',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const TrainerEducationScreen(),
      ),
      GoRoute(
        path: '/trainer/certification',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const TrainerCertificationScreen(),
      ),
      GoRoute(
        path: '/trainer/performance',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const TrainerPerformanceScreen(),
      ),
    ],
  );
}
