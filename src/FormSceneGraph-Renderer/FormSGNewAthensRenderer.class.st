Class {
	#name : 'FormSGNewAthensRenderer',
	#superclass : 'Object',
	#instVars : [
		'canvas',
		'clippingRectangles',
		'textRenderer'
	],
	#category : 'FormSceneGraph-Renderer-Basic',
	#package : 'FormSceneGraph-Renderer',
	#tag : 'Basic'
}

{ #category : 'accessing' }
FormSGNewAthensRenderer >> clippingRectangles: aCollection [ 
	
	clippingRectangles := aCollection
]

{ #category : 'caching' }
FormSGNewAthensRenderer >> drawCachedSubScene: aCachedNode [

	| translated |

	translated := canvas pathTransform transformRectangle: aCachedNode currentBounds.

	canvas
		pasteSurface: aCachedNode cachedSurface
		targetX: translated origin x asFloat
		targetY: translated origin y asFloat
		sourceX: 0.0
		sourceY: 0.0
		width: translated width asFloat
		height: translated height asFloat
]

{ #category : 'cached scenes' }
FormSGNewAthensRenderer >> drawChildSubSceneAndCache: aCachedNode [

	| cachedSurface transformed |
	canvas
		clipBy: aCachedNode rectangle
		during: [ self visitNode: aCachedNode child ].
		
	aCachedNode child isNullNode ifTrue: [ ^ self ].	
		
	cachedSurface := AthensCairoSurface extent: aCachedNode rectangle extent.

	transformed := 	canvas pathTransform transformRectangle: aCachedNode rectangle.

	cachedSurface drawDuring: [ :aCanvas |	
		cachedSurface clear: Color transparent.
		aCanvas moveToX: 0.0 Y: 0.0. 
		aCanvas 
			pasteSurface: canvas surface 
			targetX: 0.0
			targetY: 0.0
			sourceX: transformed origin x asFloat
			sourceY: transformed origin y asFloat
			width: transformed width
			height: transformed height].
	
	aCachedNode 
		cachedSurface: cachedSurface;
		currentBounds: aCachedNode rectangle

]

{ #category : 'rendering' }
FormSGNewAthensRenderer >> render: aNode on: aCanvas [

	canvas := aCanvas.
	textRenderer := FormSGAthensTextRenderer new.
	
	"mergedRectangle := Rectangle merging: clippingRectangles.
	aNode accept: self."
	[
		canvas primSaveState.

		canvas newPath.
		clippingRectangles do: [ :aRect |
			canvas 
				rectangleX: aRect left
				y: aRect top
				width: aRect width
				height: aRect height].
		canvas primClip.

		aNode accept: self.
		
	] ensure: [ canvas primRestoreState ].
]

{ #category : 'visiting' }
FormSGNewAthensRenderer >> visitAthensNode: aFormSGAthensNode [

	| surface rectangle |
	surface := aFormSGAthensNode surface.
	rectangle := aFormSGAthensNode rectangle.
	surface extent = rectangle extent ifTrue: [ 
		canvas
			pasteSurface: surface
			targetX: rectangle origin x
			targetY: rectangle origin y
			sourceX: 0
			sourceY: 0
			width: rectangle width
			height: rectangle height.
		^ self ].
	
	surface := AthensCairoSurface extent: rectangle extent.
	aFormSGAthensNode drawBlock
		value: surface
		value: aFormSGAthensNode scale
		value: aFormSGAthensNode scale.
	canvas
		pasteSurface: surface
		targetX: rectangle origin x
		targetY: rectangle origin y
		sourceX: 0
		sourceY: 0
		width: rectangle width
		height: rectangle height
]

{ #category : 'visiting' }
FormSGNewAthensRenderer >> visitBorderNode: aBorderNode [ 

	aBorderNode color isTransparent 
		ifTrue: [ ^ self visitNode: aBorderNode content ].

	"We have a transparent content, so it is more difficult"
	aBorderNode content isNullNode ifTrue: [ 
		canvas setPaint: aBorderNode color.
		aBorderNode borderRectanglesDo: [ :each |
			canvas drawShape: each
		].
		^self ].
	
	"If the content is opaque, just draw border, and then the content on top."

	canvas
		setPaint: aBorderNode color;
		drawShape: aBorderNode rectangle.
		
	self visitNode: aBorderNode content
		
]

{ #category : 'visiting' }
FormSGNewAthensRenderer >> visitCachedSubScene: aCachedNode [ 


	aCachedNode isValid 
		ifTrue: [ self drawCachedSubScene: aCachedNode ]
		ifFalse: [ self drawChildSubSceneAndCache: aCachedNode ]

]

{ #category : 'visiting' }
FormSGNewAthensRenderer >> visitClipNode: aFormSGClipNode [

	canvas clipBy: aFormSGClipNode rectangle during: [ self visitNode: aFormSGClipNode child ]
]

{ #category : 'visiting' }
FormSGNewAthensRenderer >> visitColorRectangleNode: aColorRectangleNode [ 

	aColorRectangleNode color isTransparent ifTrue: [ ^ self ].
	
	canvas
		setPaint: aColorRectangleNode color;
		drawShape: aColorRectangleNode rectangle
	
]

{ #category : 'visiting' }
FormSGNewAthensRenderer >> visitContainerNode: aContainerNode [ 

	aContainerNode children do: [ :each | self visitNode: each ]
]

{ #category : 'visiting' }
FormSGNewAthensRenderer >> visitLinearGradientNode: node [
	| paint |
	
	(node startColor isTransparent and: [ node endColor isTransparent ]) ifTrue: [ ^ self ].
	
	paint := (LinearGradientPaint fromArray: {
		0 -> node startColor.
		1 -> node endColor.
		})
		start: node startPoint;
		stop: node endPoint;
		yourself.

	"canvas paintTransform loadIdentity."
.
	canvas
		setPaint: paint;
		drawShape: node rectangle
	
]

{ #category : 'visiting' }
FormSGNewAthensRenderer >> visitNode: aNode [ 

	aNode accept: self
]

{ #category : 'visiting' }
FormSGNewAthensRenderer >> visitNullNode: aFormSGNullNode [ 

	
]

{ #category : 'visiting' }
FormSGNewAthensRenderer >> visitRadialGradientNode: node [
	| paint maxRadius |
	(node startColor isTransparent and: [ node endColor isTransparent ]) ifTrue: [ ^ self ].
	
	maxRadius := node maxRadius asFloat.
	paint := (RadialGradientPaint fromArray: {
		node clipInnerRadius / maxRadius -> Color transparent.
		node innerRadius / maxRadius -> node startColor.
		node outerRadius / maxRadius -> node endColor.
		node clipOuterRadius / maxRadius -> Color transparent.
		})
		center: node center asFloatPoint;
		focalPoint: node focalPoint asFloatPoint;
		radius: maxRadius;
		yourself.

	"canvas paintTransform loadIdentity."
	canvas
		setPaint: paint;
		drawShape: node rectangle
	
]

{ #category : 'visiting' }
FormSGNewAthensRenderer >> visitTextNode: node [

	^ textRenderer renderTextNode: node on: canvas.
]

{ #category : 'visiting' }
FormSGNewAthensRenderer >> visitTextureNode: node [ 

	| rectangle extent originSurface scaledForm |

	rectangle := node rectangle.
	extent := rectangle extent.

	scaledForm := [node form scaledToSize: extent] on: Error do: [
		Stdio stdout nextPutAll: node asString ;crlf.
		node form].
	originSurface := (scaledForm asFormOfDepth: 32) asSurface.
	
	canvas setPathMatrix.
	
	canvas
		pasteSurface: originSurface
		targetX: rectangle origin x asFloat
		targetY: rectangle origin y asFloat
		sourceX: 0.0
		sourceY: 0.0
		width: extent x asFloat
		height: extent y asFloat
]

{ #category : 'visiting' }
FormSGNewAthensRenderer >> visitTransformNode: node [

	canvas pathTransform restoreAfter: [
		canvas pathTransform multiplyBy: node transform asAthensTransform.
		self visitNode: node child
	]
]
