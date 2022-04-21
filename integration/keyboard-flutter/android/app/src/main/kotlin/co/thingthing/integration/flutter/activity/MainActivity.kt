package co.thingthing.integration.flutter.activity

import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.provider.Settings
import android.view.inputmethod.InputMethodManager
import android.widget.TextView
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                ENABLE_IME -> enableIme(result)
                SELECT_IME -> selectIme(result)
                IS_IME_ENABLED -> result.success(isImeEnabled)
                IS_IME_SELECTED -> result.success(isImeSelected)
                else -> result.error("404", "method not found", null)
            }
        }
    }

    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)
        onResume()
    }

    private fun enableIme(result: MethodChannel.Result) {
        startActivity(Intent(Settings.ACTION_INPUT_METHOD_SETTINGS))
        result.success(null)
    }

    private fun selectIme(result: MethodChannel.Result) {
        inputMethodManager?.showInputMethodPicker()
        result.success(null)
    }

    private val isImeEnabled
        get() = enabledInputMethods.any { it.packageName == packageName }

    private val isImeSelected
        get() = defaultInputMethod.startsWith("$packageName/")

    private val inputMethodManager
        get() = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager?

    private val enabledInputMethods
        get() = inputMethodManager?.enabledInputMethodList ?: emptyList()

    private val defaultInputMethod
        get() = Settings.Secure.getString(contentResolver, Settings.Secure.DEFAULT_INPUT_METHOD)

    companion object {
        private const val CHANNEL = "flutter.native/helper"
        private const val ENABLE_IME = "enableIme"
        private const val SELECT_IME = "selectIme"
        private const val IS_IME_ENABLED = "isImeEnabled"
        private const val IS_IME_SELECTED = "isImeSelected"
    }

}
