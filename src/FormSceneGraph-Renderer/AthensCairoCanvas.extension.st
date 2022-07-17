Extension { #name : #AthensCairoCanvas }

{ #category : #'*FormSceneGraph-Renderer' }
AthensCairoCanvas >> pasteSurface: aSurface targetX: targetX targetY: targetY sourceX: sourceX sourceY: sourceY width: width height: height [ 

	self primSetSourceSurface: aSurface x: (targetX - sourceX) asFloat y: (targetY - sourceY).
	self setMatrixForPattern: self primGetSource.
	self primRectangleX: targetX y: targetY width: width height: height. 
	self fill
]

{ #category : #'*FormSceneGraph-Renderer' }
AthensCairoCanvas >> primScaleX: scaleX Y: scaleY [

	^ self ffiCall: #( void cairo_scale ( self , double scaleX , double scaleY ) )
]

{ #category : #'*FormSceneGraph-Renderer' }
AthensCairoCanvas >> primSetSourceSurface: aSurface x: x y: y [

	^ self ffiCall: #( void cairo_set_source_surface ( self , AthensCairoSurface aSurface , double x , double y ) )
]
