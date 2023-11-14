"
I am an OSWindowWorldMorph that uses Athens as the rendering backend for the scene graph.
"
Class {
	#name : 'FormSGAthensWorldMorph',
	#superclass : 'FormSGWorldMorph',
	#category : 'FormSceneGraph-Morphic-WorldRenderer',
	#package : 'FormSceneGraph-Morphic',
	#tag : 'WorldRenderer'
}

{ #category : 'hooks' }
FormSGAthensWorldMorph >> worldRendererClass [
	^ FormAthensSGWorldRenderer
]
