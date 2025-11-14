plugin {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.my_app"

    // 👇 Update compileSdk & targetSdk to 35 (required by your plugins)
    compileSdk = 35

    defaultConfig {
        applicationId = "com.example.my_app"
        minSdk = 21
        targetSdk = 35   // 👈 update this too
        versionCode = 1
        versionName = "1.0"
    }

    // 👇 Update NDK version (required by plugins)
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }
}

flutter {
    source = "../.."
}