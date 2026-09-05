import java.util.Properties

plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")

if (!keystorePropertiesFile.exists()) {
    throw GradleException(
        "android/key.properties missing"
    )
}

keystorePropertiesFile.inputStream().use { input ->
    keystoreProperties.load(input)
}

val releaseKeystore = rootProject.file(
    "keystore/neonbreaker-release.jks"
)

val releaseStorePassword =
    keystoreProperties.getProperty("storePassword")
        ?: throw GradleException("storePassword missing")

val releaseKeyPassword =
    keystoreProperties.getProperty("keyPassword")
        ?: throw GradleException("keyPassword missing")

val releaseKeyAlias =
    keystoreProperties.getProperty("keyAlias")
        ?: throw GradleException("keyAlias missing")

if (!releaseKeystore.isFile) {
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
