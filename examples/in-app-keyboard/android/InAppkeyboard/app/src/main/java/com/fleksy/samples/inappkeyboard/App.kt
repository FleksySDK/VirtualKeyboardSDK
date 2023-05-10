package com.fleksy.samples.inappkeyboard

import android.app.Application
import android.util.Log
import co.thingthing.fleksy.core.keyboard.inapp.InAppKeyboardSDK

class App : Application() {

    override fun onCreate() {
        super.onCreate()

        val integration = Integration(applicationContext)

        InAppKeyboardSDK.initialise(integration)

        val integration2 = InAppKeyboardSDK.integration

        Log.e("OPI", "$integration2")
    }
}