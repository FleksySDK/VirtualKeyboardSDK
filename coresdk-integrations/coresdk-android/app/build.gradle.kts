plugins {
    id("com.android.application")
    kotlin("android")
    kotlin("kapt")
    id("dagger.hilt.android.plugin")
}

android {
    compileSdk = 32
    buildToolsVersion = "30.0.3"

    defaultConfig {
        applicationId = "co.thingthing.fleksy.lib.app"
        minSdk = 24
        targetSdk = 32
        versionCode = 1
        versionName = "1.0.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"

        buildConfigField(
            "String",
            "SDK_LICENSE_KEY",
            "\"${project.properties["fleksy_lib_license_key"].toString()}\""
        )
        buildConfigField(
            "String",
            "SDK_LICENSE_SECRET",
            "\"${project.properties["fleksy_lib_license_secret"].toString()}\""
        )
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }

    }

    flavorDimensions.add("environment")

    productFlavors {
        create("production") {
            dimension = "environment"
        }
        create("staging") {
            dimension = "environment"
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    buildFeatures {
        viewBinding = true
    }
}

dependencies {
    implementation("co.thingthing.fleksylib:fleksylib-release:1.0.1")
    implementation("androidx.core:core-ktx:1.8.0")
    implementation("androidx.appcompat:appcompat:1.5.0")
    implementation("com.google.android.material:material:1.6.1")
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.6.4")

    //Hilt
    implementation("com.google.dagger:hilt-android:2.43.2")
    kapt("com.google.dagger:hilt-android-compiler:2.43.2")

    //navigation
    implementation("androidx.navigation:navigation-fragment-ktx:2.5.1")
    implementation("androidx.navigation:navigation-ui-ktx:2.5.1")

    testImplementation("junit:junit:4.13.2")
    androidTestImplementation("androidx.test.ext:junit:1.1.3")
    androidTestImplementation("androidx.test.espresso:espresso-core:3.4.0")
}