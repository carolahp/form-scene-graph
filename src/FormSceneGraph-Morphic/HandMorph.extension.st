Extension { #name : #HandMorph }

{ #category : #'*FormSceneGraph-Morphic' }
HandMorph >> activateSceneHardwareCursor [
	| cursor |
	self world ifNil: [ ^ self ].
	self world activeHand == self ifFalse: [ ^ self ].
	cursor := hardwareCursor ifNil: [Cursor normal].
	self currentCursor == cursor ifFalse: [ cursor show ]
]

{ #category : #'*FormSceneGraph-Morphic' }
HandMorph >> buildSceneGraphNodeWith: builder [
	| cursor |
	self activateSceneHardwareCursor.
	self shouldUseHardwareCursorForScene ifTrue: [ ^ builder null ].

	cursor := temporaryCursor ifNil: [ NormalCursor ].
	^ builder texturedRectangle: (bounds topLeft extent: cursor extent) form: cursor
]

{ #category : #'*FormSceneGraph-Morphic' }
HandMorph >> computeDamageRectForNextFrame [
	| savedDamageRectangle damageRect myBounds |
	savedDamageRectangle := self sceneSavedDamageRectangle.

	(submorphs isEmpty 
		and: [savedDamageRectangle isNil 
			"and: [self shouldUseHardwareCursorForScene ]"]) 
		ifTrue: [ ^ Rectangle empty ].
		
	damageRect := myBounds := self fullBounds.
	
	savedDamageRectangle isEmpty 
		ifFalse: [ damageRect := damageRect merge: savedDamageRectangle].
	
	self sceneSavedDamageRectangle: damageRect.
	hasChanged := false.

	submorphs ifNotEmpty: [
		self sceneSavedDamageRectangle: myBounds.
	] ifEmpty: [
		self sceneSavedDamageRectangle: nil.
	].

	^ damageRect
]

{ #category : #'*FormSceneGraph-Morphic' }
HandMorph >> damagedRectangles [

	| subBnds rectList |
	
	subBnds := Rectangle merging: (submorphs collect: [:m | m fullBounds]).
	rectList := damageRecorder invalidRectsFullBounds: subBnds.
	damageRecorder reset.

	^ rectList
]

{ #category : #'*FormSceneGraph-Morphic' }
HandMorph >> doBuildFullSceneGraphWith: builder [
	| contentNode childrenNode overlayNode |
	overlayNode := self buildOverlaySceneGraphNodeWith: builder.
	contentNode := self buildSceneGraphNodeWith: builder.
	childrenNode := self buildChildrenSceneGraphNodeWith: builder.	
	^ childrenNode , contentNode , overlayNode
]

{ #category : #'*FormSceneGraph-Morphic' }
HandMorph >> sceneRenderingCursor [
	^ hardwareCursor ifNil: [ temporaryCursor ifNil: [ Cursor normal ] ]
]

{ #category : #'*FormSceneGraph-Morphic' }
HandMorph >> sceneSavedDamageRectangle [
	^ self valueOfProperty: #sceneSavedDamageRectangle ifAbsent: [ Rectangle empty ]
]

{ #category : #'*FormSceneGraph-Morphic' }
HandMorph >> sceneSavedDamageRectangle: rectangle [
	^ self setProperty: #sceneSavedDamageRectangle toValue: rectangle
]

{ #category : #'*FormSceneGraph-Morphic' }
HandMorph >> shouldUseHardwareCursorForScene [
	^ self sceneRenderingCursor isValidHardwareCompatibleCursor and: [self == self world activeHand]
]
