package com.fleksy.samples.inappkeyboard

import android.content.Context
import co.thingthing.fleksy.core.keyboard.*
import co.thingthing.fleksy.core.keyboard.inapp.InAppKeyboardIntegration
import co.thingthing.fleksy.core.languages.KeyboardLanguage
import co.thingthing.fleksy.core.languages.LanguageRepository

class Integration(context: Context) : InAppKeyboardIntegration(context) {

    private val currentLanguage
        get() = KeyboardLanguage("en-US")

    override fun createConfiguration() = KeyboardConfiguration(
        style = KeyboardConfiguration.StyleConfiguration(
            swipeDuration = 300
        ),
        language = KeyboardConfiguration.LanguageConfiguration(
            current = currentLanguage,
            automaticDownload = true,
            repository = LanguageRepository.PREVIEW,
            orderMode = KeyboardConfiguration.LanguageOrderMode.STATIC

        ),
        emoji = KeyboardConfiguration.EmojiConfiguration(
            recent = DEFAULT_RECENT_EMOJI,
            defaultSkinTone = KeyboardConfiguration.EmojiSkinTone.NEUTRAL,
            defaultGender = KeyboardConfiguration.EmojiGender.NEUTRAL
        ),
        monitor = KeyboardConfiguration.MonitorConfiguration(
            extractionMode = KeyboardConfiguration.ExtractionMode.EXTRACTED
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