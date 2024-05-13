package com.inappkeyboardreact

import co.thingthing.fleksy.core.keyboard.inapp.FleksyKeyboardProvider
import com.facebook.react.ReactActivity
import com.facebook.react.ReactActivityDelegate
import com.facebook.react.defaults.DefaultNewArchitectureEntryPoint.fabricEnabled
import com.facebook.react.defaults.DefaultReactActivityDelegate

class MainActivity : ReactActivity() {

  /**
   * Returns the name of the main component registered from JavaScript. This is used to schedule
   * rendering of the component.
   */
  override fun getMainComponentName(): String = "InAppKeyboardReact"

  private var kProvider: FleksyKeyboardProvider? = null

  /**
   * Returns the instance of the [ReactActivityDelegate]. We use [DefaultReactActivityDelegate]
   * which allows you to enable New Architecture with a single boolean flags [fabricEnabled]
   */
  override fun createReactActivityDelegate(): ReactActivityDelegate =
      DefaultReactActivityDelegate(this, mainComponentName, fabricEnabled)

    override fun onResume() {
        super.onResume()

        getSafeKeyboardProvider().onResume(this)
    }

    private fun getSafeKeyboardProvider(): FleksyKeyboardProvider {
        if (kProvider == null) {
            kProvider = FleksyKeyboardProvider()
            kProvider!!.onCreate(this)
        }

        return kProvider!!
    }
}
