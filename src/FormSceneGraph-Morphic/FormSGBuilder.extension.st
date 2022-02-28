Extension { #name : #FormSGBuilder }

{ #category : #'*FormSceneGraph-Morphic' }
FormSGBuilder >> borderRectangle: aRectangle style: aBorderStyle [
	^ aBorderStyle buildSceneGraphNodeForBorder: aRectangle with: self
]

{ #category : #'*FormSceneGraph-Morphic' }
FormSGBuilder >> displayScannerFor: paragraph [
	^ FormSGDisplayScanner for: paragraph with: self
]

{ #category : #'*FormSceneGraph-Morphic' }
FormSGBuilder >> fillRectangle: aRectangle fillStyle: aFillStyle borderStyle: aBorderStyle [
	
	"If there is no border and color transparent"
	(aFillStyle isTransparent and: [ aBorderStyle width <= 0 ])
		ifTrue: [ ^ self null ].

	"If there is no border, just the color rectangle (content)"	
	(aBorderStyle isNil or: [aBorderStyle width <= 0]) ifTrue: [
		^ self fillRectangle: aRectangle style: aFillStyle
	].

	"If there is a border, we put inside the content that might be a nullNode"	
	^ (self borderRectangle: aRectangle style: aBorderStyle)
		content: 	(self fillRectangle: (aRectangle insetBy: aBorderStyle width) style: aFillStyle);
		yourself
		
]

{ #category : #'*FormSceneGraph-Morphic' }
FormSGBuilder >> fillRectangle: aRectangle style: aFillStyle [
	aFillStyle ifNil: [ ^ self null ].
	^ aFillStyle buildSceneGraphNodeForFilling: aRectangle with: self
]

{ #category : #'*FormSceneGraph-Morphic' }
FormSGBuilder >> frameRectangle: aRectangle width: width colors: colors dashes: dashes [
	self flag: 'TODO: Implement this properly.'.
	^ self null
]

{ #category : #'*FormSceneGraph-Morphic' }
FormSGBuilder >> rectangle: aRectangle fillStyle: aFillStyle [
	^ self fillRectangle: aRectangle style: aFillStyle
]

{ #category : #'*FormSceneGraph-Morphic' }
FormSGBuilder >> rectangle: aRectangle fillStyle: aFillStyle borderStyle: aBorderStyle [
	(aBorderStyle isNil or: [aBorderStyle width < 0]) ifTrue: [
		^ self rectangle: aRectangle fillStyle: aFillStyle
	].
	
	^ (self rectangle: (aRectangle insetBy: aBorderStyle width) fillStyle: aFillStyle) ,
		(self borderRectangle: aRectangle style: aBorderStyle)
]
