Extension { #name : 'Paragraph' }

{ #category : '*FormSceneGraph-Morphic' }
Paragraph >> buildSceneGraphNodeWith: builder bounds: aRectangle color: aColor [
	| displayScanner offset leftInRun result visibleRectangle |
	
	displayScanner := builder displayScannerFor: self.
	visibleRectangle := aRectangle intersect: builder untransformedFullClipping ifNone: [ ^ builder null ].
	offset := aRectangle topLeft - positionWhenComposed.
	leftInRun := 0.
	self
		forLinesIn: visibleRectangle
		do: [ :line | 
			line first <= line last ifTrue: [
				leftInRun := displayScanner displayLine: line offset: offset leftInRun: leftInRun
			] ] .
			
	result := displayScanner sceneGraphNode.
	result isNullNode ifTrue: [ ^ result ].
	^ builder clip: result withRectangle: aRectangle
]
