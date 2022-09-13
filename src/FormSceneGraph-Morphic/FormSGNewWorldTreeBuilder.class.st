Class {
	#name : #FormSGNewWorldTreeBuilder,
	#superclass : #Object,
	#instVars : [
		'damagedAreas',
		'subTrees',
		'worldTree',
		'builder',
		'scale'
	],
	#pools : [
		'SDL2Constants'
	],
	#category : #'FormSceneGraph-Morphic-WorldRenderer'
}

{ #category : #building }
FormSGNewWorldTreeBuilder >> buildTreeForDamagedAreasOf: aWorldMorph [ 
		
	damagedAreas := self extractDamagedAreasOf: aWorldMorph.

	builder := FormSGBuilder new
		scale: scale;
		clippingRectangles: damagedAreas;
		yourself.	

	damagedAreas ifEmpty: [ builder null ].
	
	subTrees := self buildTreeForSubmorphsOf: aWorldMorph.
	worldTree := self buildTreeForWorldOf: aWorldMorph.
	
	^ worldTree , subTrees
]

{ #category : #'private - building' }
FormSGNewWorldTreeBuilder >> buildTreeForSubmorphsOf: aWorldMorph [ 
	
	| nodes |
	aWorldMorph submorphs ifEmpty: [ ^ builder null ].
	
	nodes := aWorldMorph submorphs collect: [ :aSubMorph | | aNode |
		aNode := aSubMorph buildFullSceneGraphWith: builder.
		builder resetAfterRoot.
		aNode ].
	
	^ builder containerWith: nodes reversed
]

{ #category : #'private - building' }
FormSGNewWorldTreeBuilder >> buildTreeForWorldOf: aWorldMorph [ 
	
	(builder isAlreadyDrawn: aWorldMorph bounds)	
			ifTrue: [ ^ builder null ].

	^ aWorldMorph buildSceneGraphNodeWith: builder
]

{ #category : #accessing }
FormSGNewWorldTreeBuilder >> clippingRectangles [
	
	^ damagedAreas
]

{ #category : #'private - building' }
FormSGNewWorldTreeBuilder >> extractDamagedAreasOf: aWorldMorph [ 
	
	| damageRecorder rects |
	damageRecorder := aWorldMorph worldState damageRecorder.
	rects := damageRecorder invalidRectsFullBounds: aWorldMorph bounds.
	damageRecorder reset.

	^ rects
]

{ #category : #initialization }
FormSGNewWorldTreeBuilder >> initialize [ 

	super initialize.
	scale := 1.
]
