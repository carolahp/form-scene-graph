Extension { #name : #ImageMorph }

{ #category : #'*FormSceneGraph-Morphic' }
ImageMorph >> buildSceneGraphNodeWith: builder [

	| form node |
	form := image asForm.

	node := builder
		   textureForm: form
		   at: self innerBounds origin
		   opaque: self isOpaque.

	"node shouldScale: (image isKindOf: Icon) not."

	^ node
	  , (builder borderRectangle: self bounds style: self borderStyle)
]
