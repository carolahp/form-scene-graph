Extension { #name : 'TextMorph' }

{ #category : '*FormSceneGraph-Morphic' }
TextMorph >> buildSceneGraphNodeWith: builder [
	| result fauxBounds paragraphNode |
	
	(self startingIndex > text size)
		ifTrue: [ ^ super buildSceneGraphNodeWith: builder ].
	
	fauxBounds := self bounds topLeft corner: self innerBounds bottomRight.
	paragraphNode := self paragraph buildSceneGraphNodeWith: builder bounds: fauxBounds color: color.
	result := super buildSceneGraphNodeWith: builder.
			
	^ result , paragraphNode
]
