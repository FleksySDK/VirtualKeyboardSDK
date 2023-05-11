package com.fleksy.samples.sessionbaseddatacapture

import co.thingthing.fleksy.core.bus.events.GenericDataEvent
import co.thingthing.fleksy.core.keyboard.KeyboardConfiguration
import co.thingthing.fleksy.core.keyboard.KeyboardService
import co.thingthing.fleksy.core.keyboard.models.FLDataConfiguration
import co.thingthing.fleksy.core.languages.KeyboardLanguage
import co.thingthing.fleksy.core.languages.LanguageRepository

class SdkKeyboardService : KeyboardService() {

    private val currentLanguage
        get() = KeyboardLanguage("en-US")

    override fun onCreate() {
        super.onCreate()

        eventBus.genericData.subscribe {
            /**
             * Data Capture events will be received here.
             */
            when (it) {
                is GenericDataEvent.SessionStarted -> {}
                is GenericDataEvent.SessionEnded -> {}
                is GenericDataEvent.Session -> {}
                is GenericDataEvent.SessionStored -> {}
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
            ),
            dataCapture = KeyboardConfiguration.DataCaptureMode.SessionBased(
                location = "resources", //Location where the session data should be stored.
                logEvents = false, //Enable events in logcat for debugging purposes
                sendDataEvents = true, //Receive data capture events via EventBus
                storeData = true, //Store session data in a file in the specified 'location'
                configuration = DATA_CONFIG_FULL //Which data should be captured.
            )
        )


    companion object {
        val DEFAULT_RECENT_EMOJI = setOf(
            "😂", "😍", "😭", "☺️", "😘", "👏", "🙏", "👌", "👍",
            "🙌", "❤️", "💕", "💓", "💙", "💗", "✨", "🔥", "🎉",
            "💯", "🙈", "🎂", "🍕", "🍓", "🍻", "☕"
        )

        val DATA_CONFIG_FULL = FLDataConfiguration(
            dataArea = true,
            dataAutocorrection = true,
            dataCode = true,
            dataDelete = true,
            dataEmoji = true,
            dataKeyPress = true,
            dataKeyPressEnd = true,
            dataKeyCenter = true,
            dataKeyBounds = true,
            dataKeyPlane = true,
            dataKeyText = true,
            dataLayout = true,
            dataLanguage = true,
            dataPosition = true,
            dataPositionEnd = true,
            dataPrediction = true,
            dataPredictionsTouch = true,
            dataPress = true,
            dataSwipe = true,
            dataText = true,
            dataTextField = true,
            dataType = true,
            dataWord = true,
            dataDistanceFromLastTouch = true,

            interKeyTimeHistogram = true,
            interKeyTimeHistogramInterval = 50,
            interKeyTimeHistogramCount = 21,

            dataConfigCoordinate = FLDataConfiguration.DataConfigCoordinate.SCREEN_PIXEL,
            dataConfigFormat = FLDataConfiguration.DataConfigFormat.STANDARD,
            dataAccelerometer = true
        )
    }
}