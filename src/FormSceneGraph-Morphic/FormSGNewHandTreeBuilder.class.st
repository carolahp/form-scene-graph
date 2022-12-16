Class {
	#name : #FormSGNewHandTreeBuilder,
	#superclass : #Object,
	#instVars : [
		'handMorph',
		'formBuilder',
		'previousObscuredArea',
		'handObscuredAreas',
		'handDamagedAreas',
		'scaledHandDamagedAreas',
		'scaledHandObscuredAreas',
		'handTree',
		'renderer',
		'handSurface'
	],
	#category : #'FormSceneGraph-Morphic-WorldRenderer'
}

{ #category : #building }
FormSGNewHandTreeBuilder >> buildHandTree [

	handDamagedAreas := OrderedCollection new.
	handObscuredAreas := OrderedCollection new.

	self extractAreas.
	self scaleAreas.

	scaledHandDamagedAreas ifEmpty: [ ^ self ].

	self buildTree.
	self drawTreeInSurface.
]

{ #category : #building }
FormSGNewHandTreeBuilder >> buildTree [

	formBuilder resetAfterRoot.
	formBuilder clearDrawnAreas.
	formBuilder clippingRectangles: scaledHandDamagedAreas.
	
	handTree := handMorph buildFullSceneGraphWith: formBuilder
]

{ #category : #'private - building' }
FormSGNewHandTreeBuilder >> drawTreeInSurface [

	| originOffset |
	
	originOffset := handTree boundingBox origin negated.
	
	handTree offsetPositionBy: originOffset.
	
	renderer clippingRectangles: (scaledHandDamagedAreas collect: [:e | e translateBy: originOffset]).
	handSurface drawDuring: [ :aCanvas |
		renderer render: handTree on: aCanvas ]
]

{ #category : #'private - building' }
FormSGNewHandTreeBuilder >> ensureHandSurface [

	"If the surface is valid and we can fit the handMorph, we not need to create it.
	Returns false, so we know that we don't need to invalidate all the morph"

	| expectedSize |
	expectedSize := handMorph fullBounds extent.
	(formBuilder scale closeTo: 1) 
		ifFalse: [ expectedSize := expectedSize * formBuilder scale ].

	(handSurface isNotNil and: [ 
		 handSurface isValidSession and: [ 
			 handSurface extent >= expectedSize ] ]) ifTrue: [ ^ false ].

	handSurface := AthensCairoSurface extent: expectedSize.
	^ true
]

{ #category : #building }
FormSGNewHandTreeBuilder >> extractAreas [

	previousObscuredArea ifNotNil: [ 
		handObscuredAreas add: previousObscuredArea ].

	"If the handMorph is not need, we will not have obscured area for next frame,
	and we don't redraw nothing"
	handMorph needsToBeDrawn 
		ifFalse: [ previousObscuredArea := nil. ^ self ].
	
	"If the ensure has updated the surface, we need to invalidate all the hand"
	"If the previous obscure area is nil, we have to also redraw everything"
	"If not, just get the damaged areas from the hand"
	(self ensureHandSurface or: [ previousObscuredArea isNil ])
		ifTrue: [ 
			handDamagedAreas add: handMorph fullBounds. 
			handMorph damagedRectangles "We reset" ]
		ifFalse: [ handDamagedAreas addAll: handMorph damagedRectangles ].

	"Add the obscured areas, and keep it for next frame"
	previousObscuredArea := handMorph fullBounds.
	handObscuredAreas add: handMorph fullBounds.
]

{ #category : #accessing }
FormSGNewHandTreeBuilder >> formBuilder: aFormSGBuilder [ 
	formBuilder := aFormSGBuilder
]

{ #category : #accessing }
FormSGNewHandTreeBuilder >> handMorph: aHandMorph [ 
	handMorph := aHandMorph
]

{ #category : #accessing }
FormSGNewHandTreeBuilder >> handTree [
	
	^ handTree
]

{ #category : #'as yet unclassified' }
FormSGNewHandTreeBuilder >> pasteOnCanvas: aCanvas [

	| scaledFullBounds |
	
	handMorph needsToBeDrawn ifFalse: [ ^ self ].
	
	scaledFullBounds := handMorph fullBounds scaleBy: formBuilder scale.

	aCanvas pasteSurface: handSurface 
			targetX: scaledFullBounds origin x 
			targetY: scaledFullBounds origin y 
			sourceX: 0.0
			sourceY: 0.0 
			width: scaledFullBounds extent x 
			height: scaledFullBounds extent y

]

{ #category : #accessing }
FormSGNewHandTreeBuilder >> renderer: aRenderer [ 
	renderer := aRenderer
]

{ #category : #building }
FormSGNewHandTreeBuilder >> scaleAreas [

	| scale |
	scale := formBuilder scale.

	handDamagedAreas := handDamagedAreas reduceRectangles.
	handObscuredAreas := handObscuredAreas reduceRectangles.

	(scale closeTo: 1) ifTrue: [ 
		scaledHandDamagedAreas := handDamagedAreas.
		scaledHandObscuredAreas := handObscuredAreas.
		^ self ].

	scaledHandDamagedAreas := handDamagedAreas collect: [ :e | 
		                          (e scaleBy: scale) roundTo: 1 ].
	scaledHandObscuredAreas := handObscuredAreas collect: [ :e | 
		                           (e scaleBy: scale) roundTo: 1 ]
]

{ #category : #accessing }
FormSGNewHandTreeBuilder >> scaledHandDamagedAreas [

	^ scaledHandDamagedAreas
]

{ #category : #accessing }
FormSGNewHandTreeBuilder >> scaledHandObscuredAreas [
	
	^ scaledHandObscuredAreas 
]
