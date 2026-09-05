import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()

if (!keystorePropertiesFile.exists()) {
    throw GradleException("android/key.properties not found")
}

keystoreProperties.load(FileInputStream(keystorePropertiesFile))

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
            keyAlias = keystoreProperties.getProperty("keyAlias")
                ?: throw GradleException("keyAlias missing")

            keyPassword = keystoreProperties.getProperty("keyPassword")
                ?: throw GradleException("keyPassword missing")

            storePassword = keystoreProperties.getProperty("storePassword")
                ?: throw GradleException("storePassword missing")

            storeFile = rootProject.file(
                keystoreProperties.getProperty("storeFile")
                    ?: throw GradleException("storeFile missing")
            )
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
