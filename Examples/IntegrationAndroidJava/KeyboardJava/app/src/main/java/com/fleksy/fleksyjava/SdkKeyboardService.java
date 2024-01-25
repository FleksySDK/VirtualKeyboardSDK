package com.fleksy.fleksyjava;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import co.thingthing.fleksy.core.keyboard.KeyboardConfiguration;
import co.thingthing.fleksy.core.keyboard.KeyboardService;
import co.thingthing.fleksy.core.languages.KeyboardLanguage;

public class SdkKeyboardService extends KeyboardService {

    @Nullable
    @Override
    public Integer getAppIcon() {
        return null;
    }

    @NonNull
    @Override
    public KeyboardConfiguration createConfiguration() {
        KeyboardConfiguration config = new KeyboardConfiguration(
                new KeyboardConfiguration.LanguageConfiguration(),
                new KeyboardConfiguration.TypingConfiguration(),
                new KeyboardConfiguration.PrivacyConfiguration(),
                new KeyboardConfiguration.StyleConfiguration(),
                new KeyboardConfiguration.FeaturesConfiguration(),
                new KeyboardConfiguration.PredictionsConfiguration(),
                new KeyboardConfiguration.LegacyConfiguration(),
                new KeyboardConfiguration.DataCaptureMode.EventBased(),
                new KeyboardConfiguration.MonitorConfiguration(),
                new KeyboardConfiguration.EmojiConfiguration(),
                new KeyboardConfiguration.ExtensionsConfiguration(),
                new KeyboardConfiguration.FeedbackConfiguration(),
                new KeyboardConfiguration.AppsConfiguration(),
                new KeyboardConfiguration.ShortcutsConfiguration(),
                new KeyboardConfiguration.WatermarkConfiguration(),
                new KeyboardConfiguration.LicenseConfiguration(
                        "license_key",
                        "license_secret"
                )
        );

        return config;
    }
}
