"
I represent an abstract GPU based draw command.
"
Class {
	#name : 'FormSGGPUDrawCommand',
	#superclass : 'Object',
	#category : 'FormSceneGraph-Renderer-GPU',
	#package : 'FormSceneGraph-Renderer',
	#tag : 'GPU'
}

{ #category : 'testing' }
FormSGGPUDrawCommand class >> isAbstract [
	^ self == FormSGGPUDrawCommand
]

{ #category : 'visiting' }
FormSGGPUDrawCommand >> accept: visitor [
	self subclassResponsibility
]

{ #category : 'testing' }
FormSGGPUDrawCommand >> isBeginCommandRecording [
	^ false
]

{ #category : 'testing' }
FormSGGPUDrawCommand >> isDrawElements [
	^ false
]

{ #category : 'testing' }
FormSGGPUDrawCommand >> isEndCommandRecording [
	^ false
]

{ #category : 'testing' }
FormSGGPUDrawCommand >> isNoTexture [
	^ false
]

{ #category : 'testing' }
FormSGGPUDrawCommand >> isSetAthensSurfaceTextureWithModificationCount [
	^ false
]

{ #category : 'testing' }
FormSGGPUDrawCommand >> isSetFormTexture [
	^ false
]

{ #category : 'testing' }
FormSGGPUDrawCommand >> isSetFormTextureWithModificationCount [
	^ false
]

{ #category : 'testing' }
FormSGGPUDrawCommand >> isSetLinearGradient [
	^ false
]

{ #category : 'testing' }
FormSGGPUDrawCommand >> isSetRadialGradient [
	^ false
]

{ #category : 'testing' }
FormSGGPUDrawCommand >> isSetRenderTargetTextureWithModificationCountCommand [
	^ false
]

{ #category : 'testing' }
FormSGGPUDrawCommand >> isSetScissor [
	^ false
]
