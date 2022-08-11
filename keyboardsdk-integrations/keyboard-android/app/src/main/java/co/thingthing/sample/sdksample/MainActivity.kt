package co.thingthing.sample.sdksample

import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.os.Bundle
import android.provider.Settings
import android.view.inputmethod.InputMethodManager
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {

	override fun onCreate(savedInstanceState: Bundle?) {
		super.onCreate(savedInstanceState)
		setContentView(R.layout.activity_main)

		imeEnabled.setOnClickListener { showInputMethodSettings() }
		imeCurrent.setOnClickListener { showInputMethodPicker() }
		tryEditText.setOnEditorActionListener { v, _, _ -> v.text = ""; true }
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
		setStatus(imeEnabled, isImeEnabled)
		setStatus(imeCurrent, isImeCurrent)
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
