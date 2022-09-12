Extension { #name : #Morph }

{ #category : #'*FormSceneGraph-Core' }
Morph >> invalidateSceneGraph [
		
	self setProperty: #invalidSceneGraph toValue: true.
	self removeProperty: #cachedSubSceneGraph.
	
	owner ifNotNil: [ :e | e invalidateSceneGraph ].
]
