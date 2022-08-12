package co.thingthing.fleksy.lib.app.ui

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import co.thingthing.fleksy.lib.app.R
import dagger.hilt.android.AndroidEntryPoint

/**
 * Copyright © 2022 Thingthing,Ltd. All rights reserved.
 */

@AndroidEntryPoint
class NavHostActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_nav_host)
    }
}