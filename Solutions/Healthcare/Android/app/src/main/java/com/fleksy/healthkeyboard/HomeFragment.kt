package com.fleksy.healthkeyboard

import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.os.Bundle
import android.provider.Settings
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.ViewTreeObserver
import android.view.inputmethod.InputMethodManager
import androidx.fragment.app.Fragment
import com.fleksy.healthkeyboard.databinding.FragmentHomeBinding

class HomeFragment : Fragment() {

    private lateinit var binding: FragmentHomeBinding

    private val inputMethodManager
        get() = activity?.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager?
    private val enabledInputMethods
        get() = inputMethodManager?.enabledInputMethodList ?: emptyList()

    private val defaultInputMethod
        get() = Settings.Secure.getString(
            context?.contentResolver,
            Settings.Secure.DEFAULT_INPUT_METHOD
        )
    private val isImeEnabled
        get() = enabledInputMethods.any { it.packageName == context?.packageName }

    private val isImeCurrent
        get() = defaultInputMethod.startsWith("${context?.packageName}/")

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        binding = FragmentHomeBinding.inflate(inflater)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        val isDebuggable = 0 != (context?.applicationInfo?.flags?:0) and ApplicationInfo.FLAG_DEBUGGABLE

        binding.debugContainer.visibility = if(!isDebuggable)
            View.GONE
        else
            View.VISIBLE

        binding.imeEnabled.setOnClickListener { showInputMethodSettings() }
        binding.imeSelected.setOnClickListener { showInputMethodPicker() }

        binding.version.text = BuildConfig.VERSION_NAME

        updateStatus()
    }

    private fun showInputMethodSettings() {
        startActivity(Intent(Settings.ACTION_INPUT_METHOD_SETTINGS))
    }

    private fun showInputMethodPicker() {
        inputMethodManager?.showInputMethodPicker()
    }

    override fun onPause() {
        super.onPause()
        view?.viewTreeObserver?.removeOnWindowFocusChangeListener(onFocusChanged)
    }

    override fun onResume() {
        super.onResume()

        addOnWindowFocusChangeListener(onFocusChanged)

    }

    private val onFocusChanged = ViewTreeObserver.OnWindowFocusChangeListener { hasFocus ->
        if (hasFocus) updateStatus()
    }

    private fun updateStatus() {
        binding.imeEnabled.text =
            getText(if (isImeEnabled) R.string.fleksy_sdk_enabled else R.string.enable_fleksy_sdk)
        binding.imeSelected.text =
            getText(if (isImeCurrent) R.string.fleksy_sdk_selected else R.string.select_fleksy_sdk)
    }

    private fun Fragment.addOnWindowFocusChangeListener(callback: ViewTreeObserver.OnWindowFocusChangeListener) =
        view?.viewTreeObserver?.addOnWindowFocusChangeListener(callback)
}