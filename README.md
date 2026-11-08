# Speech Signal Processing

A MATLAB-based project focused on speech signal analysis, speech synthesis, and automatic speech segmentation.

The project explores fundamental digital signal processing techniques applied to speech signals, including frequency-domain analysis, source-filter speech synthesis, and time-domain feature extraction.

Project Overview

The repository contains three main tasks:

1. Speech Signal Analysis

* Loading and analyzing speech signals.
* Removing the DC component.
* Signal normalization.
* Time-domain visualization.
* Frequency-domain analysis using the Fast Fourier Transform (FFT).
* Comparing the spectral characteristics of different speech sounds.

2. Speech Synthesis

* Generating excitation pulses.
* Modeling glottal airflow using the Rosenberg model.
* Implementing a source-filter model of speech production.
* Synthesizing vowels (A, E, O).
* Investigating the influence of fundamental frequency and filter parameters on the synthesized speech.
* Analyzing synthesized signals in the time and frequency domains.

3. Speech Segmentation

* Loading and preprocessing speech recordings.
* Converting stereo signals to mono and resampling.
* Calculating short-time energy (STE) and zero-crossing rate (ZCR).
* Detecting speech segments using adaptive thresholding.
* Merging short gaps and removing short segments.
* Refining segment boundaries using zero-crossing information.

Repository Structure

speech-signal-processing/
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

Technologies and Methods

* MATLAB
* Digital Signal Processing (DSP)
* Fast Fourier Transform (FFT)
* Source-Filter Speech Production Model
* Rosenberg Glottal Model
* Short-Time Energy (STE)
* Zero-Crossing Rate (ZCR)
* Adaptive Thresholding
* Speech Signal Visualization

Requirements

* MATLAB
* Signal Processing Toolbox may be required for certain functions, such as resampling and window generation.
* Required audio input files must be available when running the corresponding scripts.

Audio Input Files

The analysis and segmentation scripts use the following input files:

* a.wav
* s.wav
* c.wav
* recenica.wav

Make sure these files are available in the MATLAB working directory before running the corresponding scripts.

How to Run

1. Clone or download this repository.
2. Open MATLAB.
3. Set the repository directory as the current working directory.
4. Make sure the required audio files are available.
5. Run the desired script:

speech_signal_analysis
speech_synthesis
speech_segmentation

For speech synthesis, make sure that the helper functions (genpulse.m, rosenmodel.m, and makevowel.m) are available in the MATLAB path.

Purpose

This project demonstrates the application of digital signal processing concepts to speech analysis and synthesis, with a focus on understanding speech production, signal characteristics, and basic speech segmentation techniques.
