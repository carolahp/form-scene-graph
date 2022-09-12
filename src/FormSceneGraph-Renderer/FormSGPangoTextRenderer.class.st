"
I am a strategy that uses Pango to perform the rendering taking advantage of all its features.
Requires Pango installed.
"
Class {
	#name : #FormSGPangoTextRenderer,
	#superclass : #Object,
	#instVars : [
		'textBuffer',
		'pangoLayout'
	],
	#category : #'FormSceneGraph-Renderer-Text'
}

{ #category : #private }
FormSGPangoTextRenderer >> encodeStringForLayout: aString from: firstIndex length: length [

	"I encode in utf8 the string in a pinned byteArray that is reused"
	
	"Check the worst case scenario 4 bytes per character"
	
	(textBuffer isNil or: [ textBuffer size < (length * 4) ]) 
		ifTrue: [ textBuffer := ByteArray newPinned: length * 4 ].	
	
	textBuffer writeStreamDo: [ :aStream | 
		ZnCharacterEncoder utf8 next: length putAll: aString startingAt: firstIndex toStream: aStream.
		aStream nextPut: 0].
	
	^ textBuffer
]

{ #category : #private }
FormSGPangoTextRenderer >> pangoLayoutFor: canvas [

	^ pangoLayout ifNil: [ 
		pangoLayout := (PangoLayout newCanvas: canvas)
			autoRelease;
			yourself ]

]

{ #category : #rendering }
FormSGPangoTextRenderer >> renderTextNode: aTextNode on: canvas [

	| stringLength layout |

	aTextNode color loadOnCairoCanvas: canvas.
	canvas moveToX: aTextNode rectangle origin x Y: aTextNode rectangle origin y.

	layout := self pangoLayoutFor: canvas.

	layout fontDescription: aTextNode fontDescription.

	stringLength := aTextNode lastIndex - aTextNode firstIndex + 1.

	layout text: (self encodeStringForLayout: aTextNode string from: aTextNode firstIndex length: stringLength) length: -1.

	canvas updateLayout: layout.
		
	canvas showLayout: layout.
]
