"
I am the start marker for command recording. I am typically used for rendering text with subpixel antialiasing by doing two passes.
"
Class {
	#name : 'FormSGGPUBeginCommandRecording',
	#superclass : 'FormSGGPUSingletonDrawCommand',
	#category : 'FormSceneGraph-Renderer-GPU',
	#package : 'FormSceneGraph-Renderer',
	#tag : 'GPU'
}

{ #category : 'visiting' }
FormSGGPUBeginCommandRecording >> accept: visitor [
	^ visitor beginCommandRecording
]

{ #category : 'testing' }
FormSGGPUBeginCommandRecording >> isBeginCommandRecording [
	^ false
]
