"
I am a world renderer that uses the BitBlt canvas for rendering.
"
Class {
	#name : 'FormCanvasSGWorldRenderer',
	#superclass : 'FormSGAbstractWorldRenderer',
	#category : 'FormSceneGraph-Morphic-WorldRenderer',
	#package : 'FormSceneGraph-Morphic',
	#tag : 'WorldRenderer'
}

{ #category : 'operations' }
FormCanvasSGWorldRenderer >> displayNewSceneGraph: newSceneGraph withDamageRectangle: damageRectangle [
	| renderer requiredFormExtent |
	renderer := self osWindowRenderer.
	requiredFormExtent := self drawingSurfaceExtent.
	renderer form extent = requiredFormExtent ifFalse: [
		renderer form: (Form extent: requiredFormExtent depth: 32)
	].

	renderer drawDuring: [ :canvas |
		FormSGCanvasRenderer new
			surfaceScaleFactor: self scaleFactor;
			render: newSceneGraph on: canvas
	].
	renderer updateRectangle: damageRectangle.
]

{ #category : 'initialization' }
FormCanvasSGWorldRenderer >> osWindowRenderer [
	osWindow ifNil: [ ^ nil ].
	display ifNil: [ display := Form extent: self drawingSurfaceExtent depth: 32 ].
	^ osWindow renderer ifNil: [
		osWindow newFormRenderer: display.
		osWindow renderer
	].
	
]
