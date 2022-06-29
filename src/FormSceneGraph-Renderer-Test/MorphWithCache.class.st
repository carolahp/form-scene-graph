"
I am a morph that is always cached. Created for testing
"
Class {
	#name : #MorphWithCache,
	#superclass : #Morph,
	#category : #'FormSceneGraph-Renderer-Test'
}

{ #category : #asserting }
MorphWithCache >> shouldCacheSceneGraphSurface [
	^ true
]
