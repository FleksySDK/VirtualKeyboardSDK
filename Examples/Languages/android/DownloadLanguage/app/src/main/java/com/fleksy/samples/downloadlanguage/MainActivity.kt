package com.fleksy.samples.downloadlanguage

import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.os.Bundle
import android.provider.Settings
import android.view.View
import android.view.inputmethod.InputMethodManager
import android.widget.ArrayAdapter
import android.widget.TextView
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import com.fleksy.samples.downloadlanguage.databinding.ActivityMainBinding
import com.fleksy.samples.downloadlanguage.languages.LanguagesManager


class MainActivity : AppCompatActivity() {

    companion object {
        private const val SAMPLE_LANGUAGE = "es-ES"
    }

    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        setupView()
    }

    private fun setupView() {
        binding.apply {
            imeEnabled.setOnClickListener { showInputMethodSettings() }
            imeCurrent.setOnClickListener { showInputMethodPicker() }
            tryEditText.setOnEditorActionListener { v, _, _ -> v.text = ""; true }
            btnDownloadLanguage.setOnClickListener {
                LanguagesManager.downloadLanguage(this@MainActivity, SAMPLE_LANGUAGE) {
                    updateControls()
                }
            }

            btnAddLanguage.setOnClickListener {
                LanguagesManager.addLanguageToKeyboard(SAMPLE_LANGUAGE)
                updateControls()
            }

            btnRemoveLanguage.setOnClickListener {
                LanguagesManager.deleteLanguage(this@MainActivity, SAMPLE_LANGUAGE)
                updateControls()
            }

            btnChooseLanguageLayout.setOnClickListener {
                LanguagesManager.getAvailableLayoutsForLanguage(
                    LanguagesManager.getCurrentLanguage(
                        this@MainActivity
                    )
                ) {
                    it?.toMutableList()?.let { layouts ->
                        val builderSingle: AlertDialog.Builder =
                            AlertDialog.Builder(this@MainActivity)
                        builderSingle.setTitle("Select a layout")
                        val arrayAdapter = ArrayAdapter<String>(
                            this@MainActivity,
                            android.R.layout.select_dialog_singlechoice
                        )
                        arrayAdapter.addAll(layouts)
                        builderSingle.setNegativeButton(
                            "Cancel"
                        ) { dialog, _ -> dialog.dismiss() }
                        builderSingle.setAdapter(
                            arrayAdapter
                        ) { _, which ->
                            LanguagesManager.changeLanguage(
                                LanguagesManager.getCurrentLanguage(this@MainActivity),
                                layouts[which]
                            )
                        }
                        builderSingle.show()
                    }
                }
            }
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
        updateControls()
    }

    private fun updateControls() {
        with(binding) {
            txtRequirement.visibility = if (isImeCurrent) View.GONE else View.VISIBLE

            btnChooseLanguageLayout.visibility = if (isImeCurrent) View.VISIBLE else View.GONE

            btnDownloadLanguage.visibility = if (isImeCurrent) View.VISIBLE else View.GONE

            btnAddLanguage.visibility =
                if (isImeCurrent && LanguagesManager.getUserLanguages(this@MainActivity).contains(
                        SAMPLE_LANGUAGE
                    )
                ) View.VISIBLE else View.GONE

            btnRemoveLanguage.visibility =
                if (isImeCurrent && LanguagesManager.getUserLanguages(this@MainActivity).contains(
                        SAMPLE_LANGUAGE
                    )
                ) View.VISIBLE else View.GONE
        }
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