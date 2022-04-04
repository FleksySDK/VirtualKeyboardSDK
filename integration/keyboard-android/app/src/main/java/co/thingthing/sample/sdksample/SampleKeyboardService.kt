package co.thingthing.sample.sdksample

import android.content.Intent
import android.content.SharedPreferences
import androidx.core.content.ContextCompat
import co.thingthing.fleksy.core.bus.events.ConfigurationEvent.AutoCorrectionChanged
import co.thingthing.fleksy.core.bus.events.ConfigurationEvent.CurrentLanguageChanged
import co.thingthing.fleksy.core.bus.events.DictionaryEvent.*
import co.thingthing.fleksy.core.common.extensions.context.dp2px
import co.thingthing.fleksy.core.keyboard.*
import co.thingthing.fleksy.core.keyboard.KeyboardConfiguration.*
import co.thingthing.fleksy.core.keyboard.models.FLDataConfiguration
import co.thingthing.fleksy.core.languages.KeyboardLanguage
import co.thingthing.fleksy.core.languages.LanguageRepository
import co.thingthing.fleksy.core.prediction.model.PredictionModelType
import co.thingthing.fleksy.core.speech.SpeechMode
import co.thingthing.fleksy.core.themes.SystemThemes
import co.thingthing.fleksy.core.ui.KeyboardFont
import java.util.concurrent.TimeUnit

class SampleKeyboardService : KeyboardService() {

	lateinit var sharedPreferences: SharedPreferences

	private val spaceBarLogo by lazy {
		ContextCompat.getDrawable(this, R.drawable.ic_fleksy_watermark)
	}

	override fun onCreate() {
		sharedPreferences = getSharedPreferences("default", MODE_PRIVATE)

		// Prepare any dependencies needed in `createConfiguration`
		// before calling `super.onCreate()`

		super.onCreate()

		// Set user dictionary
		setUserDictionary()

		// Configuration changes inside keyboard
		eventBus.configuration.subscribe {
			when (it) {
				is AutoCorrectionChanged -> updateAutoCorrect(it.enabled)
				is CurrentLanguageChanged -> {
					setCurrentLocale(it.locale)
					setUserDictionary()
				}
			}
		}

		// Dictionary changes inside keyboard
		eventBus.dictionary.subscribe {
			when (it) {
				is AddUserWord -> updateUserDictionary(userDictionary.apply { add(it.word) })
				is RemoveUserWord -> updateUserDictionary(userDictionary.apply { remove(it.word) })
				is AutoLearnedWord -> updateUserDictionary(userDictionary.apply { add(it.word) })
			}
		}
	}

	private fun setUserDictionary() {
		setUserWords(userDictionary.toList())
	}

	private val userDictionary: MutableSet<String>
		get() = sharedPreferences.getStringSet(userDictionaryKey, null)?.toMutableSet()
			?: mutableSetOf()

	private fun updateUserDictionary(words: Set<String>) {
		sharedPreferences.edit().putStringSet(userDictionaryKey, words).apply()
	}

	private fun updateAutoCorrect(enabled: Boolean) {
		sharedPreferences.edit().putBoolean("autoCorrect", enabled).apply()
	}

	private fun setCurrentLocale(locale: String) {
		sharedPreferences.edit().putString("currentLocale", locale).apply()
	}

	private val userDictionaryKey get() = "userDictionary_$currentLocale"

	private val currentLanguage
		get() = KeyboardLanguage(currentLocale, currentLayout)

	private val currentLocale
		get() = sharedPreferences.getString("currentLocale", null) ?: "en-US"

	private val currentLayout
		get() = sharedPreferences.getString("layout_$currentLocale", null)

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
				spacebarLogo = spaceBarLogo,
				spacebarStyle = SpacebarStyle.Automatic,
				hoverStyle = HoverStyle.FactorSizeBar(
					widthFactor = .9f,
					heightFactor = 1.25f,
					maxHeight = dp2px(150f),
					maxWidth = dp2px(50f)
				)
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

	override val appIcon get() = R.drawable.fleksy_logo

	// Note: Will only be called when no apps registered on AppConfiguration
	override fun onAppsButtonClicked() {
		startActivity(
			Intent(this, MainActivity::class.java).apply {
				flags = Intent.FLAG_ACTIVITY_NEW_TASK
			}
		)
	}

	companion object {

		private val DEFAULT_RECENT_EMOJI = setOf(
			"😂", "😍", "😭", "☺️", "😘", "👏", "🙏", "👌", "👍",
			"🙌", "❤️", "💕", "💓", "💙", "💗", "✨", "🔥", "🎉",
			"💯", "🙈", "🎂", "🍕", "🍓", "🍻", "☕"
		)
	}
}
