package com.fleksy.inappkeyboardadvanced.views

import android.app.Dialog
import android.content.DialogInterface
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import co.thingthing.fleksy.core.keyboard.inapp.InAppDialogListener
import com.fleksy.inappkeyboardadvanced.databinding.FragmentBottomSheetBinding
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.google.android.material.bottomsheet.BottomSheetDialogFragment

class BottomSheetFragment :
    BottomSheetDialogFragment() {

    private lateinit var binding: FragmentBottomSheetBinding

    private lateinit var inAppDialogFragmentListener: InAppDialogListener

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        inAppDialogFragmentListener = requireActivity() as InAppDialogListener
        inAppDialogFragmentListener.onCreate(this)
    }

    override fun onStart() {
        super.onStart()

        val behavior = BottomSheetBehavior.from(requireView().parent as View)
        behavior.state = BottomSheetBehavior.STATE_EXPANDED
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        binding = FragmentBottomSheetBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
        return object : BottomSheetDialog(requireActivity(), theme) {
            override fun onBackPressed() {
                val handled = inAppDialogFragmentListener.onBackPressed(this@BottomSheetFragment)
                if (!handled) super.onBackPressed()
            }
        }
    }

    override fun onResume() {
        super.onResume()
        inAppDialogFragmentListener.registerEditText(this, binding.etTest1, null)
        inAppDialogFragmentListener.registerEditText(this, binding.etTest2, null)
    }

    override fun onDismiss(dialog: DialogInterface) {
        inAppDialogFragmentListener.dismiss()
        super.onDismiss(dialog)
    }
}