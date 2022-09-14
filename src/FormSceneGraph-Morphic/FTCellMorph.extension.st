Extension { #name : #FTCellMorph }

{ #category : #'*FormSceneGraph-Morphic' }
FTCellMorph >> buildSceneGraphNodeWith: builder [
	| result |
	
	topSeparator
		ifTrue: [ result := builder horizontalLineFrom: bounds topLeft to: bounds topRight width: 1 color: self seperatorColor ]
		ifFalse: [ 	result := super buildSceneGraphNodeWith: builder ].
			
	^ result
]
