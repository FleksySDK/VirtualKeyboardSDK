package com.fleksy.inappkeyboardcompose

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.OnBackPressedCallback
import androidx.activity.compose.setContent
import androidx.appcompat.app.AppCompatActivity
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalTextInputService
import androidx.compose.ui.viewinterop.AndroidViewBinding
import co.thingthing.fleksy.core.keyboard.inapp.FleksyKeyboardProvider
import com.fleksy.inappkeyboardcompose.databinding.FleksyEdittextLayoutBinding
import com.fleksy.inappkeyboardcompose.ui.theme.InAppkeyboardComposeTheme

@Composable
fun ComposeFleksyTextField(activity: ComponentActivity, kProvider: FleksyKeyboardProvider) {
    CompositionLocalProvider(
        LocalTextInputService provides null) {
        AndroidViewBinding(FleksyEdittextLayoutBinding::inflate) {
            kProvider.registerEditText(activity, tryEditText)
        }
    }
}

class MainActivity : AppCompatActivity() {
    private var kProvider: FleksyKeyboardProvider? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        getSafeKeyboardProvider().onCreate(this)

        onBackPressedDispatcher.addCallback(this, object : OnBackPressedCallback(true) {
            override fun handleOnBackPressed() {
                val handled = getSafeKeyboardProvider().onBackPressed(this@MainActivity)
                if (!handled) finish()
            }
        })

        setContent {
            InAppkeyboardComposeTheme {
                // A surface container using the 'background' color from the theme
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    Column(modifier = Modifier.fillMaxSize(),
                        verticalArrangement = Arrangement.Center) {
                        ComposeFleksyTextField(this@MainActivity, getSafeKeyboardProvider())
                    }
                }
            }
        }
    }

    /**
     * Safe method to make sure the KeyboardProvider is always started before use regardless of the
     * view's lifecycle.
     */
    private fun getSafeKeyboardProvider(): FleksyKeyboardProvider {
        if (kProvider == null) {
            kProvider = FleksyKeyboardProvider()
            kProvider!!.onCreate(this)
        }

        return kProvider!!
    }

    override fun onResume() {
        super.onResume()

        getSafeKeyboardProvider().onResume(this)
    }
}
