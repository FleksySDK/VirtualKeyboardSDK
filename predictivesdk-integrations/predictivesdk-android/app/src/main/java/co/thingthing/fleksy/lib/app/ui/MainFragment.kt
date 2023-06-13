package co.thingthing.fleksy.lib.app.ui

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import co.thingthing.fleksy.lib.api.FleksyLib
import co.thingthing.fleksy.lib.app.R
import co.thingthing.fleksy.lib.app.databinding.FragmentMainBinding
import co.thingthing.fleksy.lib.app.extensions.cursorEnd
import co.thingthing.fleksy.lib.app.extensions.cursortStart
import co.thingthing.fleksy.lib.app.extensions.emojiCompatReplace
import co.thingthing.fleksy.lib.extensions.emojiCompatLength
import co.thingthing.fleksy.lib.languages.LanguagesHelper
import co.thingthing.fleksy.lib.model.Candidate
import co.thingthing.fleksy.lib.model.LanguageFile
import co.thingthing.fleksy.lib.model.TypingContext
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import javax.inject.Inject
import kotlin.coroutines.CoroutineContext


/**
 * Copyright © 2022 Thingthing,Ltd. All rights reserved.
 */

@AndroidEntryPoint
class MainFragment : Fragment(), CoroutineScope {

    @Inject
    lateinit var fleksyLib: FleksyLib

    private lateinit var coroutineJob: Job

    override val coroutineContext: CoroutineContext
        get() = Dispatchers.Main + coroutineJob

    private val candidateList = mutableListOf<Candidate>()

    private var _binding: FragmentMainBinding? = null
    private val binding get() = _binding!!

    private val adapter = CandidateAdapter(candidateList) { candidateClicked(it) }

    private val userDictionaryWords = listOf(
        // Names
        "Eustaquio",
        "Eustace",
        "Alonso",
        "Umurçan",
        "Hadiya",
        "Iago",
        "Inés",

        // Places
        "Sevilla",
        "Málaga",
        "Andalucía",
        "Compostela",
        "Ourense",
        "Pontevedra",
        "Lugo",
        "Malpica",

        // Food
        "habas",
        "lentejas",
        "sopa"
    )

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        coroutineJob = Job()
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentMainBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        addUserDictionaryWords()
        setupListeners()
        binding.recycler.adapter = adapter

        showLanguageFile()
    }

    private fun showLanguageFile() {
        context?.let {
            val metadata = when (val languageFile = LocalFileProvider(it).languageFile) {
                is LanguageFile.Asset -> {
                    it.assets.openFd(languageFile.path).let { assetFileDescriptor ->
                        LanguagesHelper.getMetadataFromLanguage(
                            assetFileDescriptor.fileDescriptor,
                            assetFileDescriptor.startOffset,
                            assetFileDescriptor.length
                        )
                    }
                }
                is LanguageFile.File -> {
                    LanguagesHelper.getMetadataFromLanguage(languageFile.path)
                }
            }
            metadata?.let {
                binding.tvLanguageVersion.text = "Language ${metadata.locale} v${metadata.version}"
            }
        }
    }

    /**
     * Adds words to user dictionary
     */
    private fun addUserDictionaryWords() {
        fleksyLib.addWordsToDictionary(
            userDictionaryWords
        )
    }

    /**
     * Removes words from user dictionary
     */
    fun removeUserDictionaryWords() {
        fleksyLib.removeWordsFromDictionary(
            userDictionaryWords.subList(15, 17)
        )
    }

    /**
     * Request and receive predictions.
     */
    private fun setupListeners() {
        binding.btAutocorrect.setOnClickListener {
            hideError()
            showLastAction(getString(R.string.autocorrection))
            launch {
                val result =
                    fleksyLib.currentWordPrediction(
                        TypingContext(
                            binding.etInput.text.toString(),
                            binding.etInput.cursortStart,
                            binding.etInput.cursorEnd
                        )
                    )

                if (result.isSuccess) {
                    showCandidateList(result.getOrNull())

                } else {
                    showError(result.exceptionOrNull()?.message)
                }
            }
        }

        binding.btSuggestion.setOnClickListener {
            hideError()
            showLastAction(getString(R.string.suggestion))
            launch {
                val result =
                    fleksyLib.nextWordPrediction(
                        TypingContext(
                            binding.etInput.text.toString(),
                            binding.etInput.cursortStart,
                            binding.etInput.cursorEnd
                        )
                    )

                if (result.isSuccess) {
                    showCandidateList(result.getOrNull())
                } else {
                    showError(result.exceptionOrNull()?.message)
                }
            }
        }
    }

    private fun showError(message: String?) {
        binding.tvError.text = message ?: getString(R.string.default_error)
        binding.tvError.visibility = View.VISIBLE
    }

    private fun hideError() {
        binding.tvError.visibility = View.GONE
    }

    private fun showLastAction(action: String) {
        binding.tvInfo.visibility = View.VISIBLE
        binding.tvInfo.text = action
    }

    /**
     * Show the candidates in a list
     */
    private fun showCandidateList(candidates: List<Candidate>?) {
        candidateList.clear()
        candidates?.let {
            candidateList.addAll(candidates)
            adapter.notifyDataSetChanged()
        }
    }

    /**
     * Apply the Candidate predictions to the text.
     */
    private fun candidateClicked(candidate: Candidate) {
        val text = binding.etInput.text
        candidate.replacements.forEach { replacement ->
            text?.let {
                while (it.toString().emojiCompatLength < replacement.start) {
                    text.append(" ")
                }
                it.emojiCompatReplace(replacement.start, replacement.end, replacement.replacement)
            }
        }

        binding.etInput.text = text
        text?.let { binding.etInput.setSelection(it.toString().length) }
        binding.tvInfo.text = ""
        candidateList.clear()
        adapter.notifyDataSetChanged()
    }

    override fun onDestroy() {
        coroutineJob.cancel()
        super.onDestroy()
    }
}
