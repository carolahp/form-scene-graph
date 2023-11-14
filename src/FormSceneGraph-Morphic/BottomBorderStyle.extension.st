Extension { #name : 'BottomBorderStyle' }

{ #category : '*FormSceneGraph-Morphic' }
BottomBorderStyle >> buildSceneGraphNodeForBorder: aRectangle with: builder [
	| trimOffset trimmedRectangle |
	trimOffset := self trimSize @ 0.
	trimmedRectangle := aRectangle origin + trimOffset corner: aRectangle corner - trimOffset.
	^ builder borderRectangle: trimmedRectangle color: self color leftWidth: 0 rightWidth: 0 bottomWidth: 0 topWidth: self width.
]
