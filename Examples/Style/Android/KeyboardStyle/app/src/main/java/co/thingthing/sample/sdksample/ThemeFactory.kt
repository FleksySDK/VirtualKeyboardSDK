package co.thingthing.sample.sdksample

import android.graphics.Color
import co.thingthing.fleksy.core.themes.KeyboardTheme

class ThemeFactory {

    fun getBlueTheme(): KeyboardTheme{
        return KeyboardTheme(
            key = "system-blue",
            name = "Blue theme",
            background = Color.rgb(218, 240, 255),
            keyLetters = Color.rgb(70, 182, 254),
            keyBackground = Color.rgb(255, 255, 255),
            keyBackgroundPressed = Color.rgb(255, 255, 255),
            keyShadow = Color.rgb(70, 182, 254),
            buttonLetters = Color.rgb(70, 182, 254),
            buttonBackground = Color.rgb(181, 226, 255),
            buttonBackgroundPressed = Color.rgb(248, 248, 248),
            hoverLetters = Color.rgb(70, 182, 254),
            hoverBackground = Color.rgb(255, 255, 255),
            hoverSelectedLetters = Color.rgb(255, 255, 255),
            hoverSelectedBackground = Color.rgb(0, 255, 255),
            buttonActionLetters = Color.rgb(70, 182, 254),
            buttonActionBackground = Color.rgb(181, 226, 255),
            buttonActionBackgroundPressed = Color.rgb(248, 248, 248),
            spacebarLetters = Color.rgb(0, 0, 0),
            spacebarBackground = Color.rgb(255, 255, 255),
            trackPadCursor = Color.rgb(26, 115, 232),
            swipeLine = Color.rgb(106,197,254),
            suggestionLetters = Color.rgb(70,182,254),
            suggestionSelectedLetters = Color.rgb(70,182,254)
        )
    }
}