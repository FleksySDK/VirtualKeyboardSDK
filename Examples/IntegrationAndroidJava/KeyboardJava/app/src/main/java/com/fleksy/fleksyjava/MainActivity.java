package com.fleksy.fleksyjava;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.provider.Settings;
import android.view.inputmethod.InputMethodInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import com.fleksy.fleksyjava.databinding.ActivityMainBinding;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity {


    private ActivityMainBinding binding;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        binding.imeEnabled.setOnClickListener(v -> showInputMethodSettings());
        binding.imeCurrent.setOnClickListener(v -> showInputMethodPicker());
        binding.tryEditText.setOnEditorActionListener((v, actionId, event) -> {
            v.setText("");
            return true;
        });
    }

    @Override
    public void onWindowFocusChanged(boolean hasFocus) {
        super.onWindowFocusChanged(hasFocus);
        updateStatus();
    }

    private void showInputMethodSettings() {
        startActivity(new Intent(Settings.ACTION_INPUT_METHOD_SETTINGS));
    }

    private void showInputMethodPicker() {
        InputMethodManager imm = getInputMethodManager();
        if (imm != null) {
            imm.showInputMethodPicker();
        }
    }

    private void updateStatus() {
        setStatus(binding.imeEnabled, isImeEnabled());
        setStatus(binding.imeCurrent, isImeCurrent());
    }

    private void setStatus(TextView view, Boolean status) {
        view.setText(status.toString());

        if (status) {
            view.setTextColor(Color.GREEN);
        } else {
            view.setTextColor(Color.RED);
        }
    }

    private boolean isImeEnabled() {
        List<InputMethodInfo> inputMethods = getEnabledInputMethods();

        for (InputMethodInfo im : inputMethods) {
            if (im.getPackageName().equals(getPackageName()))
                return true;
        }

        return false;
    }

    private boolean isImeCurrent() {
        return getDefaultInputMethod().startsWith(getPackageName() + "/");
    }

    private InputMethodManager getInputMethodManager() {
        return (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
    }

    private List<InputMethodInfo> getEnabledInputMethods() {

        ArrayList<InputMethodInfo> list = new ArrayList<>();
        InputMethodManager imm = getInputMethodManager();

        if (imm != null) {
            list.addAll(imm.getEnabledInputMethodList());
        }

        return list;
    }

    private String getDefaultInputMethod() {
        return Settings.Secure.getString(getContentResolver(), Settings.Secure.DEFAULT_INPUT_METHOD);
    }
}