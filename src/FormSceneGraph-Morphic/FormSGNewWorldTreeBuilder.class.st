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
		'scaledHandObscuredAreas',
		'handBuilders',
		'renderer'
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

	self buildTreeForHandsOf: aWorldMorph	
]

{ #category : #'private - building' }
FormSGNewWorldTreeBuilder >> buildTreeForHandsOf: aWorldMorph [ 
	
	scaledHandObscuredAreas := OrderedCollection new.
	
	aWorldMorph hands do: [ :aHand | | handTreeBuilder |
		handTreeBuilder := self handTreeBuilderFor: aHand.
		handTreeBuilder buildHandTree.
		scaledHandObscuredAreas addAll: handTreeBuilder scaledHandObscuredAreas].
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

{ #category : #'accessing - results' }
FormSGNewWorldTreeBuilder >> damagedAreas [
	
	^ damagedAreas
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
	
	damagedAreas := damagedAreas reduceRectangles.
	
	scaledDamagedAreas :=  (scale closeTo: 1) 
		ifTrue: [ damagedAreas] 
		ifFalse: [ damagedAreas collect: [ :e | (e scaleBy: scale) roundTo:1 ]]
]

{ #category : #'accessing - results' }
FormSGNewWorldTreeBuilder >> handTree [
	
	"This method is only valid if there is a single hand. 
	If there is more, you have to access through the hand builder API"
	
	self assert: handBuilders size = 1.
	^ handBuilders anyOne handTree
]

{ #category : #'private - accessing' }
FormSGNewWorldTreeBuilder >> handTreeBuilderFor: aHandMorph [

	^ handBuilders at: aHandMorph 
		ifPresent: [ :aHandBuilder | aHandBuilder 
				formBuilder: builder; 
				renderer: renderer;
				yourself ]
		ifAbsentPut: [ 
			  FormSGNewHandTreeBuilder new
				  handMorph: aHandMorph;
				  formBuilder: builder;
				  renderer: renderer;				
				  yourself ]
]

{ #category : #'accessing - result' }
FormSGNewWorldTreeBuilder >> handTreeBuilders [
	
	^ handBuilders values
]

{ #category : #initialization }
FormSGNewWorldTreeBuilder >> initialize [ 

	super initialize.
	scale := 1.
	handBuilders := WeakIdentityKeyDictionary new

]

{ #category : #'accessing - parameters' }
FormSGNewWorldTreeBuilder >> renderer [

	^ renderer
]

{ #category : #'accessing - parameters' }
FormSGNewWorldTreeBuilder >> renderer: aRenderer [

	renderer := aRenderer
]

{ #category : #'accessing - parameters' }
FormSGNewWorldTreeBuilder >> scale: aValue [
	
	scale := aValue
]

{ #category : #'accessing - results' }
FormSGNewWorldTreeBuilder >> scaledDamagedAreas [
	
	^ scaledDamagedAreas
]

{ #category : #'accessing - results' }
FormSGNewWorldTreeBuilder >> scaledHandObscuredAreas [

	^ scaledHandObscuredAreas
]

{ #category : #'accessing - results' }
FormSGNewWorldTreeBuilder >> worldTree [
	
	^ worldTree , subTrees
]
