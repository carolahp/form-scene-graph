"
I am an OSWindowWorldMorph that uses the OSWindowGenericRenderer as the rendering backend for the scene graph.
"
Class {
	#name : 'FormSGOSWindowGenericRendererWorldMorph',
	#superclass : 'FormSGWorldMorph',
	#category : 'FormSceneGraph-Morphic-WorldRenderer',
	#package : 'FormSceneGraph-Morphic',
	#tag : 'WorldRenderer'
}

{ #category : 'hooks' }
FormSGOSWindowGenericRendererWorldMorph >> worldRendererClass [
	^ FormOSWindowGenericRendererSGWorldRenderer
]
