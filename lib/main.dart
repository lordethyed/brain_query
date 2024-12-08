import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:brain_quert/src/common/util/app_zone.dart';
import 'package:brain_quert/src/common/util/error_util.dart';
import 'package:brain_quert/src/common/widget/app.dart';
import 'package:brain_quert/src/common/widget/app_error.dart';
import 'package:brain_quert/src/feature/initialization/data/initialization.dart';
import 'package:brain_quert/src/feature/settings/widget/settings_scope.dart';
import 'package:octopus/octopus.dart';
import 'package:platform_info/platform_info.dart';

void main() => appZone(
      () async {
        // Splash screen
        final initializationProgress = ValueNotifier<({int progress, String message})>((progress: 0, message: ''));
        /* runApp(SplashScreen(progress: initializationProgress)); */
        $initializeApp(
          onProgress: (progress, message) => initializationProgress.value = (progress: progress, message: message),
          onSuccess: (dependencies) => runApp(
            dependencies.inject(
              child: SettingsScope(
                child: NoAnimationScope(
                  noAnimation: platform.js || platform.desktop,
                  child: const App(),
                ),
              ),
            ),
          ),
          onError: (error, stackTrace) {
            runApp(AppError(error: error));
            ErrorUtil.logError(error, stackTrace).ignore();
          },
        ).ignore();
      },
    );
