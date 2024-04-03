package com.fleksy.samples.keyboardcustomaction

import android.content.Context
import android.content.Intent
import android.graphics.Color
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.provider.Settings
import android.view.inputmethod.InputMethodManager
import android.widget.TextView
import com.fleksy.samples.keyboardcustomaction.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        binding.apply {
            imeEnabled.setOnClickListener { showInputMethodSettings() }
            imeCurrent.setOnClickListener { showInputMethodPicker() }
            tryEditText.setOnEditorActionListener { v, _, _ -> v.text = ""; true }
        }
    }

    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)
        updateStatus()
    }

    private fun showInputMethodSettings() {
        startActivity(Intent(Settings.ACTION_INPUT_METHOD_SETTINGS))
    }

    private fun showInputMethodPicker() {
        inputMethodManager?.showInputMethodPicker()
    }

    private fun updateStatus() {
        setStatus(binding.imeEnabled, isImeEnabled)
        setStatus(binding.imeCurrent, isImeCurrent)
    }

    private fun setStatus(view: TextView, status: Boolean) {
        view.text = status.toString()
        view.setTextColor(if (status) Color.GREEN else Color.RED)
    }

    private val isImeEnabled
        get() = enabledInputMethods.any { it.packageName == packageName }

    private val isImeCurrent
        get() = defaultInputMethod.startsWith("$packageName/")

    private val inputMethodManager
        get() = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager?

    private val enabledInputMethods
        get() = inputMethodManager?.enabledInputMethodList ?: emptyList()

    private val defaultInputMethod
        get() = Settings.Secure.getString(contentResolver, Settings.Secure.DEFAULT_INPUT_METHOD)
}