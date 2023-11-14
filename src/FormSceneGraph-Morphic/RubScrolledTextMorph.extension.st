Extension { #name : 'RubScrolledTextMorph' }

{ #category : '*FormSceneGraph-Morphic' }
RubScrolledTextMorph >> buildClippedChildrenSceneGraphNodeListWith: builder [
	| submorphNodes drawBlock subs |

	submorphNodes := OrderedCollection new.
	drawBlock := [ :each |
		| childNode |
		childNode := each buildFullSceneGraphWith: builder.
		childNode isNullNode ifFalse: [
			submorphNodes add: childNode
		]
	].

	subs := submorphs copyWithoutAll: self sideRulers.
	subs do: drawBlock.

	subs := self sideRulers.
	subs do: drawBlock.

	^ submorphNodes reverse

]

{ #category : '*FormSceneGraph-Morphic' }
RubScrolledTextMorph >> buildHighlightsSceneGraphNodeWith: builder [
	| scrollBounds scrollOffset |
	
	scrollBounds := self scrollPane innerBounds.
	scrollOffset := self scrollPane scroller offset.
	
	^ builder withClippingBounds: self clippingBounds build: [ 
		builder containerWith: (self highlights collect: [:highlight |
			highlight buildSceneGraphNodeWith: builder in: scrollBounds offset: scrollOffset 
		])
	].
]

{ #category : '*FormSceneGraph-Morphic' }
RubScrolledTextMorph >> buildSceneGraphNodeWith: builder [

	^ (super buildSceneGraphNodeWith: builder) ,
	(self buildHighlightsSceneGraphNodeWith: builder)
]

{ #category : '*FormSceneGraph-Morphic' }
RubScrolledTextMorph >> shouldCacheSceneGraphSurface [
	^ "self fillStyle isTransparent not" false
]
