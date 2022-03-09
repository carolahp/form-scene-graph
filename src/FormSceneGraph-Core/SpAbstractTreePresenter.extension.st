Extension { #name : #SpAbstractTreePresenter }

{ #category : #'*FormSceneGraph-Core' }
SpAbstractTreePresenter >> expandSubNodes: aPath [ 
	
	| item children |
	item := self itemAtPath: aPath ifAbsent: [ ^ self].
	self expandPath: aPath.
	children := self childrenFor: item.
	
	children withIndexDo: [ :aChild :index | 
		self expandSubNodes: (aPath copyWith: index) ]	
]
