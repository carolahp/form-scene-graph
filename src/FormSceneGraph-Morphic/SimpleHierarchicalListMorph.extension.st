Extension { #name : 'SimpleHierarchicalListMorph' }

{ #category : '*FormSceneGraph-Morphic' }
SimpleHierarchicalListMorph >> buildLinesSceneGraphNodeWith: builder [
	"TODO: Implement this if this is required."
	^ builder null
]

{ #category : '*FormSceneGraph-Morphic' }
SimpleHierarchicalListMorph >> buildSceneGraphNodeWith: builder [
	"Draw the selection and lines."
	
	| result |
	result := super buildSceneGraphNodeWith: builder.
	(searchedElement isNotNil or: [selectedMorph isNotNil]) ifTrue: [ 
		result := result , (builder clip: (
			(searchedElement
				ifNil: [builder null]
				ifNotNil: [ builder rectangle: self searchedFrame
					color: (self secondarySelectionColor ifNil: [self theme secondarySelectionColor]) ]) ,
			(selectedMorph
				ifNil: [builder null]
				ifNotNil: [ builder rectangle: self selectionFrame
					color: (self selectionColorToUse ifNil: [ self theme selectionColor ]) ])
			) withRectangle: self innerBounds)
	].

	^ result , (self buildLinesSceneGraphNodeWith: builder)
]
