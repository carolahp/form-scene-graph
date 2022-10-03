Extension { #name : #RSAthensMorph }

{ #category : #'*FormSceneGraph-Roassal' }
RSAthensMorph >> buildSceneGraphNodeWith: builder [
	self checkSession.
	
	^ (builder rectangle: self bounds color: roassalCanvas color) ,
	(builder rectangle: self bounds surface: surface drawWithAthens: [ :drawSurface :scaleFactorX :scaleFactorY |
		self drawOnAthensNodeSurface: drawSurface withScaleX: scaleFactorX Y: scaleFactorY
	])
]

{ #category : #'*FormSceneGraph-Roassal' }
RSAthensMorph >> drawOnAthensNodeSurface: aSurface withScaleX: scaleFactorX Y: scaleFactorY [
	"Draw the whole visualization"
	isDrawing ifTrue: [ ^ self ].
	isDrawing := true.
	
	[
		surface := aSurface.
		roassalCanvas extent = self extent ifFalse: [ roassalCanvas extent: self extent ].
		roassalCanvas playAnimations.
		self drawShapesWithScaleX: scaleFactorX Y: scaleFactorY.
	] ensure: [ isDrawing := false ]
]
