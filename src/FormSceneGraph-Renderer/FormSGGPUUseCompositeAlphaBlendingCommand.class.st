"
I am draw commands that enables composite alpha blending.
"
Class {
	#name : 'FormSGGPUUseCompositeAlphaBlendingCommand',
	#superclass : 'FormSGGPUSingletonDrawCommand',
	#category : 'FormSceneGraph-Renderer-GPU',
	#package : 'FormSceneGraph-Renderer',
	#tag : 'GPU'
}

{ #category : 'visiting' }
FormSGGPUUseCompositeAlphaBlendingCommand >> accept: visitor [
	^ visitor useCompositeAlphaBlending
]
