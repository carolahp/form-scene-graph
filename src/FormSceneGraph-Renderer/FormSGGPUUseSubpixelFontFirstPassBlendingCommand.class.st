"
I am a blending command that enabled the first pass blending mode required for subpixel antialiased font rendering.
"
Class {
	#name : 'FormSGGPUUseSubpixelFontFirstPassBlendingCommand',
	#superclass : 'FormSGGPUSingletonDrawCommand',
	#category : 'FormSceneGraph-Renderer-GPU',
	#package : 'FormSceneGraph-Renderer',
	#tag : 'GPU'
}

{ #category : 'visiting' }
FormSGGPUUseSubpixelFontFirstPassBlendingCommand >> accept: visitor [
	^ visitor useSubpixelFontFirstPassBlending
]
