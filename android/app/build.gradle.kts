plugins {
    id("com.android.application")
<<<<<<< HEAD
=======
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
>>>>>>> ac60c1bc376d2a7e2377722d10da3f4e38a7f18c
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
<<<<<<< HEAD
    namespace = "com.example.bideya"
=======
    namespace = "com.example.bidaya"
>>>>>>> ac60c1bc376d2a7e2377722d10da3f4e38a7f18c
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
<<<<<<< HEAD
=======

        // ⭐ OBLIGATOIRE pour flutter_local_notifications
        isCoreLibraryDesugaringEnabled = true
>>>>>>> ac60c1bc376d2a7e2377722d10da3f4e38a7f18c
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
<<<<<<< HEAD
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.bideya"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
=======
        applicationId = "com.example.bidaya"
>>>>>>> ac60c1bc376d2a7e2377722d10da3f4e38a7f18c
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
<<<<<<< HEAD
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
=======
>>>>>>> ac60c1bc376d2a7e2377722d10da3f4e38a7f18c
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
<<<<<<< HEAD
=======

dependencies {
    // ⭐ OBLIGATOIRE : librairie de desugaring
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
>>>>>>> ac60c1bc376d2a7e2377722d10da3f4e38a7f18c
