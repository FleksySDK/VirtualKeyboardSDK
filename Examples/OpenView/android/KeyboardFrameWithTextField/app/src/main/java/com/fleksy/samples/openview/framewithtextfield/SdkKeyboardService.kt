package com.fleksy.samples.openview.framewithtextfield

import android.view.View
import android.view.accessibility.AccessibilityEvent
import co.thingthing.fleksy.core.keyboard.KeyboardConfiguration
import co.thingthing.fleksy.core.keyboard.KeyboardService
import co.thingthing.fleksy.core.keyboard.PanelHelper
import co.thingthing.fleksy.core.languages.KeyboardLanguage
import co.thingthing.fleksy.core.themes.SystemThemes
import com.fleksy.samples.openview.framewithtextfield.databinding.ViewCustomFrameBinding
import com.fleksy.samples.openview.framewithtextfield.databinding.ViewCustomFullBinding

class SdkKeyboardService : KeyboardService() {

    private lateinit var customViewFrame: ViewCustomFrameBinding
    private lateinit var customViewFull: ViewCustomFullBinding

    private val currentLanguage
        get() = KeyboardLanguage("en-US")

    override val appIcon: Int
        get() = R.drawable.baseline_search_24

    override fun onAppsButtonClicked() {
        customViewFrame = ViewCustomFrameBinding.inflate(this.layoutInflater)
        with(customViewFrame) {
            btClose.setOnClickListener {
                PanelHelper.hideFullView()
                clearTemporaryInputConnection()
            }
            btFullCover.setOnClickListener { openFullView() }
            btClose.setOnClickListener { PanelHelper.hideFrameView() }

            etSearch.apply {

                setOnClickListener {
                    requestFocus()
                }

                setOnFocusChangeListener { _, hasFocus ->
                    if (hasFocus) {

                        val editorInfo = createEditorInfo(this)

                        val inputConnection =
                            onCreateInputConnection(editorInfo)

                        attachTemporaryInputConnection(
                            inputConnection,
                            editorInfo
                        )
                    } else {
                        clearTemporaryInputConnection()
                    }
                }

                setOnEditorActionListener { textView, i, keyEvent ->
                    customViewFrame.textView.text = textView.text
                    clearTemporaryInputConnection()
                    false
                }

                accessibilityDelegate = object : View.AccessibilityDelegate() {
                    override fun sendAccessibilityEvent(host: View, eventType: Int) {
                        when (eventType) {
                            AccessibilityEvent.TYPE_VIEW_TEXT_SELECTION_CHANGED -> {
                                forceCursorSelectionChange(
                                    selectionStart,
                                    selectionEnd
                                )
                            }
                        }
                    }
                }
            }

            root.setOnClickListener { etSearch.requestFocus() }
            PanelHelper.showFrameView(root, topBarVisible = true)
        }
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