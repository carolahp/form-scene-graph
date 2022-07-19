Class {
	#name : #FormSGRenderingTransformationTest,
	#superclass : #ParametrizedTestCase,
	#instVars : [
		'morphExtent',
		'morph',
		'transformationMorph',
		'containerMorph'
	],
	#category : #'FormSceneGraph-Renderer-Test'
}

{ #category : #'building suites' }
FormSGRenderingTransformationTest class >> testParameters [

	^ ParametrizedTestMatrix new 
		forSelector: #morph addOptions: { 
			  Morph new.
			  (Smalltalk ui icons iconNamed: #up) asMorph }
]

{ #category : #asserting }
FormSGRenderingTransformationTest >> assert: form1 closeTo: form2 [
	
	| diff greenProportion redProportion |
	
	diff := self diffBetween: form1 and: form2.
	greenProportion := self color: Color green proportionIn: diff.
	redProportion := self color: Color red proportionIn: diff.
	
	form1 inspect.
	((greenProportion asFloat > 0.02 ) or: [(redProportion asFloat > 0.02 )]) 
		ifTrue: [  form2 inspect. diff inspect ]. 
	
	self assert: (greenProportion asFloat < 0.02 ).
	self assert: (redProportion asFloat < 0.02 )
	
]

{ #category : #tests }
FormSGRenderingTransformationTest >> assertSurface: surface renders: aMorph [
	
	| morphForm surfaceForm |
	surfaceForm := surface asForm.
	morphForm := aMorph asForm scaledIntoFormOfSize: surfaceForm extent.
	self assert: surfaceForm extent equals: morphForm extent.
	self assert: surfaceForm closeTo: morphForm
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
		0 to: aForm height - 1 do: [ :y |. 
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
	| diff |
	diff := reference deepCopy.
	0 to: reference extent x do: [ :x | 
		0 to: reference extent y do: [ :y | 
			((form colorAt: x @ y) diff: (reference colorAt: x @ y)) < 0.2 
				ifFalse: [ 
					((form colorAt: x @ y) isTransparent not and: [ 
						 (reference colorAt: x @ y) isTransparent ]) ifTrue: [ 
						diff colorAt: x @ y put: Color red ].
					((form colorAt: x @ y) isTransparent and: [ 
						 (reference colorAt: x @ y) isTransparent not ]) ifTrue: [ 
						diff colorAt: x @ y put: Color green ] ] ] ].
	^ diff
]

{ #category : #asserting }
FormSGRenderingTransformationTest >> morph [
	^ morph 
]

{ #category : #asserting }
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
FormSGRenderingTransformationTest >> newTransformationMorph [

	^ TransformationMorph new
		  position: 20 @ 20;
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

{ #category : #running }
FormSGRenderingTransformationTest >> setUp [ 	
	super setUp.
	containerMorph := self newContainerMorph.
	transformationMorph := self newTransformationMorph.
	containerMorph addMorph: transformationMorph.
	
]

{ #category : #running }
FormSGRenderingTransformationTest >> tearDown [
	
	containerMorph delete.
	transformationMorph delete.
	morph delete.
	super tearDown
]

{ #category : #tests }
FormSGRenderingTransformationTest >> testIdentityTransform [

	| surface |
	transformationMorph addMorph: morph.
	
	surface := self renderMorph: containerMorph withScale: self worldScale.

	self assertSurface: surface renders: containerMorph
]

{ #category : #tests }
FormSGRenderingTransformationTest >> testRotate [

	| surface |
	transformationMorph asFlexOf: morph.
	transformationMorph rotationDegrees: -45.
	
	surface := self renderMorph: containerMorph withScale: self worldScale.
	
	self assertSurface: surface renders: containerMorph
]

{ #category : #tests }
FormSGRenderingTransformationTest >> testRotateAndScale [

	| surface |
	transformationMorph asFlexOf: morph.
	transformationMorph rotationDegrees: -45.
	transformationMorph scale: 2.
	
	surface := self renderMorph: containerMorph withScale: self worldScale.
	
	self assertSurface: surface renders: containerMorph
]

{ #category : #tests }
FormSGRenderingTransformationTest >> testRotateAndTranslate [

	| surface |
	transformationMorph asFlexOf: morph.
	transformationMorph rotationDegrees: -45.
	transformationMorph position: 30@30.
	
	surface := self renderMorph: containerMorph withScale: self worldScale.
	
	self assertSurface: surface renders: containerMorph
]

{ #category : #tests }
FormSGRenderingTransformationTest >> testScale [

	| surface |
	transformationMorph addMorph: morph.
	transformationMorph scale: 2.
	
	surface := self renderMorph: containerMorph withScale: self worldScale.
	
	self assertSurface: surface renders: containerMorph
]

{ #category : #tests }
FormSGRenderingTransformationTest >> testTranslate [

	| surface |
	transformationMorph addMorph: morph.
	transformationMorph position: 30@30.
	
	surface := self renderMorph: containerMorph withScale: self worldScale.
	
	self assertSurface: surface renders: containerMorph
]

{ #category : #tests }
FormSGRenderingTransformationTest >> testTranslateAndScale [

	| surface |
	transformationMorph addMorph: morph.
	transformationMorph scale: 3.
	transformationMorph position: 30@30.
	
	surface := self renderMorph: containerMorph withScale: self worldScale.
	
	self assertSurface: surface renders: containerMorph
]

{ #category : #'building-rendering' }
FormSGRenderingTransformationTest >> transformationMorph [

	^ transformationMorph ifNil: [ 
		  transformationMorph := TransformationMorph new
			                         position: 20 @ 20;
			                         yourself ]
]

{ #category : #'building-rendering' }
FormSGRenderingTransformationTest >> transformationMorph: aMorph [
	transformationMorph := aMorph
]

{ #category : #accessing }
FormSGRenderingTransformationTest >> worldScale [
	^ 1
]
