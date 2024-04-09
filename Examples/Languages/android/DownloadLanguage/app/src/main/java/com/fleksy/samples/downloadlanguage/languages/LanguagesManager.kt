package com.fleksy.samples.downloadlanguage.languages

import android.content.Context
import android.util.Log
import android.widget.Toast
import co.thingthing.fleksy.core.languages.KeyboardLanguage
import co.thingthing.fleksy.core.languages.LanguagesHelper
import co.thingthing.fleksy.services.amazon.DownloadListener

object LanguagesManager {

    private const val PREFERENCE_CURRENT_LANGUAGES_KEY =
        "UserLanguageStore.PREFERENCE_CURRENT_LANGUAGES_KEY"

    private const val DEFAULT_LANGUAGE = "en-US"

    /**
     * Returns all locally available languages in the SDK. This method is recommended as it removes
     * the need for the app to track which languages are downloaded.
     */
    fun getUserLanguages(context: Context): Set<String> = LanguagesHelper.storedLocales(context)

    /**
     * The language that is currently active in the keyboard is tracked for convenience. In the case
     * that the keyboard's configuration is reloaded, the app may provide the saved current
     * language.
     */
    fun getCurrentLanguage(context: Context): String =
        SettingsStore.getString(context, PREFERENCE_CURRENT_LANGUAGES_KEY) ?: DEFAULT_LANGUAGE

    fun setCurrentLanguage(context: Context, locale: String) {
        SettingsStore.putString(context, PREFERENCE_CURRENT_LANGUAGES_KEY, locale)

    }

    /**
     * The configured layout for each language is tracked for convenience. In the case that the
     * Keyboard's configuration is reloaded, the app may provide the configured layouts for each
     * language (if any). If no layout is provided for a specific language, the default layout for
     * that language will be used.
     */
    private fun setSelectedLanguageLayout(context: Context, locale: String, layout: String) {
        SettingsStore.putString(context, locale, layout)
    }

    private fun deleteLayoutForLanguage(context: Context, locale: String) {
        SettingsStore.clearSetting(context, locale)
    }

    fun getLayoutForLanguage(context: Context, locale: String): String? {
        return SettingsStore.getString(context, locale)
    }

    /**
     * Checks all available languages in the repository. If the requested language is available
     * the download request is started.
     * The result is returned via the callback.
     */
    fun downloadLanguage(context: Context, locale: String, callback: (String) -> Unit) {
        LanguagesHelper.availableLanguages { languages ->
            languages?.let {
                if (it.containsKey(locale)) {
                    LanguagesHelper.downloadLanguage(locale, object : DownloadListener() {
                        override fun onComplete() {
                            callback.invoke(locale)
                            Log.i(
                                "LanguagesManager",
                                "$locale downloaded successfully"
                            )
                        }

                        override fun onError(error: Throwable) {
                            Toast.makeText(
                                context,
                                "Error downloading language: $locale",
                                Toast.LENGTH_LONG
                            ).show()
                            Log.e(
                                "LanguagesManager",
                                "Error downloading language: $locale. Error: ${error.localizedMessage}"
                            )
                        }
                    })
                }
            }
        }
    }

    /**
     * Whenever a language is downloaded it must be added to the keyboard. Here the language is
     * added using the method LanguagesHelper.addLanguage(keyboardLanguage: KeyboardLanguage). This
     * will internally update the LanguagesConfiguration.userLanguages parameter and set the
     * keyboardLanguage as the currentLanguage.
     *
     * Alternatively KeyboardHelper.reloadConfiguration() can be used alongside an updated
     * KeyboardConfiguration.LanguagesConfiguration.userLanguages parameter in the
     * SdkKeyboardService. This can be helpful when adding multiple languages. This method will
     * not change the keyboard's currentLanguage.
     *
     * @param locale The locale for the language to be added to the Keyboard
     * @param layout The layout for the language to be added to the keyboard. In this sample the
     * configured layout for each language is saved for convenience. This allows the app to reload
     * the Keyboard's configuration correctly if needed. A null layout will make the SDK use the
     * default layout for the specific language.
     */
    fun addLanguageToKeyboard(locale: String, layout: String? = null) {
        LanguagesHelper.addLanguage(KeyboardLanguage(locale, layout))
    }

    /**
     * Removes the downloaded language from the LanguagesConfiguration.userLanguages and deletes
     * the local files.
     *
     * Note: After downloading a language, if the SDK's configuration has not been updated to
     * include said language in the userLanguages, this method will be unable to delete it.
     */
    fun deleteLanguage(context: Context, locale: String) {
        LanguagesHelper.deleteLanguage(locale)
        deleteLayoutForLanguage(context, locale)
    }

    /**
     * Returns a list of all available layouts for a locally available language.
     */
    fun getAvailableLayoutsForLanguage(locale: String, callback: (List<String>?) -> Unit) {
        LanguagesHelper.languageResourceDetails(locale) {
            callback.invoke(it?.layouts)
        }
    }

    /**
     * Changes the keyboard's current language and/or it's layout.
     */
    fun changeLanguage(locale: String, layout: String?) {
        LanguagesHelper.changeLanguage(KeyboardLanguage(locale, layout))
    }

    /**
     * Change the layout for any locally available language. When changing the layout for the
     * keyboard's current language, the keyboard's UI will be refreshed.
     *
     * Note: After downloading a language, if the SDK's configuration has not been updated to
     * include said language, this method will be unable to change the layout for it.
     */
    fun onUpdateLanguageLayout(context: Context, locale: String, layout: String) {
        LanguagesHelper.updateLanguageLayout(KeyboardLanguage(locale, layout))
        setSelectedLanguageLayout(context, locale, layout)
    }
}