package co.thingthing.sample.sdksample

import co.thingthing.fleksy.core.common.extensions.context.dp2px
import co.thingthing.fleksy.core.keyboard.HoverStyle
import co.thingthing.fleksy.core.keyboard.Icon
import co.thingthing.fleksy.core.keyboard.KeyboardConfiguration
import co.thingthing.fleksy.core.keyboard.KeyboardConfiguration.EmojiConfiguration
import co.thingthing.fleksy.core.keyboard.KeyboardConfiguration.EmojiGender
import co.thingthing.fleksy.core.keyboard.KeyboardConfiguration.EmojiSkinTone
import co.thingthing.fleksy.core.keyboard.KeyboardConfiguration.FeaturesConfiguration
import co.thingthing.fleksy.core.keyboard.KeyboardConfiguration.HoldMode
import co.thingthing.fleksy.core.keyboard.KeyboardConfiguration.LanguageConfiguration
import co.thingthing.fleksy.core.keyboard.KeyboardConfiguration.LicenseConfiguration
import co.thingthing.fleksy.core.keyboard.KeyboardConfiguration.PredictionsConfiguration
import co.thingthing.fleksy.core.keyboard.KeyboardConfiguration.PrivacyConfiguration
import co.thingthing.fleksy.core.keyboard.KeyboardConfiguration.StyleConfiguration
import co.thingthing.fleksy.core.keyboard.KeyboardConfiguration.TypingConfiguration
import co.thingthing.fleksy.core.keyboard.KeyboardService
import co.thingthing.fleksy.core.keyboard.SpacebarStyle
import co.thingthing.fleksy.core.languages.KeyboardLanguage
import co.thingthing.fleksy.core.languages.LanguageRepository
import co.thingthing.fleksy.core.prediction.model.PredictionModelType
import co.thingthing.fleksy.core.speech.SpeechMode
import co.thingthing.fleksy.core.themes.SystemThemes
import co.thingthing.fleksy.core.ui.KeyboardFont
import co.thingthing.fleksyapps.giphy.GiphyApp
import java.util.concurrent.TimeUnit

class SampleKeyboardService : KeyboardService() {

	private val apps by lazy {
		listOf(
			GiphyApp(GIPHY_API_KEY)
		)
	}

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
		licenseKey = BuildConfig.FLEKSY_LICENSE_KEY,
                licenseSecret = BuildConfig.FLEKSY_SECRET_KEY
            ),
			apps = KeyboardConfiguration.AppsConfiguration(
                keyboardApps = apps,
                shareAuthority = "$packageName.fileprovider",
                shareDirectory = "SharedContent",
                shareContentExpiration = TimeUnit.HOURS.toMillis(1),
                showAppsInCarousel = true,
                showAppsOnStart = true
            )
		)

	override val appIcon get() = R.drawable.fleksy_logo

    companion object {

		const val GIPHY_API_KEY = "ADD_YOUR_GIPHY_KEY_HERE"

        private val DEFAULT_RECENT_EMOJI = setOf(
            "😂", "😍", "😭", "☺️", "😘", "👏", "🙏", "👌", "👍",
            "🙌", "❤️", "💕", "💓", "💙", "💗", "✨", "🔥", "🎉",
            "💯", "🙈", "🎂", "🍕", "🍓", "🍻", "☕"
        )
    }
}