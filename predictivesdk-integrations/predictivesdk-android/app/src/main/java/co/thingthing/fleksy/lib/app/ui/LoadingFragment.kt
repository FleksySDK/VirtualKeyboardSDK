package co.thingthing.fleksy.lib.app.ui

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import co.thingthing.fleksy.lib.app.R
import co.thingthing.fleksy.lib.languages.LanguagesHelper
import co.thingthing.fleksy.lib.languages.LocalLanguage
import co.thingthing.fleksy.lib.languages.RemoteLanguage
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import kotlin.coroutines.CoroutineContext

/**
 * Copyright © 2022 Thingthing,Ltd. All rights reserved.
 */

class LoadingFragment : CoroutineScope, Fragment() {

    private lateinit var coroutineJob: Job

    override val coroutineContext: CoroutineContext
        get() = Dispatchers.Main + coroutineJob

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        coroutineJob = Job()
    }

    private lateinit var localFileProvider: LocalFileProvider

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_loading, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        localFileProvider = LocalFileProvider(requireContext())

        getLanguageFile()
    }

    private fun getLanguageFile() {
        launch {
            updateLocalLanguageIfNeeded()
            onLoadingFinished()
        }
    }

    /**
     * Request and receive the currently available languages.
     */
    private suspend fun availableLanguages(): List<RemoteLanguage?>? =
        context?.let {
            val result = LanguagesHelper.availableLanguages(it.applicationContext)
            if (result.isSuccess)
                result.getOrNull()
            else null
        }

    private suspend fun checkNewestAvailableVersion() =
        availableLanguages()?.firstOrNull { it?.locale == DEFAULT_LOCALE }?.version


    /**
     * Check version
     */
    private suspend fun updateLocalLanguageIfNeeded(): Boolean {
        val localLanguage = getLocalLanguage()
        val newestVersion = checkNewestAvailableVersion()

        return if (localLanguage == null || (newestVersion != null && localLanguage.version < newestVersion)) {

            if (localFileProvider.localDirectory.exists().not()) {
                localFileProvider.localDirectory.mkdirs()
            }

            requestlanguageDownload()

        } else false
    }

    /**
     * Request language download
     */
    private suspend fun requestlanguageDownload(): Boolean {
        val result = context?.let {
            LanguagesHelper.downloadLanguageFile(
                it, DEFAULT_LOCALE, localFileProvider.localLanguageFile
            )
        }
        return result?.isSuccess ?: false
    }

    private fun getLocalLanguage(): LocalLanguage? =
        LanguagesHelper.getMetadataFromLanguage(localFileProvider.localLanguageFile.path)

    private fun onLoadingFinished() {
        findNavController().navigate(
            R.id.action_loading_to_main
        )
    }

    override fun onDestroy() {
        coroutineJob.cancel()
        super.onDestroy()
    }

    companion object {
        private const val DEFAULT_LOCALE = "en-US"
    }
}