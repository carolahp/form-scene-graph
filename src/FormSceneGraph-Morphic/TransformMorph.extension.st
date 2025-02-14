Extension { #name : 'TransformMorph' }

{ #category : '*FormSceneGraph-Morphic' }
TransformMorph >> buildChildrenSceneGraphNodeWith: builder [

	submorphs isEmpty ifTrue: [ ^ builder null ].
	^ builder withClippingBounds: self innerBounds when: self clipSubmorphs build: [ 
		builder withTransform: transform build: [ 
			self buildClippedChildrenSceneGraphNodeWith: builder
		]
	].

]

{ #category : '*FormSceneGraph-Morphic' }
TransformMorph >> invalidRect: damageRect from: aMorph [
	"Translate damage reports from submorphs by the scrollOffset."
	
	self invalidateSceneGraph.
	
	aMorph == self
		ifTrue:[super invalidRect: damageRect from: self]
		ifFalse:[super invalidRect: (((transform localBoundsToGlobal: damageRect) intersect: bounds ifNone: [ ^ self ] ) expandBy: 1) from: self].
]
