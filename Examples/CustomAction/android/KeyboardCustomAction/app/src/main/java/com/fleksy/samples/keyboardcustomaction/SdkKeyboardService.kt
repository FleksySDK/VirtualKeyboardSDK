package com.fleksy.samples.keyboardcustomaction

import android.util.Log
import co.thingthing.fleksy.core.bus.events.EventBasedDataCaptureEvent
import co.thingthing.fleksy.core.keyboard.KeyboardConfiguration
import co.thingthing.fleksy.core.keyboard.KeyboardService
import co.thingthing.fleksy.core.keyboard.models.EventDataConfiguration
import co.thingthing.fleksy.core.languages.KeyboardLanguage
import co.thingthing.fleksy.core.personalisation.Button

class SdkKeyboardService : KeyboardService() {

    private val currentLanguage
        get() = KeyboardLanguage("en-US")

    override fun onCreate() {
        super.onCreate()

        eventBus.eventBasedDataCapture.subscribe {
            /**
             * Data Capture will be received here.
             */
            when (it) {
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
            license = KeyboardConfiguration.LicenseConfiguration(
                licenseKey = "INSERT_LICENSE_KEY",
                licenseSecret = "INSERT_LICENSE_SECRET"
            ),
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
            ),
            customizationBundle = KeyboardConfiguration.CustomizationBundleConfiguration(
                /**
                 * The name of the customization bundle without the extension.
                 * In this case the bundle is called "custom-action.bundle"
                 * A sample bundle is included in the assets folder.
                 */
                bundleFileName = "custom-action",

                /**
                 * List of custom buttons. These must be previously defined in the customization
                 * bundle's layout json file: keyboard-global.json
                 */
                buttons = listOf(Button(
                    /**
                     * Label by which to match with the defined button in the custom layout file.
                     */
                    label = "custom-action",

                    /**
                     * Image which will be shown in the custom button's keycap.
                     */
                    image = R.drawable.fleksy_logo,

                    /**
                     * The scale mode for the image inside the custom button's keycap. In this
                     * case it will center the button inside the keycap and its dimensions will be
                     * equal to or less than the dimensions of the keycap.
                     */
                    scaleMode = Button.ScaleMode.CENTER_INSIDE,
                ) {
                    /**
                     * On click action for the custom button.
                     */
                    Log.e("ActionButton", "Action button clicked!")
                })
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