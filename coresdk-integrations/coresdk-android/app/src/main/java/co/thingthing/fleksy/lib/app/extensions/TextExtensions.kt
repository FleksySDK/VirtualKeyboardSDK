package co.thingthing.fleksy.lib.app.extensions

import android.text.Editable
import android.widget.EditText
import co.thingthing.fleksy.lib.extensions.emojiCompatLength

/**
 * Copyright © 2022 Thingthing,Ltd. All rights reserved.
 */

val EditText.cursortStart: Int
    get(): Int {
        val textToCount = this.text.substring(0, this.selectionStart)
        return textToCount.emojiCompatLength
    }

val EditText.cursorEnd: Int
    get(): Int {
        val textToCount = this.text.substring(0, this.selectionEnd)
        return textToCount.emojiCompatLength
    }


fun Editable.emojiCompatReplace(start: Int, end: Int, replacement: String) {
    if (start > this.length || end < 0 || end < start) return
    val realStart = start + (start - this.substring(0, start).emojiCompatLength)
    val realEnd = end + (end - this.substring(0, end).emojiCompatLength)
    this.replace(realStart, realEnd, replacement)
}
