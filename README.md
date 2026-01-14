# Voice-Controlled LCD System (iOS + ESP32)

This project is an end-to-end hardware–software system that converts spoken words on an iPhone into text and displays the text on an ESP32-controlled LCD screen.

The goal of the project is to explore real-time speech recognition, mobile–embedded communication, and basic human–computer interaction.

## Project Overview
The system consists of two main components.

## 1. iOS App (SwiftUI)
The iOS application performs real-time speech-to-text using Apple’s Speech framework. Microphone audio is captured using AVAudioEngine, and the recognized text is displayed live on the phone screen using a SwiftUI interface.

## 2. ESP32 Firmware
The ESP32 firmware is responsible for displaying text on a 16×2 LCD. It handles LCD initialization, basic text formatting, and hardware-level display control. Communication between the iOS app and ESP32 is planned as a next step.

## Features 

iOS App
- Real-time speech recognition
- Microphone permission handling (iOS 17+)
- SwiftUI reactive user interface
- Start and stop recording controls
- Live transcription display

ESP32
- LCD initialization and display logic
- Text formatting for 16×2 LCD
- Embedded firmware written in Arduino-style C++

## Technologies used
- Swift
- SwiftUI
- AVFoundation
- Apple Speech Framework
- ESP32 (Arduino)
- LCD1602

## Development Environemnt
- Xcode
- iOS Simulator
- Arduino IDE
- macOS

## How it works
Speech recognition runs on a mobile device.  
The ESP32 receives text over Bluetooth and displays it on the LCD.
