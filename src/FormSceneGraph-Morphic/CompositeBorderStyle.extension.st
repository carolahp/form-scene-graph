Extension { #name : 'CompositeBorderStyle' }

{ #category : '*FormSceneGraph-Morphic' }
CompositeBorderStyle >> buildSceneGraphNodeForBorder: aRectangle with: builder [
	| result |
	result := builder null.
	borders do: [ :each |
		result := result , (each buildSceneGraphNodeForBorder: aRectangle with: builder)
	].
	^ result
]
