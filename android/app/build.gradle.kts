import java.io.File

plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

val releaseKeystore = rootProject.file("keystore/neonbreaker-release.jks")

val releaseStorePassword =
    System.getenv("RELEASE_STORE_PASSWORD")
        ?: throw GradleException("RELEASE_STORE_PASSWORD missing")

val releaseKeyPassword =
    System.getenv("RELEASE_KEY_PASSWORD")
        ?: throw GradleException("RELEASE_KEY_PASSWORD missing")

val releaseKeyAlias =
    System.getenv("RELEASE_KEY_ALIAS")
        ?: throw GradleException("RELEASE_KEY_ALIAS missing")

if (!releaseKeystore.exists()) {
    throw GradleException(
        "Release keystore not found: ${releaseKeystore.absolutePath}"
    )
}

android {
    namespace = "hassadi.neonbreaker.pro"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "hassadi.neonbreaker.pro"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = releaseKeyAlias
            keyPassword = releaseKeyPassword
            storePassword = releaseStorePassword
            storeFile = releaseKeystore
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
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
