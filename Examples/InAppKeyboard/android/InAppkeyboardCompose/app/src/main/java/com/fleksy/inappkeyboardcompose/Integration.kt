package com.fleksy.inappkeyboardcompose

import android.content.Context
import co.thingthing.fleksy.core.keyboard.KeyboardConfiguration
import co.thingthing.fleksy.core.keyboard.inapp.InAppKeyboardIntegration
import co.thingthing.fleksy.core.languages.KeyboardLanguage
import co.thingthing.fleksy.core.themes.SystemThemes

class Integration(context: Context) : InAppKeyboardIntegration(context) {

    private val currentLanguage
        get() = KeyboardLanguage("en-US")

    override fun createConfiguration() = KeyboardConfiguration(
        style = KeyboardConfiguration.StyleConfiguration(
            swipeDuration = 300,
            forceTheme = SystemThemes.lightTheme,
            forceDarkTheme = SystemThemes.darkTheme
        ),
        language = KeyboardConfiguration.LanguageConfiguration(
            current = currentLanguage,
            automaticDownload = true,
            orderMode = KeyboardConfiguration.LanguageOrderMode.STATIC

        ),
        emoji = KeyboardConfiguration.EmojiConfiguration(
            recent = DEFAULT_RECENT_EMOJI,
            defaultSkinTone = KeyboardConfiguration.EmojiSkinTone.NEUTRAL,
            defaultGender = KeyboardConfiguration.EmojiGender.NEUTRAL
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