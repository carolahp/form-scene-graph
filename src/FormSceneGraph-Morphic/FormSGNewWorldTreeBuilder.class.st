Class {
	#name : #FormSGNewWorldTreeBuilder,
	#superclass : #Object,
	#instVars : [
		'damagedAreas',
		'subTrees',
		'worldTree',
		'builder',
		'scale',
		'scaledDamagedAreas'
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
FormSGNewWorldTreeBuilder >> extractDamagedAreasOf: aWorldMorph [ 
	
	| damageRecorder |

	damageRecorder := aWorldMorph worldState damageRecorder.
	damagedAreas := damageRecorder invalidRectsFullBounds: aWorldMorph bounds.
	damageRecorder reset.

	scaledDamagedAreas := (scale closeTo: 1) 
		ifTrue: [ damagedAreas ]
		ifFalse: [ damagedAreas collect: [ :e | (e scaleBy: scale) roundTo:1 ] ]
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
