Class {
	#name : #WorldMorphForTest,
	#superclass : #WorldMorph,
	#instVars : [
		'hasToStopOnNextInvalidation'
	],
	#category : #'FormSceneGraph-Renderer-Test'
}

{ #category : #initialization }
WorldMorphForTest >> initialize [ 
	
	super initialize.
	hasToStopOnNextInvalidation := false
]

{ #category : #initialization }
WorldMorphForTest >> invalidRect: damageRect from: aMorph [

	hasToStopOnNextInvalidation == true ifTrue: [ 
		hasToStopOnNextInvalidation := false.
		self error ].
	^ super invalidRect: damageRect from: aMorph
]

{ #category : #initialization }
WorldMorphForTest >> stopOnNextInvalidation [

	hasToStopOnNextInvalidation := true
]
