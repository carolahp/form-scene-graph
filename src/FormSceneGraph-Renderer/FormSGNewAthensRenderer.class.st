Class {
	#name : #FormSGNewAthensRenderer,
	#superclass : #Object,
	#instVars : [
		'canvas',
		'textBuffer',
		'pangoLayout'
	],
	#category : #'FormSceneGraph-Renderer-Basic'
}

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
		ZnCharacterEncoder utf8 next: length putAll: aString startingAt: firstIndex toStream: aStream].
	
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
	aNode accept: self
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
FormSGNewAthensRenderer >> visitNode: aNode [ 
	
	^ aNode accept: self
]

{ #category : #visiting }
FormSGNewAthensRenderer >> visitNullNode: aFormSGNullNode [ 

	
]

{ #category : #visiting }
FormSGNewAthensRenderer >> visitTextNode: aTextNode [ 

	| stringLength |

	aTextNode strikethrough 
		ifTrue: [ self halt ].
		
	aTextNode color loadOnCairoCanvas: canvas.
	canvas moveToX: aTextNode rectangle origin x Y: aTextNode rectangle origin y.

	self pangoLayout fontDescription: aTextNode fontDescription.

	stringLength := aTextNode lastIndex - aTextNode firstIndex + 1.

	self pangoLayout text: (self encodeStringForLayout: aTextNode string from: aTextNode firstIndex length: stringLength) length: stringLength.

	canvas updateLayout: self pangoLayout.
		
	canvas showLayout: self pangoLayout.

]

{ #category : #visiting }
FormSGNewAthensRenderer >> visitTextureNode: node [ 

	| rectangle extent paint sourceRectangle sourceExtent |
	rectangle := node rectangle.
	extent := rectangle extent.
		
	paint := node form asAthensPaintOn: canvas.
	sourceRectangle := node validSourceRectangle.
	sourceExtent := sourceRectangle extent.
	(sourceExtent x <= 0.0 or: [ sourceExtent y <= 0.0 ]) ifTrue: [ ^ self ].
	
	canvas pathTransform restoreAfter: [
		canvas paintTransform
			loadIdentity.
		node isRepeated ifTrue: [
			paint repeat
		] ifFalse: [
			paint noRepeat.
			canvas paintTransform
				scaleBy: extent / sourceExtent.
			canvas paintTransform
					translateBy: sourceRectangle origin.					
		].

		canvas setPaint: paint.
		canvas pathTransform translateBy: node rectangle origin.
		canvas drawShape: (0@0 extent: node rectangle extent).				

	].

]
