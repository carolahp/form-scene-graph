Extension { #name : #Morph }

{ #category : #'*FormSceneGraph-Core' }
Morph >> invalidateSceneGraph [
		
	self setProperty: #invalidSceneGraph toValue: true.
	self removeProperty: #cachedSubSceneGraph.
	
	self submorphs do: [ :aMorph | aMorph invalidateSceneGraph ]
]
