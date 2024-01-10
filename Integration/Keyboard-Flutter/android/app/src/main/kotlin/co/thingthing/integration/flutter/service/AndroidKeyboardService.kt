package co.thingthing.integration.flutter.service

import android.content.Intent
import android.content.res.Configuration
import android.util.Log
import android.view.View
import android.view.Window
import android.view.inputmethod.EditorInfo
import co.thingthing.fleksy.core.keyboard.*
import co.thingthing.fleksy.core.keyboard.KeyboardConfiguration.*
import co.thingthing.fleksy.core.languages.KeyboardLanguage
import co.thingthing.fleksy.core.languages.LanguageRepository
import co.thingthing.fleksy.core.prediction.model.PredictionModelType
import co.thingthing.fleksy.core.speech.SpeechMode
import co.thingthing.fleksy.core.themes.SystemThemes
import co.thingthing.fleksy.core.ui.KeyboardFont

class AndroidKeyboardService : KeyboardService() {



	private val currentLanguage
		get() = KeyboardLanguage(currentLocale, currentLayout)

	private val currentLocale
		get() = "en-US"

	private val currentLayout
		get() = "QWERTY"

	override fun createConfiguration() =
		KeyboardConfiguration(
			language = LanguageConfiguration(
				current = currentLanguage,
				userLanguages = listOf(currentLanguage),
				repository = LanguageRepository.PRODUCTION,
				automaticDownload = true
			),
			features = FeaturesConfiguration(
				suggestions = false,
				nsp = true,
				emojiPrediction = true,
				textToSpeech = false,
                speechMode = SpeechMode.Recognizer
			),
			typing = TypingConfiguration(
				autoCorrect = true,
				allowBackspaceToUndoAC = true,
				caseSensitive = true,
				smartPunctuation = true,
				tripleSpaceAddsSpaceKey = true,
				magicButtonIcon = Icon.COMMA,
				holdMode = HoldMode.POP,
				swipeTyping = true
			),
			privacy = PrivacyConfiguration(
				trackingEnabled = false,
				updateNoiseEstimation = false
			),
			style = StyleConfiguration(
				userFont = KeyboardFont.ROBOTO_REGULAR,
				forceTheme = SystemThemes.lightTheme,
				forceDarkTheme = SystemThemes.darkTheme,
				useStandardLayoutSystem = true,
				spacebarStyle = SpacebarStyle.Automatic,
			),
			emoji = EmojiConfiguration(
				keepVariations = true,
				recent = DEFAULT_RECENT_EMOJI,
				variations = emptyMap(),
				defaultSkinTone = EmojiSkinTone.NEUTRAL,
				defaultGender = EmojiGender.NEUTRAL,
				androidOnly = true
			),
			predictions = PredictionsConfiguration(
				predictionTypes = listOf(PredictionModelType.WORD, PredictionModelType.EMOJI),
                showEmojiSuggestions = true
			),
			license = LicenseConfiguration(
				licenseKey = "your-license-key",
				licenseSecret = "your-secret-key"
			)
		)

	companion object {
		private val DEFAULT_RECENT_EMOJI = setOf(
			"😂", "😍", "😭", "☺️", "😘", "👏", "🙏", "👌", "👍",
			"🙌", "❤️", "💕", "💓", "💙", "💗", "✨", "🔥", "🎉",
			"💯", "🙈", "🎂", "🍕", "🍓", "🍻", "☕"
		)
	}
}
