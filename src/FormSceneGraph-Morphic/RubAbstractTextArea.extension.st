Extension { #name : #RubAbstractTextArea }

{ #category : #'*FormSceneGraph-Morphic' }
RubAbstractTextArea >> buildChildrenSceneGraphNodeWith: builder [
	| result paragraphDecorator |

	paragraphDecorator := self paragraph buildSceneGraphNodeWith: builder bounds: self drawingBounds color: self textColor.
	result := super buildChildrenSceneGraphNodeWith: builder.
	^ result , paragraphDecorator
]

{ #category : #'*FormSceneGraph-Morphic' }
RubAbstractTextArea >> shouldDrawKeyboardFocusIndicator [
	^ (scrollPane isNil and: [ self readOnly not and: [ self hasKeyboardFocus or: [ self hasFindReplaceFocus ] ] ])
]
