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
    private Double threshold = null;

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
                            case "calculateAmbiance":
                                String ambianceFileName = (String) ((ArrayList) call.arguments()).get(0);

                                try {
                                    WavFile ambianceFile = WavFile.openWavFile(new File(ambianceFileName));
                                    List<Double> ambianceAmplitudeList = getAmplitudeList(ambianceFile);
                                    threshold = getAmbianceThreshold(ambianceAmplitudeList);
                                    result.success(threshold);
                                } catch (Exception e) {
                                    result.error("418", e.getMessage(), null);
                                }
                                break;
                            case "calculateWSD":
                                if (threshold == null) {
                                    result.error("418", "Ambiance threshold not set", null);
                                }

                                String speechFileName = (String) ((ArrayList) call.arguments()).get(0);
                                int syllableCount = (int) ((ArrayList) call.arguments()).get(1);

                                try {
                                    WavFile speechFile = WavFile.openWavFile(new File(speechFileName));
                                    List<Double> speechAmplitudeList = getAmplitudeList(speechFile);
                                    double WSD = getWSD(speechAmplitudeList, syllableCount, threshold, speechFile.getSampleRate());
                                    result.success(WSD);
                                } catch (Exception e) {
                                    System.err.println(e.getMessage());
                                    result.error("418", e.getMessage(), null);
                                }
                                break;
                            case "getAmplitude":
                                String fileName = (String) ((ArrayList) call.arguments()).get(0);
                                try {
                                    WavFile wavFile = WavFile.openWavFile(new File(fileName));
                                    result.success(getAmplitudeList(wavFile));
                                } catch (Exception e) {
                                    System.err.println(e.getMessage());
                                    result.error("418", e.getMessage(), null);
                                }
                                break;
                            default:
                                result.notImplemented();
                        }
                    }
                });
    }

    private static List<Double> getAmplitudeList(WavFile file) {
        List<Double> amplitudeList = new ArrayList<>();

        final int BUF_SIZE = 100;
        double[][] buffer = new double[file.getNumChannels()][BUF_SIZE];
        try {
            int framesRead = 0;
            do {
                framesRead = file.readFrames(buffer, BUF_SIZE);
                for (double d : buffer[0]) amplitudeList.add(d);
            } while (framesRead != 0);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return amplitudeList;
    }

    private static Double getAmbianceThreshold(List<Double> amplitudeList) {
        List<Double> list = getAbsoluteValueList(amplitudeList);
        Collections.sort(list);

        return list.get((int) (0.999 * list.size()));
    }

    public static double getWSD(List<Double> amplitudeList, int syllables, double threshold, long sampleRate) {
        List<Double> list = getSmoothedList(getAbsoluteValueList(amplitudeList));
        list.removeIf(s -> s < threshold);

        double word_duration = ((double) list.size() / (double) sampleRate) * 1000;
        return word_duration / syllables;
    }

    private static List<Double> getAbsoluteValueList(List<Double> amplitudeList) {
        List<Double> absoluteList = new ArrayList<>();
        absoluteList.addAll(amplitudeList);

        for (int i = 0; i < amplitudeList.size(); i++) {
            absoluteList.set(i, Math.abs(amplitudeList.get(i)));
        }

        return absoluteList;
    }

    private static List<Double> getSmoothedList(List<Double> amplitudeList) {
        List<Double> smoothedList = new ArrayList<>();
        smoothedList.addAll(amplitudeList);

        for (int i = 20; i < smoothedList.size() - 20; i++) {
            List<Double> subList = new ArrayList<>();
            subList.addAll(amplitudeList.subList(i - 20, i + 20));
            smoothedList.set(i, Collections.max(subList));
        }

        return smoothedList;
    }
}
