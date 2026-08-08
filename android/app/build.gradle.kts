/**
 * Tên file: build.gradle.kts
 * Tên tác giả: La Văn Thanh
 * Mô tả: Cấu hình Gradle cho module app của Android. Đã sửa lỗi cú pháp Kotlin DSL cho tính năng Desugaring để hỗ trợ Notification. [WEBVNZ.COM]
 */

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.moc_kinh"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // Đã sửa lại đúng cú pháp Kotlin DSL
        isCoreLibraryDesugaringEnabled = true 
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.moc_kinh"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Đã sửa lại đúng cú pháp Kotlin DSL (có ngoặc đơn và ngoặc kép)
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}