import java.util.Properties

plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

// Official signing is OPTIONAL at the Gradle-script level: it's only
// required when key.properties actually exists (created from secrets
// in release.yml). Plain CI builds (android.yml) that don't create it
// still build fine, just debug-signed.
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
val hasOfficialSigning = keystorePropertiesFile.exists()

if (hasOfficialSigning) {
    keystorePropertiesFile.inputStream().use { input ->
        keystoreProperties.load(input)
    }
}

val releaseKeystore = rootProject.file("keystore/neonbreaker-release.jks")

val releaseStorePassword = keystoreProperties.getProperty("storePassword")
val releaseKeyPassword = keystoreProperties.getProperty("keyPassword")
val releaseKeyAlias = keystoreProperties.getProperty("keyAlias")

if (hasOfficialSigning) {
    require(releaseStorePassword != null) { "storePassword missing" }
    require(releaseKeyPassword != null) { "keyPassword missing" }
    require(releaseKeyAlias != null) { "keyAlias missing" }
    require(releaseKeystore.isFile) {
        "Release keystore not found: ${releaseKeystore.absolutePath}"
    }
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
        if (hasOfficialSigning) {
            create("release") {
                keyAlias = releaseKeyAlias
                keyPassword = releaseKeyPassword
                storePassword = releaseStorePassword
                storeFile = releaseKeystore
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (hasOfficialSigning) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
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
