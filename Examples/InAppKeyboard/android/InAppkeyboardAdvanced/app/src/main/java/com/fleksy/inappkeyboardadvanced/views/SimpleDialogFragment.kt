package com.fleksy.inappkeyboardadvanced.views

import android.app.Dialog
import android.content.DialogInterface
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import co.thingthing.fleksy.core.keyboard.inapp.FleksyDialogFragment
import co.thingthing.fleksy.core.keyboard.inapp.InAppDialogListener
import com.fleksy.inappkeyboardadvanced.databinding.FragmentSimpleDialogBinding

class SimpleDialogFragment : FleksyDialogFragment() {

    private lateinit var binding: FragmentSimpleDialogBinding

    private lateinit var inAppDialogListener: InAppDialogListener

    override fun getContentView(inflater: LayoutInflater, container: ViewGroup?): View {
        binding = FragmentSimpleDialogBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        inAppDialogListener = requireActivity() as InAppDialogListener
        inAppDialogListener.onCreate(this)
    }

    override fun onResume() {
        super.onResume()

        inAppDialogListener.registerEditText(this, binding.etTest1, null)
        inAppDialogListener.registerEditText(this, binding.etTest2, null)
        inAppDialogListener.registerEditText(this, binding.etTest3, null)
        inAppDialogListener.registerEditText(this, binding.etTest4, null)
        inAppDialogListener.registerEditText(this, binding.etTest5, null)
    }

    override fun onDismiss(dialog: DialogInterface) {
        super.onDismiss(dialog)

        inAppDialogListener.dismiss()
    }

    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
        return object : Dialog(requireActivity(), theme) {
            override fun onBackPressed() {
                val handled = inAppDialogListener.onBackPressed(this@SimpleDialogFragment)
                if (!handled) super.onBackPressed()
            }
        }
    }
}