Extension { #name : #AthensCairoCanvas }

{ #category : #'*FormSceneGraph-Core' }
AthensCairoCanvas >> setMatrixForPattern: aCairoPattern [

	^ self ffiCall: #(void cairo_pattern_set_matrix (cairo_pattern_t aCairoPattern,
			AthensCairoMatrix * pathTransform) )
]
