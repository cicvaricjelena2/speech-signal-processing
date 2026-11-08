# Speech Signal Processing

A MATLAB-based project covering fundamental digital signal processing techniques applied to speech signals, including speech analysis, synthesis, segmentation, pitch estimation, and signal quantization.

Project Overview

The project is organized into two groups of tasks.

Part 1 — Speech Analysis and Synthesis

1. Speech Signal Analysis

* Speech signal loading and visualization.
* DC component removal and signal normalization.
* Time-domain and frequency-domain analysis using FFT.
* Spectral comparison of different speech sounds.

2. Speech Synthesis

* Excitation pulse generation.
* Glottal airflow modeling using the Rosenberg model.
* Source-filter model of speech production.
* Synthesis of vowels (A, E, O).
* Analysis of fundamental frequency and filter parameters.

3. Speech Segmentation

* Speech signal preprocessing.
* Short-Time Energy (STE) calculation.
* Zero-Crossing Rate (ZCR) calculation.
* Adaptive thresholding for speech segment detection.
* Segment boundary refinement.

Part 2 — Pitch Estimation and Quantization

4. Pitch Estimation

* Pitch estimation using the parallel processing method.
* Autocorrelation with center clipping.
* Comparison of the estimated fundamental frequencies.

5. Speech Signal Quantization

* Uniform Mid-Tread quantization.
* Uniform Mid-Rise quantization.
* μ-law companding.
* Signal reconstruction and SNR evaluation.
* Analysis of quantization performance for different bit depths and compression parameters.

6. Delta Quantization

* Delta modulation and signal reconstruction.
* Reconstruction error analysis.
* Investigation of slope overload distortion and granular noise.
* Step-size selection using the histogram of consecutive sample differences.

7. Speech Digit Recognition

A speech recognition system for classifying spoken digits (one, two, and three) using acoustic feature extraction and machine learning.

Signal Processing and Feature Extraction

* Audio preprocessing and amplitude normalization.
* Silence detection and removal.
* Mel-Frequency Cepstral Coefficients (MFCC).
* Linear Predictive Coding (LPC) analysis.
* Real cepstrum analysis and pitch estimation.

Classification

* K-Nearest Neighbors (KNN) classifier.
* Classification using 13-dimensional MFCC feature vectors.
* Training and testing on separately recorded speech samples.

Evaluation

* Training and test confusion matrices.
* Classification accuracy.
* Comparison of predicted and actual digit labels.

Reported Results

* Training accuracy: 96.7%
* Test accuracy: 100%

The dataset consists of recordings of three spoken digits by a single speaker. It contains 30 training samples and 15 test samples. These results should therefore be interpreted within the scope of this small, speaker-dependent dataset.

Technologies and Methods

* MATLAB
* Digital Signal Processing (DSP)
* Fast Fourier Transform (FFT)
* Source-Filter Speech Production Model
* Rosenberg Glottal Model
* Pitch Estimation
* Autocorrelation
* Uniform Quantization
* μ-law Companding
* Delta Modulation
* Short-Time Energy (STE)
* Zero-Crossing Rate (ZCR)
* Signal-to-Noise Ratio (SNR)

Repository Structure

speech-signal-processing/
│
├── audio/
│   ├── a.wav
│   ├── s.wav
│   ├── c.wav
│   └── recenica.wav
│
├── additional_tasks/
│   ├── pitch_estimation.m
│   ├── speech_quantization.m
│   ├── speech_delta_quantization.m
│   └── z1.wav
│
├── speech_signal_analysis.m
├── speech_synthesis.m
├── speech_segmentation.m
│
├── genpulse.m
├── rosenmodel.m
├── makevowel.m
│
├── README.md
└── .gitignore

Requirements

* MATLAB
* Signal Processing Toolbox may be required for certain functions.
* Required audio input files must be available in the appropriate working directories.

How to Run

1. Clone or download the repository.
2. Open MATLAB.
3. Set the repository directory as the current working directory.
4. Make sure the required audio files are available.
5. Run the desired MATLAB script.

For speech synthesis, ensure that the helper functions are available in the MATLAB path.

Purpose

The project demonstrates the application of digital signal processing methods to speech signals, combining theoretical concepts with MATLAB implementations, signal visualization, and quantitative performance evaluation.
