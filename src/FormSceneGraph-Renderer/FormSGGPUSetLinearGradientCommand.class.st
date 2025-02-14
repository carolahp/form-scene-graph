"
I am command used for specifying a linear gradient as a texture.
"
Class {
	#name : 'FormSGGPUSetLinearGradientCommand',
	#superclass : 'FormSGGPUDrawCommand',
	#instVars : [
		'startPoint',
		'endPoint',
		'startColor',
		'endColor'
	],
	#category : 'FormSceneGraph-Renderer-GPU',
	#package : 'FormSceneGraph-Renderer',
	#tag : 'GPU'
}

{ #category : 'visiting' }
FormSGGPUSetLinearGradientCommand >> accept: visitor [
	^ visitor setLinearGradientCommand: self
]

{ #category : 'accessing' }
FormSGGPUSetLinearGradientCommand >> endColor [
	^ endColor
]

{ #category : 'accessing' }
FormSGGPUSetLinearGradientCommand >> endColor: anObject [
	endColor := anObject
]

{ #category : 'accessing' }
FormSGGPUSetLinearGradientCommand >> endPoint [
	^ endPoint
]

{ #category : 'accessing' }
FormSGGPUSetLinearGradientCommand >> endPoint: anObject [
	endPoint := anObject
]

{ #category : 'testing' }
FormSGGPUSetLinearGradientCommand >> isSetLinearGradient [
	^ true
]

{ #category : 'accessing' }
FormSGGPUSetLinearGradientCommand >> startColor [
	^ startColor
]

{ #category : 'accessing' }
FormSGGPUSetLinearGradientCommand >> startColor: anObject [
	startColor := anObject
]

{ #category : 'accessing' }
FormSGGPUSetLinearGradientCommand >> startPoint [
	^ startPoint
]

{ #category : 'accessing' }
FormSGGPUSetLinearGradientCommand >> startPoint: anObject [
	startPoint := anObject
]
