package com.fleksy.inappkeyboardadvanced.views

import android.os.Bundle
import android.widget.EditText
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.Fragment
import co.thingthing.fleksy.core.keyboard.KeyboardConfiguration
import co.thingthing.fleksy.core.keyboard.inapp.FleksyKeyboardProvider
import co.thingthing.fleksy.core.keyboard.inapp.InAppDialogListener
import co.thingthing.fleksy.core.keyboard.inapp.InAppFragmentListener
import com.fleksy.inappkeyboardadvanced.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity(), InAppFragmentListener,
    InAppDialogListener {

    private lateinit var binding: ActivityMainBinding
    private var kProvider: FleksyKeyboardProvider? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)
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

    override fun registerEditText(
        editText: EditText,
        keyboardConfiguration: KeyboardConfiguration?
    ) {
        getSafeKeyboardProvider().registerEditText(this, editText, keyboardConfiguration)
    }

    override fun registerEditText(
        dialog: DialogFragment,
        editText: EditText,
        keyboardConfiguration: KeyboardConfiguration?
    ) {
        getSafeKeyboardProvider().registerEditText(dialog, editText, keyboardConfiguration)
    }

    override fun onCreate(dialog: DialogFragment) {
        getSafeKeyboardProvider().onCreate(dialog)
    }

    override fun onBackPressed(dialog: DialogFragment): Boolean {
        return getSafeKeyboardProvider().onBackPressed(dialog)
    }

    override fun dismiss() {
        getSafeKeyboardProvider().dismiss()
    }

    override fun hideKeyboard(dialog: DialogFragment) {
        getSafeKeyboardProvider().hideKeyboard(dialog)
    }

    override fun onBackPressed(fragment: Fragment): Boolean {
        return getSafeKeyboardProvider().onBackPressed(fragment)
    }

    override fun onCreate() {
        getSafeKeyboardProvider().onCreate(this)
    }

    override fun hideKeyboard() {
        getSafeKeyboardProvider().hideKeyboard(this)
    }

    override fun onResume(fragment: Fragment) {
        getSafeKeyboardProvider().onResume(fragment)
    }
}