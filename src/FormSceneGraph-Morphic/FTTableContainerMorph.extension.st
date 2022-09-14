Extension { #name : #FTTableContainerMorph }

{ #category : #'*FormSceneGraph-Morphic' }
FTTableContainerMorph >> doBuildFullSceneGraphWith:builder [

	self drawRowsOn: nil.
	^ super doBuildFullSceneGraphWith: builder.
]
