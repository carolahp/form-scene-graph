"
I am a GPU drawing command for changing the scissor rectangle.
"
Class {
	#name : 'FormSGGPUSetScissorCommand',
	#superclass : 'FormSGGPUDrawCommand',
	#instVars : [
		'rectangle'
	],
	#category : 'FormSceneGraph-Renderer-GPU',
	#package : 'FormSceneGraph-Renderer',
	#tag : 'GPU'
}

{ #category : 'visiting' }
FormSGGPUSetScissorCommand >> accept: visitor [
	^ visitor setScissor: self
]

{ #category : 'testing' }
FormSGGPUSetScissorCommand >> isSetScissor [
	^ true
]

{ #category : 'accessing' }
FormSGGPUSetScissorCommand >> rectangle [
	^ rectangle
]

{ #category : 'accessing' }
FormSGGPUSetScissorCommand >> rectangle: anObject [
	rectangle := anObject
]
