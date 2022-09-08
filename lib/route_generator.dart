
import 'package:get/get.dart';

import 'modules/contact_us/view.dart';
import 'modules/edit_profile/view.dart';
import 'modules/favourites/view.dart';
import 'modules/forget_password.dart/view.dart';
import 'modules/home/view.dart';
import 'modules/login/view.dart';
import 'modules/login/view_phone_login.dart';
import 'modules/my_bookings/view.dart';
import 'modules/pending_review/view.dart';
import 'modules/sign_up/view.dart';
import 'modules/profile/view.dart';
import 'modules/splash/view.dart';


routes() => [
      GetPage(name: "/splash", page: () => const SplashPage()),
      GetPage(name: "/login", page: () => const LoginPage()),
      GetPage(name: "/phoneLogin", page: () => const PhoneLoginView()),
      GetPage(name: "/signUp", page: () => const SignUpPage()),
      GetPage(name: "/MyBooking", page: () => const AllBookingPage()),
      GetPage(name: "/home", page: () => const Home()),


      GetPage(name: "/profile", page: () => const ProfilePage()),
      GetPage(name: "/editProfile", page: () => const EditProfilePage()),
      GetPage(name: "/pendingReview", page: () => const PendingReviewPage()),
      GetPage(name: "/contactUs", page: () => const ContactUs()),
      GetPage(name: "/favourites", page: () => const FavouritesPage()),
      GetPage(name: "/forgetPassword", page: () => const ForgotPassword()),
    ];

class PageRoutes {
  static const String splash = '/splash';
  static const String search = '/search';
  static const String myBooking = '/MyBooking';
  static const String login = '/login';
  static const String phoneLogin = '/phoneLogin';
  static const String signUp = '/signUp';
  static const String home = '/home';
  static const String productDetail = '/productDetail';
  static const String shopDetail = '/shopDetail';
  static const String cart = '/cart';
  static const String payment = '/payment';
  static const String allOrders = '/allOrders';
  static const String profile = '/profile';
  static const String editProfile = '/editProfile';
  static const String pendingReview = '/pendingReview';
  static const String contactUs = '/contactUs';
  static const String coupons = '/coupons';
  static const String privacyPolicy = '/privacyPolicy';
  static const String favourites = '/favourites';
  static const String savedCards = '/savedCards';
  static const String notifications = '/notifications';
  static const String onBoard = '/onBoard';
  static const String map = '/map';
  static const String preferences = '/preferences';
  static const String forgetPassword = '/forgetPassword';

 
}
