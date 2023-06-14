package co.thingthing.fleksy.lib.app.ui

import android.content.Context
import co.thingthing.fleksy.lib.model.LanguageFile
import java.io.File

/**
 * Copyright © 2022 Thingthing,Ltd. All rights reserved.
 */

class LocalFileProvider(val context: Context) {

    companion object {
        private const val LANGUAGES_FOLDER = "languages"
        private const val LANGUAGE_FILE_NAME = "resourceArchive-en-US.jet"
        private const val ASSETS_PATH = "encrypted"

    }

    val languageFile: LanguageFile
        get() = if (localLanguageFile.exists())
            LanguageFile.File(localLanguageFile.path)
        else LanguageFile.Asset(localAssetFile.path)


    private val localStorageDirectory = context.filesDir.absolutePath

    val localDirectory: File
        get() = File(localStorageDirectory, LANGUAGES_FOLDER)

    val localLanguageFile: File
        get() = File(localDirectory.absolutePath, LANGUAGE_FILE_NAME)

    private val localAssetFile
        get() = File(ASSETS_PATH, LANGUAGE_FILE_NAME)
}
