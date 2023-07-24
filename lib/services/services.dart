import 'dart:convert';
import 'dart:io';

import 'package:bigexpress_customer/models/models.dart';
import 'package:bigexpress_customer/models/payment_list_model.dart';
import 'package:bigexpress_customer/shared/shared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:html/parser.dart' show parse;

part 'util_service.dart';
part 'auth_service.dart';
part 'item_service.dart';
part 'maps_service.dart';
part 'address_services.dart';
part 'order_service.dart';
part 'topup_service.dart';
part 'chat_service.dart';
part 'finance_service.dart';
