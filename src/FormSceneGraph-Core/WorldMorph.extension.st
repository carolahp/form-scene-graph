Extension { #name : #WorldMorph }

{ #category : #'*FormSceneGraph-Core' }
WorldMorph >> buildFullSceneGraphWith: builder [ 

	"There is not caching in WorldMorph"
	^self doBuildFullSceneGraphWith: builder

]
