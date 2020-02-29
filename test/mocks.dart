import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:time_tracker_app/app/services/auth.dart';

class MockAuth extends Mock implements AuthBase {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}