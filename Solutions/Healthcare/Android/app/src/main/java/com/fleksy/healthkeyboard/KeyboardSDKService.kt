package com.fleksy.healthkeyboard

import android.content.SharedPreferences
import android.util.Log
import androidx.preference.PreferenceManager
import co.thingthing.fleksy.core.keyboard.KeyboardConfiguration
import co.thingthing.fleksy.core.keyboard.KeyboardService
import co.thingthing.fleksy.core.prediction.model.PredictionModelType
import co.thingthing.fleksy.core.themes.SystemThemes
import java.io.File
import java.io.FileOutputStream
import java.io.IOException

class KeyboardSDKService : KeyboardService() {

    //override val appIcon: Int
    //    return null
    //get() = R.mipmap.ic_launcher


    override fun createConfiguration(): KeyboardConfiguration {
        val sharedPreferences = PreferenceManager.getDefaultSharedPreferences(this)

        return KeyboardConfiguration(
            typing = KeyboardConfiguration.TypingConfiguration(

                autoCorrect = sharedPreferences.getBoolean(
                    resources.getString(R.string.pref_key_autocorrection),
                    resources.getBoolean(R.bool.def_value_autocorrection)
                ),
                swipeTyping = sharedPreferences.getBoolean(
                    resources.getString(R.string.pref_key_swipe),
                    resources.getBoolean(R.bool.def_value_swipe)
                ),
                smartPunctuation = false,
                magicButtonActions = listOf()
            ),
            predictions = KeyboardConfiguration.PredictionsConfiguration(
                predictionTypes = getPredictions(sharedPreferences)
            ),
            license = KeyboardConfiguration.LicenseConfiguration(
                licenseKey = resources.getString(R.string.key),
                licenseSecret = resources.getString(R.string.secret)
            ),
            style = KeyboardConfiguration.StyleConfiguration(
                forceTheme = SystemThemes.lightTheme,
                forceDarkTheme = SystemThemes.darkTheme
            ),
            emoji = KeyboardConfiguration.EmojiConfiguration(
                recent = DEFAULT_RECENT_EMOJI,
                defaultSkinTone = KeyboardConfiguration.EmojiSkinTone.NEUTRAL,
                defaultGender = KeyboardConfiguration.EmojiGender.NEUTRAL
            )
        )
    }

    private fun getPredictions(sharedPreferences: SharedPreferences): List<PredictionModelType> {
        val predictionsOn = sharedPreferences.getBoolean(
            resources.getString(R.string.pref_key_predictions),
            resources.getBoolean(R.bool.def_value_predictions)
        )

        val predictionTypes = if (predictionsOn) {
            listOf(
                PredictionModelType.WORD,
                PredictionModelType.EMOJI
            )
        } else {
            listOf()
        }

        return predictionTypes
    }

    companion object {
        val DEFAULT_RECENT_EMOJI = setOf(
            "😂", "😍", "😭", "☺️", "😘", "👏", "🙏", "👌", "👍",
            "🙌", "❤️", "💕", "💓", "💙", "💗", "✨", "🔥", "🎉",
            "💯", "🙈", "🎂", "🍕", "🍓", "🍻", "☕"
        )
    }

    override fun onCreate() {
        super.onCreate()
    }
}