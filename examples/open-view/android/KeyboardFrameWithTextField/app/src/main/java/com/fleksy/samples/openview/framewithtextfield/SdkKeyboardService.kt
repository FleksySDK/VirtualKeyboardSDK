package com.fleksy.samples.openview.framewithtextfield

import android.view.inputmethod.EditorInfo
import co.thingthing.fleksy.core.keyboard.KeyboardConfiguration
import co.thingthing.fleksy.core.keyboard.KeyboardService
import co.thingthing.fleksy.core.keyboard.PanelHelper
import co.thingthing.fleksy.core.languages.KeyboardLanguage
import co.thingthing.fleksy.core.languages.LanguageRepository
import co.thingthing.fleksy.core.themes.SystemThemes
import com.fleksy.samples.openview.framewithtextfield.databinding.ViewCustomFrameBinding
import com.fleksy.samples.openview.framewithtextfield.databinding.ViewCustomFullBinding

class SdkKeyboardService : KeyboardService() {

    lateinit var customViewFrame: ViewCustomFrameBinding
    lateinit var customViewFull: ViewCustomFullBinding

    private val currentLanguage
        get() = KeyboardLanguage("en-US")

    override val appIcon: Int
        get() = R.drawable.baseline_search_24

    override fun onAppsButtonClicked() {
        customViewFrame = ViewCustomFrameBinding.inflate(this.layoutInflater)
        customViewFrame.btClose.setOnClickListener {
            PanelHelper.hideFullView()
            clearTemporaryInputConnection()
        }
        customViewFrame.btFullCover.setOnClickListener { openFullView() }
        customViewFrame.btClose.setOnClickListener { PanelHelper.hideFrameView() }

        customViewFrame.etSearch.setOnFocusChangeListener { _, hasFocus ->
            temporaryInputConnection = if (hasFocus) {
                val inputConnection = customViewFrame.etSearch.onCreateInputConnection(EditorInfo())
                inputConnection
            } else {
                clearTemporaryInputConnection()
                null
            }
        }
        customViewFrame.etSearch.setOnEditorActionListener { textView, i, keyEvent ->
            customViewFrame.textView.text = textView.text
            clearTemporaryInputConnection()
            false
        }

        PanelHelper.showFrameView(customViewFrame.root)
    }

    private fun openFullView() {
        clearTemporaryInputConnection()
        customViewFull = ViewCustomFullBinding.inflate(this.layoutInflater)

        customViewFull.btFullCover.setOnClickListener {
            PanelHelper.hideFullView()
        }
        customViewFull.btClose.setOnClickListener {
            PanelHelper.hideFullView()
            PanelHelper.hideFrameView()
        }

        PanelHelper.showFullView(customViewFull.root)
    }

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