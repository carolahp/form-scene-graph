Extension { #name : 'CheckboxButtonMorph' }

{ #category : '*FormSceneGraph-Morphic' }
CheckboxButtonMorph >> buildSceneGraphNodeWith: builder [
	| result imageToUse formToUse |
	result := builder fillRectangle: self bounds fillStyle: self fillStyle borderStyle: self borderStyle.
	imageToUse := self formSetToUse.
	imageToUse ifNotNil: [
		formToUse := imageToUse asForm.
		result := result , (builder textureForm: formToUse at: self innerBounds center - (formToUse extent // 2))
	].

	((self state == #pressed or: [self state == #repressed]) and: [formSet isNil]) ifTrue: [
		result := result , (builder rectangle: self innerBounds color: (self paneColor alpha: 0.3))
	].
	(self enabled not and: [self theme fadeCheckboxWhenDisabled]) ifTrue: [
		result := result , (builder rectangle: self innerBounds color: (self paneColor alpha: 0.4))
	].

	^ result
]
