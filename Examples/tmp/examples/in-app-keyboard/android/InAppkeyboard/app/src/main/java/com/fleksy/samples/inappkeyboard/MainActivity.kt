package com.fleksy.samples.inappkeyboard

import android.os.Bundle
import androidx.activity.OnBackPressedCallback
import androidx.appcompat.app.AppCompatActivity
import co.thingthing.fleksy.core.keyboard.inapp.FleksyKeyboardProvider
import com.fleksy.samples.inappkeyboard.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {

    private val keyboardProvider = FleksyKeyboardProvider()

    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        keyboardProvider.onCreate(this)

        onBackPressedDispatcher.addCallback(this, object : OnBackPressedCallback(true) {
            override fun handleOnBackPressed() {
                val handled = keyboardProvider.onBackPressed(this@MainActivity)
                if (!handled) finish()
            }
        })
    }

    override fun onResume() {
        super.onResume()

        keyboardProvider.onResume(this)
    }
}