Extension { #name : 'ImageMorph' }

{ #category : '*FormSceneGraph-Morphic' }
ImageMorph >> buildSceneGraphNodeWith: builder [

	| form node |
	form := self formSet asFormAtScale: 1.

	node := builder
		   textureForm: form
		   at: self innerBounds origin
		   opaque: self isOpaque.
	
	node shouldScale: false.
	"node shouldScale: (image isKindOf: Icon) not."

	^ node
	  , (builder borderRectangle: self bounds style: self borderStyle)
]
