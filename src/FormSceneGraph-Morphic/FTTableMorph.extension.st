Extension { #name : #FTTableMorph }

{ #category : #'*FormSceneGraph-Morphic' }
FTTableMorph >> shouldCacheSceneGraphSurface [
	^ false
]

{ #category : #'*FormSceneGraph-Morphic' }
FTTableMorph >> shouldDrawKeyboardFocusIndicator [
	^ self hasKeyboardFocus
]
