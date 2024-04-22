package com.fleksy.inappkeyboardadvanced.views

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.compose.ui.viewinterop.AndroidView
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.Fragment
import co.thingthing.fleksy.core.keyboard.inapp.FleksyEditText
import co.thingthing.fleksy.core.keyboard.inapp.InAppFragmentListener
import com.fleksy.inappkeyboardadvanced.R
import com.fleksy.inappkeyboardadvanced.databinding.FragmentHostBinding

@Composable
fun ComposeFleksyTextField(inAppFragmentListener: InAppFragmentListener) {
    val editHint = stringResource(id = R.string.try_this_edittext)
    AndroidView(
        factory = { context ->
            val edit = FleksyEditText(context)
            edit.hint = editHint
            edit
        },
        update = {
            inAppFragmentListener.registerEditText(it, null)
        }
    )
}

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

        binding.composeView.setContent {
            ComposeFleksyTextField(inAppFragmentListener)
        }

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