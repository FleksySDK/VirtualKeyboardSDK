package com.fleksy.samples.downloadlanguage.languages

import android.content.Context
import android.content.SharedPreferences

object SettingsStore {

    private const val PREFERENCES_LANGUAGES_STORE_KEY =
        "UserLanguageStore.PREFERENCES_LANGUAGES_STORE_KEY"

    private fun getSharedPreferences(context: Context): SharedPreferences {
        return context.createDeviceProtectedStorageContext()
            .getSharedPreferences(PREFERENCES_LANGUAGES_STORE_KEY, Context.MODE_PRIVATE)
    }

    fun putString(context: Context, key: String, value: String) {
        getSharedPreferences(context).edit().putString(key, value).apply()
    }

    fun clearSetting(context: Context, key: String) {
        getSharedPreferences(context).edit().remove(key).apply()
    }

    fun getString(context: Context, key: String): String? {
        return getSharedPreferences(context).getString(key, null)
    }
}