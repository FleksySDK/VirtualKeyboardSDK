package com.fleksy.samples.eventbaseddatacapture

import co.thingthing.fleksy.core.bus.events.EventBasedDataCaptureEvent
import co.thingthing.fleksy.core.keyboard.KeyboardConfiguration
import co.thingthing.fleksy.core.keyboard.KeyboardService
import co.thingthing.fleksy.core.keyboard.models.EventDataConfiguration
import co.thingthing.fleksy.core.languages.KeyboardLanguage
import co.thingthing.fleksy.core.languages.LanguageRepository

class SdkKeyboardService : KeyboardService() {

    private val currentLanguage
        get() = KeyboardLanguage("en-US")

    override fun onCreate() {
        super.onCreate()

        eventBus.eventBasedDataCapture.subscribe {
            /**
             * Data Capture will be received here.
             */
            when(it){
                is EventBasedDataCaptureEvent.KeyStrokeCaptureEvent -> {}
                is EventBasedDataCaptureEvent.DeleteCaptureEvent -> {}
                is EventBasedDataCaptureEvent.KeyPlaneCaptureEvent -> {}
                is EventBasedDataCaptureEvent.WordCaptureEvent -> {}
                is EventBasedDataCaptureEvent.SwipeCaptureEvent -> {}
                is EventBasedDataCaptureEvent.SessionUpdateCaptureEvent -> {}
                is EventBasedDataCaptureEvent.StressUpdateCaptureEvent -> {}
            }
        }
    }

    override fun createConfiguration() =
        KeyboardConfiguration(
            style = KeyboardConfiguration.StyleConfiguration(
                swipeDuration = 300
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