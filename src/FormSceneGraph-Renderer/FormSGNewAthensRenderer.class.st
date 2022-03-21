Class {
	#name : #FormSGNewAthensRenderer,
	#superclass : #Object,
	#instVars : [
		'canvas',
		'textBuffer',
		'pangoLayout',
		'clippingRectangles',
		'mergedRectangle'
	],
	#category : #'FormSceneGraph-Renderer-Basic'
}

{ #category : #accessing }
FormSGNewAthensRenderer >> clippingRectangles: aCollection [ 
	
	clippingRectangles := aCollection
]

{ #category : #caching }
FormSGNewAthensRenderer >> drawCachedSubScene: aCachedNode [

	canvas
		pasteSurface: aCachedNode cachedSurface
		targetX: aCachedNode rectangle origin x asFloat
		targetY: aCachedNode rectangle origin y asFloat
		sourceX: 0.0
		sourceY: 0.0
		width: aCachedNode rectangle width asFloat
		height: aCachedNode rectangle height asFloat
]

{ #category : #'cached scenes' }
FormSGNewAthensRenderer >> drawChildSubSceneAndCache: aCachedNode [

	| cachedSurface |
	canvas
		clipBy: aCachedNode rectangle
		during: [ self visitNode: aCachedNode child ].
		
	aCachedNode child isNullNode ifTrue: [ ^ self ].	
		
	cachedSurface := AthensCairoSurface extent: aCachedNode rectangle extent.

	cachedSurface drawDuring: [ :aCanvas |	
		cachedSurface clear: Color transparent.
		aCanvas moveToX: 0.0 Y: 0.0. 
		aCanvas 
			pasteSurface: canvas surface 
			targetX: 0.0
			targetY: 0.0
			sourceX: aCachedNode rectangle origin x asFloat
			sourceY: aCachedNode rectangle origin y asFloat
			width: aCachedNode rectangle width
			height: aCachedNode rectangle height].
	
	aCachedNode cachedSurface: cachedSurface
]

{ #category : #'as yet unclassified' }
FormSGNewAthensRenderer >> encodeStringForLayout: aString from: firstIndex length: length [

	"I encode in utf8 the string in a pinned byteArray that is reused"
	
	"Check the worst case scenario 4 bytes per character"
	
	(textBuffer isNil or: [ textBuffer size < (length * 4) ]) 
		ifTrue: [ textBuffer := ByteArray newPinned: length * 4 ].	
	
	textBuffer writeStreamDo: [ :aStream | 
		ZnCharacterEncoder utf8 next: length putAll: aString startingAt: firstIndex toStream: aStream.
		aStream nextPut: 0].
	
	^ textBuffer
]

{ #category : #'as yet unclassified' }
FormSGNewAthensRenderer >> pangoLayout [

	^ pangoLayout ifNil: [ 
		pangoLayout := (PangoLayout newCanvas: canvas)
			autoRelease;
			yourself ]

]

{ #category : #rendering }
FormSGNewAthensRenderer >> render: aNode on: aCanvas [

	canvas := aCanvas.

	mergedRectangle := Rectangle merging: clippingRectangles.

	"canvas 
		clipBy: mergedRectangle
		during: [" aNode accept: self "]"
	
]

{ #category : #visiting }
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

{ #category : #visiting }
FormSGNewAthensRenderer >> visitCachedSubScene: aCachedNode [ 


	aCachedNode isValid 
		ifTrue: [ self drawCachedSubScene: aCachedNode ]
		ifFalse: [ self drawChildSubSceneAndCache: aCachedNode ]

]

{ #category : #visiting }
FormSGNewAthensRenderer >> visitClipNode: aFormSGClipNode [

	canvas clipBy: aFormSGClipNode rectangle during: [ self visitNode: aFormSGClipNode child ]
]

{ #category : #visiting }
FormSGNewAthensRenderer >> visitColorRectangleNode: aColorRectangleNode [ 

	aColorRectangleNode color isTransparent ifTrue: [ ^ self ].
	
	canvas
		setPaint: aColorRectangleNode color;
		drawShape: aColorRectangleNode rectangle
	
]

{ #category : #visiting }
FormSGNewAthensRenderer >> visitContainerNode: aContainerNode [ 

	aContainerNode children do: [ :each | self visitNode: each ]
]

{ #category : #visiting }
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

	canvas paintTransform loadIdentity.
	canvas
		setPaint: paint;
		drawShape: node rectangle
	
]

{ #category : #visiting }
FormSGNewAthensRenderer >> visitNode: aNode [ 

	aNode accept: self
]

{ #category : #visiting }
FormSGNewAthensRenderer >> visitNullNode: aFormSGNullNode [ 

	
]

{ #category : #visiting }
FormSGNewAthensRenderer >> visitTextNode: aTextNode [ 

	| stringLength |

	aTextNode color loadOnCairoCanvas: canvas.
	canvas moveToX: aTextNode rectangle origin x Y: aTextNode rectangle origin y.

	self pangoLayout fontDescription: aTextNode fontDescription.

	stringLength := aTextNode lastIndex - aTextNode firstIndex + 1.

	self pangoLayout text: (self encodeStringForLayout: aTextNode string from: aTextNode firstIndex length: stringLength) length: -1.

	canvas updateLayout: self pangoLayout.
		
	canvas showLayout: self pangoLayout.

]

{ #category : #visiting }
FormSGNewAthensRenderer >> visitTextureNode: node [ 

	| rectangle extent originSurface originalExtent ourScale |

	rectangle := node rectangle.
	extent := rectangle extent.
	
	originSurface := canvas surface class fromForm: (node form asFormOfDepth: 32).

	originalExtent := node form extent. 
	ourScale := (extent / originalExtent) x asFloat.

	canvas primScaleX: ourScale Y: ourScale.

	canvas
		pasteSurface: originSurface
		targetX: rectangle origin x asFloat / ourScale
		targetY: rectangle origin y asFloat / ourScale
		sourceX: 0.0
		sourceY: 0.0
		width: originalExtent x asFloat
		height: originalExtent y asFloat.
		
	canvas primScaleX: 1 / ourScale  Y: 1 / ourScale 
]
