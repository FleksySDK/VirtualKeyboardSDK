package com.fleksy.samples.openview.keyboardopenview

import co.thingthing.fleksy.core.keyboard.KeyboardConfiguration
import co.thingthing.fleksy.core.keyboard.KeyboardService
import co.thingthing.fleksy.core.keyboard.PanelHelper
import co.thingthing.fleksy.core.languages.KeyboardLanguage
import co.thingthing.fleksy.core.languages.LanguageRepository
import co.thingthing.fleksy.core.themes.SystemThemes
import com.fleksy.samples.openview.keyboardopenview.databinding.ViewCustomBinding

class SdkKeyboardService: KeyboardService() {

    private lateinit var customView: ViewCustomBinding

    private val currentLanguage
        get() = KeyboardLanguage("en-US")

    override val appIcon: Int
        get() = R.drawable.baseline_search_24

    override fun createConfiguration() =
        KeyboardConfiguration(
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

    override fun onAppsButtonClicked() {
        customView = ViewCustomBinding.inflate(this.layoutInflater)
        customView.btClose.setOnClickListener{
            PanelHelper.hideFullView()
        }

        PanelHelper.showFullView(customView.root)
    }

    companion object {
        val DEFAULT_RECENT_EMOJI = setOf(
            "😂", "😍", "😭", "☺️", "😘", "👏", "🙏", "👌", "👍",
            "🙌", "❤️", "💕", "💓", "💙", "💗", "✨", "🔥", "🎉",
            "💯", "🙈", "🎂", "🍕", "🍓", "🍻", "☕"
        )
    }
}