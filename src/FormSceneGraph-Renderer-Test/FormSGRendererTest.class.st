Class {
	#name : #FormSGRendererTest,
	#superclass : #TestCase,
	#category : #'FormSceneGraph-Renderer-Test'
}

{ #category : #utils }
FormSGRendererTest >> grayProportionOf: aSurface [ 
	
	| aForm blackCount |
	aForm := aSurface asForm.
	
	blackCount := 0.
	
	0 to: aForm width - 1 do: [ :x |
		0 to: aForm height - 1 do: [ :y |
		(aForm colorAt: x@y) isGray 
			ifTrue: [ blackCount := blackCount + 1  ]
	]].
	
	^ blackCount / (aForm width * aForm height)
]

{ #category : #utils }
FormSGRendererTest >> renderMorph: aMorph withScale: aScale [
	
	| nodes clipping renderer surface builder |

	clipping := {aMorph bounds scaleBy: aScale}.

	renderer := FormSGNewAthensRenderer new.
	renderer clippingRectangles: clipping.

	surface := FormSGAthensSurface extent: (World extent * aScale).
	builder := FormSGBuilder new 
		scale: aScale; 
		clippingRectangles: clipping;
		yourself.

	nodes := aMorph buildFullSceneGraphWith: builder.

	surface drawDuring: [ :aCanvas |
		surface clear: Color white.
		renderer render: nodes on: aCanvas ].
	
	^ surface

]

{ #category : #tests }
FormSGRendererTest >> testCalypso [

	| surface window |
	[ 
		window := ClyFullBrowserMorph open owner.
		window position: 10@10.
		surface := self renderMorph: window withScale: 1.

	] ensure: [ window delete ].

	surface asForm inspect
]

{ #category : #tests }
FormSGRendererTest >> testCalypsoScaled [

	| surface window |
	[ 
		window := ClyFullBrowserMorph open owner.
		window position: 10@10.
		surface := self renderMorph: window withScale: 1.5.

	] ensure: [ window delete ].

	surface asForm inspect
]

{ #category : #tests }
FormSGRendererTest >> testLabelAtPosition1010 [

	| surface window |
	[ 
		window := 'aaaa' asStringMorph.
		window backgroundColor: Color blue.
		window position: 10@10.
		surface := self renderMorph: window withScale: 1.

	] ensure: [ window delete ].

	surface asForm inspect
]

{ #category : #tests }
FormSGRendererTest >> testRenderingButtonRendersCorrectly [

	| aMorph surface proportion originalProportion |
	aMorph := PluggableButtonMorph new 
						label: 'Ahhh';
						yourself.

	originalProportion := self grayProportionOf: aMorph asForm.	
	surface := self renderMorph: aMorph withScale: 1.
	proportion := self grayProportionOf: surface asForm.
	
	self assert: (proportion asFloat closeTo: originalProportion asFloat precision: 0.2)
]

{ #category : #tests }
FormSGRendererTest >> testRenderingTextInClippingAreaRenders [

	| textMorph surface proportion originalProportion |
	textMorph := (String loremIpsum: 10) asMorph.
	
	surface := self renderMorph: textMorph withScale: 1.
	
	originalProportion := self grayProportionOf: textMorph asForm.
	proportion := self grayProportionOf: surface.
	
	self assert: (proportion asFloat closeTo: originalProportion asFloat precision: 0.2)
]

{ #category : #tests }
FormSGRendererTest >> testRenderingTextScaledHasTheSameProportionOfNonScaled [

	| textMorph surface originalProportion scaledSurface scaledProportion scale string |

	string := String loremIpsum: 10.
	textMorph := string asMorph.
	textMorph backgroundColor: Color white.
	scale := 2.

	surface := self renderMorph: textMorph withScale: 1.
	originalProportion := self grayProportionOf: surface.

	scaledSurface := self renderMorph: textMorph withScale: scale.
	scaledProportion := self grayProportionOf: scaledSurface.

	self assert: scaledProportion asFloat closeTo: originalProportion asFloat precision: 0.2 
]
