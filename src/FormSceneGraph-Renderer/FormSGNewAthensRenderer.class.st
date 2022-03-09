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
FormSGNewAthensRenderer >> visitCachedSubScene: aFormSGCachingSubSceneNode [ 

	self visitNode: aFormSGCachingSubSceneNode child.
	1halt.
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
FormSGNewAthensRenderer >> visitTextureNode: aFormSGTextureNode [ 

	canvas setPaint: Color lightYellow.
	canvas drawShape: aFormSGTextureNode rectangle.

]
