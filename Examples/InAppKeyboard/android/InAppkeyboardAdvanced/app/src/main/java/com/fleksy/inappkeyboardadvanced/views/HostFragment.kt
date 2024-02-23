package com.fleksy.inappkeyboardadvanced.views

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.Fragment
import co.thingthing.fleksy.core.keyboard.inapp.InAppFragmentListener
import com.fleksy.inappkeyboardadvanced.databinding.FragmentHostBinding

class HostFragment : Fragment() {

    private lateinit var binding: FragmentHostBinding

    private lateinit var inAppFragmentListener: InAppFragmentListener

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        binding = FragmentHostBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        inAppFragmentListener = requireActivity() as InAppFragmentListener
        inAppFragmentListener.onCreate()

        setupButtons()
    }

    private fun setupButtons() {
        binding.btBottomSheet.setOnClickListener {
            val bottomSheetDialog = BottomSheetFragment()
            bottomSheetDialog.show(childFragmentManager, "BottomSheetDialogFragment")
        }

        binding.btDialogFragment.setOnClickListener {
            val dialogFragment: DialogFragment = SimpleDialogFragment()
            dialogFragment.show(childFragmentManager, "DialogFragment")
        }
    }

    override fun onResume() {
        super.onResume()

        inAppFragmentListener.onResume(this)
    }

}