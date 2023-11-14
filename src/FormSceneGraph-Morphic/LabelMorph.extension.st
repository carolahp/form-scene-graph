Extension { #name : 'LabelMorph' }

{ #category : '*FormSceneGraph-Morphic' }
LabelMorph >> buildSceneGraphNodeWith: builder [

	(self enabled not and: [ self disabledStyle = #inset ])	ifTrue: [
		^ (builder
			string: self contents
			in: (self stringBounds translateBy: 1)
			font: self fontToUse
			color: self theme lightBackgroundColor), super buildSceneGraphNodeWith: builder
	].

	^ super buildSceneGraphNodeWith: builder
]
