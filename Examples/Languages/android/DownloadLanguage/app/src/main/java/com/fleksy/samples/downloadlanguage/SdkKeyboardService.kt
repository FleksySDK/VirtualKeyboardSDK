package com.fleksy.samples.downloadlanguage

import co.thingthing.fleksy.core.bus.events.ActivityEvent
import co.thingthing.fleksy.core.bus.events.EventBasedDataCaptureEvent
import co.thingthing.fleksy.core.keyboard.KeyboardConfiguration
import co.thingthing.fleksy.core.keyboard.KeyboardService
import co.thingthing.fleksy.core.keyboard.models.EventDataConfiguration
import co.thingthing.fleksy.core.languages.KeyboardLanguage
import com.fleksy.samples.downloadlanguage.languages.LanguagesManager

class SdkKeyboardService : KeyboardService() {


    /**
     * It is recommended that the app keep track of configuration changes regarding the
     * currentLanguage as the keyboard's configuration may need to be reloaded at any time.
     * This sample provides a simple strategy to achieve this.
     */
    private val currentLanguage
        get() = keyboardLanguageWithLayout(LanguagesManager.getCurrentLanguage(this))

    private val userLanguages
        get() = LanguagesManager.getUserLanguages(this).map { keyboardLanguageWithLayout(it) }

    private fun keyboardLanguageWithLayout(locale: String) =
        KeyboardLanguage(locale, LanguagesManager.getLayoutForLanguage(this, locale))

    override fun onCreate() {
        super.onCreate()

        /**
         * This event provides information when the currentLanguage is changed. In this case it is
         * used to track the currentLanguage so the app may provide it whenever the keyboard needs
         * to reload it's configuration.
         */
        eventBus.activity.subscribe {
            when (it) {
                is ActivityEvent.LanguageChanged -> {
                    LanguagesManager.setCurrentLanguage(this, it.locale)
                }

                else -> {}
            }
        }
    }


    override fun createConfiguration() =
        KeyboardConfiguration(
            license = KeyboardConfiguration.LicenseConfiguration(
                licenseKey = "INSERT_LICENSE_KEY",
                licenseSecret = "INSERT_LICENSE_SECRET"
            ),
            style = KeyboardConfiguration.StyleConfiguration(
                swipeDuration = 300
            ),
            language = KeyboardConfiguration.LanguageConfiguration(
                current = currentLanguage,
                userLanguages = userLanguages,
                automaticDownload = false,
                orderMode = KeyboardConfiguration.LanguageOrderMode.STATIC
            ),
            emoji = KeyboardConfiguration.EmojiConfiguration(
                recent = DEFAULT_RECENT_EMOJI,
                defaultSkinTone = KeyboardConfiguration.EmojiSkinTone.NEUTRAL,
                defaultGender = KeyboardConfiguration.EmojiGender.NEUTRAL
            ),
            dataCapture = KeyboardConfiguration.DataCaptureMode.EventBased(
                EventDataConfiguration(
                    keyStroke = true,
                    delete = true,
                    keyPlane = true,
                    word = true,
                    swipe = true,
                    sessionUpdate = true,
                    stressUpdate = true
                )
            )
        )

    companion object {
        val DEFAULT_RECENT_EMOJI = setOf(
            "😂", "😍", "😭", "☺️", "😘", "👏", "🙏", "👌", "👍",
            "🙌", "❤️", "💕", "💓", "💙", "💗", "✨", "🔥", "🎉",
            "💯", "🙈", "🎂", "🍕", "🍓", "🍻", "☕"
        )
    }
}