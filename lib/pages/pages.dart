import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bigexpress_customer/pages/topup_page/topup_list_payment_page.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mapTool;
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart' as wv;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:bigexpress_customer/cubits/cubits.dart';
import 'package:bigexpress_customer/models/models.dart';
import 'package:bigexpress_customer/services/services.dart';
import 'package:bigexpress_customer/shared/shared.dart';
import 'package:bigexpress_customer/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';
import 'dart:math' show cos, sqrt, asin;

import 'package:webview_flutter/webview_flutter.dart';

part 'splash_screen.dart';

//main page
part 'main_page/main_page.dart';
part 'main_page/widgets/bottom_nav_bar.dart';
part 'main_page/help_page.dart';

//auth
part 'authentication/sign_in_modal.dart';
part 'authentication/otp_page.dart';
part 'authentication/profile_form_page.dart';

part 'home_page/home_page.dart';
part 'home_page/dot_indicator.dart';

part 'reward_page/reward_detail_page.dart';
part 'reward_page/reward_list_page.dart';
part 'reward_page/reward_preview_widget.dart';

part 'account_page/account_page.dart';

part 'item_page/item_list_page.dart';
part 'item_page/item_form_page.dart';

part 'address_page/address_form_page.dart';
part 'address_page/address_list_page.dart';
part 'address_page/address_search_page.dart';

part 'order_page/order_page.dart';
part 'order_page/pick_driver_page.dart';
part 'order_page/select_payment_page.dart';
part 'order_page/pick_voucher_page.dart';

part 'topup_page/topup_page.dart';
part 'topup_page/topup_list_page.dart';
part 'topup_page/topup_select_payment_page.dart';
part 'topup_page/topup_confirmation_page.dart';
part 'topup_page/topup_webview.dart';
part 'topup_page/payment_status_page.dart';
part 'topup_page/finish_payment_page.dart';

part 'transaction_page/transaction_list_page.dart';
part 'transaction_page/transaction_detail_page.dart';

part 'main_page/chat_room_page.dart';
part 'main_page/notification_page.dart';
part 'app_locked_page.dart';
