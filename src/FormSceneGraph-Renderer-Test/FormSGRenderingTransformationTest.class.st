Class {
	#name : #FormSGRenderingTransformationTest,
	#superclass : #ParametrizedTestCase,
	#instVars : [
		'morphExtent',
		'morph',
		'transformationMorph'
	],
	#category : #'FormSceneGraph-Renderer-Test'
}

{ #category : #tests }
FormSGRenderingTransformationTest class >> testParameters [

	| morph |
	^ ParametrizedTestMatrix new
		  forSelector: #morph 
		  addOptions: { 
				(morph := Morph new) .
				(morph := (Smalltalk ui icons iconNamed: #up) asMorph) .
				 };
		  
		  forSelector: #transformationMorph
		  addOptions: { 
				(TransformationMorph new
				   addMorph: morph;
				   yourself) }
]

{ #category : #asserting }
FormSGRenderingTransformationTest >> assert: form1 closeTo: form2 [
	
	| diff greenProportion redProportion |
	diff := self diffBetween: form1 and: form2.
	greenProportion := self color: Color green proportionIn: diff.
	redProportion := self color: Color red proportionIn: diff.
	((greenProportion asFloat > 0.02 ) or: [(redProportion asFloat > 0.02 )]) 
		ifTrue: [ form1 inspect. form2 inspect ]. 
	self assert: (greenProportion asFloat < 0.02 ).
	self assert: (redProportion asFloat < 0.02 ).
	"diff inspect"
]

{ #category : #'building-rendering' }
FormSGRenderingTransformationTest >> buildNodesFromMorph: aMorph withScale: aScale [
	
	| builder |
	morphExtent := aMorph extent.
	
	builder := FormSGBuilder new 
		scale: aScale; 
		yourself.

	^ aMorph buildFullSceneGraphWith: builder
]

{ #category : #utilities }
FormSGRenderingTransformationTest >> color: aColor proportionIn: aForm [
	
	| colorCount |
	
	colorCount := 0.
	
	0 to: aForm width - 1 do: [ :x |
		0 to: aForm height - 1 do: [ :y |
		(aForm colorAt: x@y) = aColor 
			ifTrue: [ colorCount := colorCount + 1  ]
	]].
	
	^ colorCount / (aForm width * aForm height)
]

{ #category : #utilities }
FormSGRenderingTransformationTest >> diffBetween: form and: reference [
	"Receives two Forms and returns a surface representing the differences found between form and reference.
	A red pixel means the pixel is painted in form but not in reference.
	A green pixel means the pixel is painted in reference but not in form."
	0 to: reference extent x do: [ :x | 
		0 to: reference extent y do: [ :y | 
			((form colorAt: x @ y) diff: (reference colorAt: x @ y)) < 0.2 
				ifFalse: [ 
					((form colorAt: x @ y) isTransparent not and: [ 
						 (reference colorAt: x @ y) isTransparent ]) ifTrue: [ 
						reference colorAt: x @ y put: Color red ].
					((form colorAt: x @ y) isTransparent and: [ 
						 (reference colorAt: x @ y) isTransparent not ]) ifTrue: [ 
						reference colorAt: x @ y put: Color green ] ] ] ].
	^ reference
]

{ #category : #'building-rendering' }
FormSGRenderingTransformationTest >> morph [
	^ morph
]

{ #category : #'building-rendering' }
FormSGRenderingTransformationTest >> morph: aMorph [
	morph := aMorph
]

{ #category : #utilities }
FormSGRenderingTransformationTest >> newContainerMorph [

	^ Morph new
		  extent: 100 @ 100;
		  beTransparent;
		  yourself
]

{ #category : #'building-rendering' }
FormSGRenderingTransformationTest >> renderMorph: aMorph withScale: aScale [
	
	^ self renderNodes: (self buildNodesFromMorph: aMorph withScale: aScale) 
		    withScale: aScale
]

{ #category : #'building-rendering' }
FormSGRenderingTransformationTest >> renderNodes: nodes withScale: aScale [
	
	| surface renderer clipping |
	clipping := { (0@0 corner: morphExtent) scaleBy: aScale }.

	renderer := FormSGNewAthensRenderer new.
	renderer clippingRectangles: clipping.

	surface := FormSGAthensSurface extent: (morphExtent * aScale).

	surface drawDuring: [ :aCanvas |
		surface clear: Color transparent.
		renderer render: nodes on: aCanvas ].
	
	^ surface

]

{ #category : #tests }
FormSGRenderingTransformationTest >> testIdentityTransformOnRectangle [

	| surface container |
	container := self newContainerMorph.
	[ 
		container addMorph: self transformationMorph.
		surface := self renderMorph: container withScale: 1.
		
		self assert: surface asForm extent equals: container asForm extent.
		self assert: surface asForm closeTo: container asForm.
			
	] ensure: [ container delete ]
]

{ #category : #tests }
FormSGRenderingTransformationTest >> testRotateAndScaleRectangle [

	| surface container transformation |
	container := self newContainerMorph.
	[ 
		transformation := self transformationMorph.
		transformation angle: -45.
		transformation scale: 2.
		container addMorph: transformation.

		surface := self renderMorph: container withScale: 1.

		self assert: surface asForm extent equals: container asForm extent.
		self assert: surface asForm closeTo: container asForm ] 
	
	ensure: [ container delete ]
]

{ #category : #tests }
FormSGRenderingTransformationTest >> testRotateAndTranslateRectangle [

	| surface container transformation |
	container := self newContainerMorph.
	[ 
		transformation := self transformationMorph.
		transformation angle: 30.
		transformation position: 0@0.
		container addMorph: transformation.

		surface := self renderMorph: container withScale: 1.

		self assert: surface asForm extent equals: container asForm extent.
		self assert: surface asForm closeTo: container asForm ] 
	
	ensure: [ container delete ]
]

{ #category : #tests }
FormSGRenderingTransformationTest >> testRotateRectangle [

	| surface container transformation |
	container := self newContainerMorph.
	[ 
		transformation := self transformationMorph.
		transformation rotationDegrees: -45.
		container addMorph: transformation.

		surface := self renderMorph: container withScale: 1.
		
		self assert: surface asForm extent equals: container asForm extent.
		self assert: surface asForm closeTo: container asForm.
		
		 ] 
	ensure: [ container delete ]
]

{ #category : #tests }
FormSGRenderingTransformationTest >> testScaleRectangle [

	| surface container transformation |
	container := self newContainerMorph.
	[ 
		transformation := self transformationMorph.
		transformation scale: 3.
		container addMorph: transformation.
		surface := self renderMorph: container withScale: 1.

		self assert: surface asForm extent equals: container asForm extent.
		self assert: surface asForm closeTo: container asForm ] 
	
	ensure: [ container delete ]
]

{ #category : #tests }
FormSGRenderingTransformationTest >> testTranslateAndScaleRectangle [

	| surface container transformation |
	container := self newContainerMorph.
	[ 
		transformation := self transformationMorph position: 20@20.
		transformation scale: 2.

		container addMorph: transformation.

		surface := self renderMorph: container withScale: 1.
		
		self assert: surface asForm extent equals: container asForm extent.
		self assert: surface asForm closeTo: container asForm ] 
	
	ensure: [ container delete ]
]

{ #category : #tests }
FormSGRenderingTransformationTest >> testTranslateRectangle [

	| surface container transformation |
	container := self newContainerMorph.
	[ 
		transformation := self transformationMorph setOffset: -15@(-30) angle: 0 scale: 1.
		container addMorph: transformation.
		surface := self renderMorph: container withScale: 1.
		
		self assert: surface asForm extent equals: container asForm extent.
		self assert: surface asForm closeTo: container asForm ] 
	
	ensure: [ container delete ]
]

{ #category : #'building-rendering' }
FormSGRenderingTransformationTest >> transformationMorph [
	^ transformationMorph
]

{ #category : #'building-rendering' }
FormSGRenderingTransformationTest >> transformationMorph: aMorph [
	transformationMorph := aMorph
]
