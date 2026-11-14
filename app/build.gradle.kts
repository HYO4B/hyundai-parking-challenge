plugins {
    id("com.android.application")
}

android {
    namespace = "kr.ssadaparking.demo"
    compileSdk = 34

    defaultConfig {
        applicationId = "kr.ssadaparking.demo"
        minSdk = 28
        targetSdk = 34
        versionCode = 1
        versionName = "0.1.0"
    }

    // Keep the signed test candidate separate from the existing demo install.
    buildTypes {
        getByName("release") {
            applicationIdSuffix = ".releasecandidate"
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
}
