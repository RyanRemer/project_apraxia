package com.byu.project_apraxia.project_apraxia;

import android.os.Bundle;

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "wsdCalculator";
    private WavFile speechFile = null;
    private List<Long> speechAmplitudeList = new ArrayList<>();
    private Long threshold = 100L;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                new MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, Result result) {
                        // Note: this method is invoked on the main thread.
                        switch (call.method) {
                            case "calculateThreshold":
                                String ambianceFileName = (String) ((ArrayList) call.arguments()).get(0);

                                try {
                                    WavFile ambianceFile = WavFile.openWavFile(new File(ambianceFileName));
                                    List<Long> ambianceAmplitudeList = getAmplitudeList(ambianceFile);
                                    long threshold = getAmbianceThreshold(ambianceAmplitudeList);
                                    result.success(threshold);
                                } catch (Exception e) {
                                    result.error("418", e.getMessage(), null);
                                }
                                break;
                            case "calculateWSD":
                                String speechFileName = (String) ((ArrayList) call.arguments()).get(0);

                                try {
                                    speechFile = WavFile.openWavFile(new File(speechFileName));
                                    speechAmplitudeList = getAmplitudeList(speechFile);
                                    float WSD = getWSD(speechAmplitudeList, 3, threshold, speechFile.getSampleRate());
                                    result.success(WSD);
                                } catch (Exception e) {
                                    System.err.println(e.getMessage());
                                    result.error("418", e.getMessage(), null);
                                }
                                break;
                            case "getAmplitude":
                                result.success(speechAmplitudeList);
                                break;
                            default:
                                result.notImplemented();
                        }
                    }
                });
    }

    private static List<Long> getAmplitudeList(WavFile file) {
        List<Long> amplitudeList = new ArrayList<>();

        final int BUF_SIZE = 100;
        long[][] buffer = new long[file.getNumChannels()][BUF_SIZE];
        try {
            int framesRead = 0;
            do {
                framesRead = file.readFrames(buffer, BUF_SIZE);
                for (long d : buffer[0]) amplitudeList.add(d);
            } while (framesRead != 0);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return amplitudeList;
    }

    private static Long getAmbianceThreshold(List<Long> amplitudeList) {
        List<Long> list = getAbsoluteValueList(amplitudeList);
        Collections.sort(list);

        return list.get((int) (0.999 * list.size()));
    }

    public static float getWSD(List<Long> amplitudeList, int syllables, long threshold, long sampleRate) {
        List<Long> list = getSmoothedList(getAbsoluteValueList(amplitudeList));
        list.removeIf(s -> s < threshold);

        float word_duration = ((float) list.size() / (float) sampleRate) * 1000;
        return word_duration / syllables;
    }

    private static List<Long> getAbsoluteValueList(List<Long> amplitudeList) {
        List<Long> absoluteList = new ArrayList<>();
        absoluteList.addAll(amplitudeList);

        for (int i = 0; i < amplitudeList.size(); i++) {
            absoluteList.set(i, Math.abs(amplitudeList.get(i)));
        }

        return absoluteList;
    }

    private static List<Long> getSmoothedList(List<Long> amplitudeList) {
        List<Long> smoothedList = new ArrayList<>();
        smoothedList.addAll(amplitudeList);

        for (int i = 20; i < smoothedList.size() - 20; i++) {
            List<Long> subList = new ArrayList<>();
            subList.addAll(amplitudeList.subList(i - 20, i + 20));
            smoothedList.set(i, Collections.max(subList));
        }

        return smoothedList;
    }
}
