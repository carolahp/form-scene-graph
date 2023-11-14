"
I am a GPU drawing command that disables texturing.
"
Class {
	#name : 'FormSGGPUNoTextureCommand',
	#superclass : 'FormSGGPUSingletonDrawCommand',
	#category : 'FormSceneGraph-Renderer-GPU',
	#package : 'FormSceneGraph-Renderer',
	#tag : 'GPU'
}

{ #category : 'visiting' }
FormSGGPUNoTextureCommand >> accept: visitor [
	^ visitor noTexture
]

{ #category : 'testing' }
FormSGGPUNoTextureCommand >> isNoTexture [
	^ true
]
