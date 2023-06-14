package co.thingthing.fleksy.lib.app.di

import android.content.Context
import co.thingthing.fleksy.lib.api.FleksyLib
import co.thingthing.fleksy.lib.api.LibraryConfiguration
import co.thingthing.fleksy.lib.app.BuildConfig
import co.thingthing.fleksy.lib.app.ui.LocalFileProvider
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

/**
 * Copyright © 2022 Thingthing,Ltd. All rights reserved.
 */

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Provides
    @Singleton
    fun provideFleksyLib(@ApplicationContext appContext: Context): FleksyLib {

        return FleksyLib(
            appContext,
            LocalFileProvider(appContext).languageFile,
            LibraryConfiguration(
                LibraryConfiguration.LicenseConfiguration(
                    licenseKey = BuildConfig.SDK_LICENSE_KEY,
                    licenseSecret = BuildConfig.SDK_LICENSE_SECRET
                )
            )
        )
    }
}