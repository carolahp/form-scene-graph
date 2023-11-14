"
I am the end marker for command recording. I am typically used for rendering text with subpixel antialiasing by doing two passes.
"
Class {
	#name : 'FormSGGPUEndCommandRecording',
	#superclass : 'FormSGGPUSingletonDrawCommand',
	#category : 'FormSceneGraph-Renderer-GPU',
	#package : 'FormSceneGraph-Renderer',
	#tag : 'GPU'
}

{ #category : 'visiting' }
FormSGGPUEndCommandRecording >> accept: visitor [
	^ visitor endCommandRecording
]

{ #category : 'testing' }
FormSGGPUEndCommandRecording >> isEndCommandRecording [
	^ true
]
