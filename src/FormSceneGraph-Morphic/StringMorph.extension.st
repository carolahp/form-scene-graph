Extension { #name : 'StringMorph' }

{ #category : '*FormSceneGraph-Morphic' }
StringMorph >> buildSceneGraphNodeWith: builder [

	^ (builder string: self contents 
		in: self stringBounds 
		font: self fontToUse 
		color: self stringColor
		underline: (emphasis bitAnd: 2r100) ~~ 0
		underlineColor: self underlineColor 
		strikethrough: (emphasis bitAnd: 2r10000) ~~ 0
		strikethroughColor: self strikethroughColor),
		(builder fillRectangle: self bounds style: self backgroundColor)
]
