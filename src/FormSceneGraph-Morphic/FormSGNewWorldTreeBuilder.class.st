Class {
	#name : #FormSGNewWorldTreeBuilder,
	#superclass : #Object,
	#instVars : [
		'damagedAreas',
		'subTrees',
		'worldTree',
		'builder',
		'scale',
		'scaledDamagedAreas',
		'handDamagedAreas',
		'scaledHandDamagedAreas',
		'handObscuredAreas',
		'scaledHandObscuredAreas'
	],
	#pools : [
		'SDL2Constants'
	],
	#category : #'FormSceneGraph-Morphic-WorldRenderer'
}

{ #category : #building }
FormSGNewWorldTreeBuilder >> buildTreeForDamagedAreasOf: aWorldMorph [ 
		
	self extractDamagedAreasOf: aWorldMorph.

	builder := FormSGBuilder new
		scale: scale;
		clippingRectangles: scaledDamagedAreas;
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

{ #category : #accessing }
FormSGNewWorldTreeBuilder >> damagedAreas [
	
	^ damagedAreas
]

{ #category : #'private - building' }
FormSGNewWorldTreeBuilder >> extractDamagedAreasFromHandsOf: aWorldMorph [

	handDamagedAreas := OrderedCollection new.
	handObscuredAreas := OrderedCollection new.

	aWorldMorph hands do: [ :e |
		(e needsToBeDrawn and: [ e hasChanged ])
			ifTrue: [ 
				handDamagedAreas addAll: e damagedRectangles.
				handObscuredAreas add: e fullBounds]].
]

{ #category : #'private - building' }
FormSGNewWorldTreeBuilder >> extractDamagedAreasFromWorld: aWorldMorph [

	| damageRecorder |
	damageRecorder := aWorldMorph worldState damageRecorder.
	damagedAreas := damageRecorder invalidRectsFullBounds:
		                aWorldMorph bounds.
	damageRecorder reset
]

{ #category : #'private - building' }
FormSGNewWorldTreeBuilder >> extractDamagedAreasOf: aWorldMorph [ 
	
	self extractDamagedAreasFromWorld: aWorldMorph.
	self extractDamagedAreasFromHandsOf: aWorldMorph.
	
	(scale closeTo: 1) 
		ifTrue: [ 
			scaledDamagedAreas := damagedAreas.
			scaledHandDamagedAreas := handDamagedAreas.
			scaledHandObscuredAreas := handObscuredAreas.
		] ifFalse: [ 
			scaledDamagedAreas := damagedAreas collect: [ :e | (e scaleBy: scale) roundTo:1 ].
			scaledHandDamagedAreas := handDamagedAreas collect: [ :e | (e scaleBy: scale) roundTo:1 ].
			scaledHandObscuredAreas := handObscuredAreas collect: [ :e | (e scaleBy: scale) roundTo:1]
		]
]

{ #category : #accessing }
FormSGNewWorldTreeBuilder >> handDamagedAreas [
	
	^ handDamagedAreas
]

{ #category : #accessing }
FormSGNewWorldTreeBuilder >> handObscuredAreas [
	
	^ handObscuredAreas
]

{ #category : #initialization }
FormSGNewWorldTreeBuilder >> initialize [ 

	super initialize.
	scale := 1.

]

{ #category : #accessing }
FormSGNewWorldTreeBuilder >> scale: aValue [
	
	scale := aValue
]

{ #category : #accessing }
FormSGNewWorldTreeBuilder >> scaledDamagedAreas [
	
	^ scaledDamagedAreas
]

{ #category : #accessing }
FormSGNewWorldTreeBuilder >> scaledHandDamagedAreas [
	^ scaledHandDamagedAreas
]

{ #category : #accessing }
FormSGNewWorldTreeBuilder >> scaledHandObscuredAreas [
	^ scaledHandObscuredAreas
]
