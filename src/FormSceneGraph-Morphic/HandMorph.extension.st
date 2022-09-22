Extension { #name : #HandMorph }

{ #category : #'*FormSceneGraph-Morphic' }
HandMorph >> buildSceneGraphNodeWith: builder [
	temporaryCursor ifNil: [ ^ builder null ].
	^ builder texturedRectangle: (bounds topLeft extent: temporaryCursor extent) form: temporaryCursor
]

{ #category : #'*FormSceneGraph-Morphic' }
HandMorph >> buildShadowForChildrenNode: aChildNode with: aBuilder [

	| subBnds |
	aChildNode isNullNode ifTrue: [ ^ aBuilder null ].
	subBnds := Rectangle merging: (submorphs collect: [:m | m fullBounds]).

	^ aBuilder rectangle: (subBnds translateBy: self shadowOffset) color: self shadowColor
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
	
	| contentNode childrenNode overlayNode shadowNode |
	
	overlayNode := self buildOverlaySceneGraphNodeWith: builder.
	contentNode := self buildSceneGraphNodeWith: builder.
	childrenNode := self buildChildrenSceneGraphNodeWith: builder.
	shadowNode := self buildShadowForChildrenNode: childrenNode with: builder.
	
	^ shadowNode, childrenNode , contentNode , overlayNode
]

{ #category : #'*FormSceneGraph-Morphic' }
HandMorph >> sceneSavedDamageRectangle [
	^ self valueOfProperty: #sceneSavedDamageRectangle ifAbsent: [ nil ]
]

{ #category : #'*FormSceneGraph-Morphic' }
HandMorph >> sceneSavedDamageRectangle: rectangle [
	^ self setProperty: #sceneSavedDamageRectangle toValue: rectangle
]
