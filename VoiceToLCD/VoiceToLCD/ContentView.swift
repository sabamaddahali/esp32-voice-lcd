import SwiftUI
import Speech
import AVFoundation

struct ContentView: View {
    @State private var transcript = "Tap Start and speak" // Stores the words you spoke
    @State private var isRecording = false // tracks whether we are currently recording or not
    
    let speechRecognizer = SFSpeechRecognizer() // creates object turning audio into text
    let audioEngine = AVAudioEngine() // microphone pipeline
    let request = SFSpeechAudioBufferRecognitionRequest() // data buffer where audio enters and speech recognizer reads from
    @State private var recognitionTask: SFSpeechRecognitionTask? // saves current speech to text job to keep it alive while recording
   
    // UI definition: describes what the screen should look like and what happens when useer interacts
    var body: some View {
        // everything inside stacked with 20px spacing
        VStack(spacing: 20) {
            // displays current value of transcript on the screen
            Text(transcript) // displays whatever is inside the transcript var
                .padding()                           // space around the text
                .font(.title2)                       // font size
                .multilineTextAlignment(.center)     // center alignment
            
            // Button whos label changes based on the state
            Button(isRecording ? "Stop" : "Start") {
                // if recording --> stop
                // if not recording --> start
                isRecording ? stopRecording() : startRecording()
            }
            .font(.title) // make button text bigger
        }
        .padding()      // padding around entire screen
        
        // runs once when screen appears
        .onAppear {
            requestPermission()
        }
    }
    
    // requests mic + speech permissions
    func requestPermission() {
        SFSpeechRecognizer.requestAuthorization { _ in }
        AVAudioApplication.requestRecordPermission { _ in }
    }
    
    // start recording
    func startRecording() {
        //updates screen and button
        transcript = "Listening..."
        isRecording = true
        
        // DEBUGGING: configure audio session
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)
       
        //gets microphone audio format
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        
        //install audio tap so microphone audio flows into request
        node.installTap(onBus: 0,
                    bufferSize: 1024,
                    format: recordingFormat) { buffer, _ in
            self.request.append(buffer) // sends audio to speech recognizer
        }
        
        //starts microphone
        audioEngine.prepare()
        try? audioEngine.start()
        
        //starts speech recognition
        recognitionTask =
            speechRecognizer?.recognitionTask(with: request) {
                result, error in
                if let result = result {
                    DispatchQueue.main.async {
                                            self.transcript = result.bestTranscription.formattedString
                    }
                }
            }
    }
    
    // stop recording + mic + speech engine
    func stopRecording() {
            isRecording = false
            
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0) //matches the installed tap
            
            request.endAudio() //tells speech recognizer no more audio
            
            recognitionTask?.cancel() //stop active recognition task
            recognitionTask = nil
    }
}
