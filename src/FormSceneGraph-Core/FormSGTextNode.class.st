"
I am a node that draws a string of text with a specified color, font.
"
Class {
	#name : #FormSGTextNode,
	#superclass : #FormSGRectangleNode,
	#instVars : [
		'string',
		'firstIndex',
		'lastIndex',
		'font',
		'color',
		'kern',
		'underline',
		'underlineColor',
		'strikethrough',
		'strikethroughColor',
		'fontDescription',
		'scale'
	],
	#category : #'FormSceneGraph-Core-Nodes'
}

{ #category : #visiting }
FormSGTextNode >> accept: visitor [
	^ visitor visitTextNode: self
]

{ #category : #accessing }
FormSGTextNode >> color [
	^ color
]

{ #category : #accessing }
FormSGTextNode >> color: anObject [
	color := anObject
]

{ #category : #accessing }
FormSGTextNode >> firstIndex [
	^ firstIndex
]

{ #category : #accessing }
FormSGTextNode >> firstIndex: anObject [
	firstIndex := anObject
]

{ #category : #accessing }
FormSGTextNode >> font [
	^ font
]

{ #category : #accessing }
FormSGTextNode >> font: anObject [
	font := anObject
]

{ #category : #accessing }
FormSGTextNode >> fontDescription [ 

	(fontDescription isNotNil and: [fontDescription isValid]) 
		ifTrue: [ ^ fontDescription ].

	fontDescription := PangoFontDescription new.
	fontDescription autoRelease.
	
	fontDescription familyName: self font familyName.
	fontDescription fontSize: (self font pointSize * 1024 * scale) asInteger .
	fontDescription stretch: (PangoStretch at: #PANGO_STRETCH_NORMAL).
	fontDescription weight: (PangoStyle at: #PANGO_WEIGHT_NORMAL).

	^ fontDescription
]

{ #category : #testing }
FormSGTextNode >> isTextNode [
	^ true
]

{ #category : #accessing }
FormSGTextNode >> kern [
	^ kern
]

{ #category : #accessing }
FormSGTextNode >> kern: anObject [
	kern := anObject
]

{ #category : #accessing }
FormSGTextNode >> lastIndex [
	^ lastIndex
]

{ #category : #accessing }
FormSGTextNode >> lastIndex: anObject [
	lastIndex := anObject
]

{ #category : #printing }
FormSGTextNode >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: '; string: '; nextPutAll: (string printStringLimitedTo: 50);
		nextPutAll: '; color: '; print: color;
		nextPutAll: '; font: '; print: font;
		nextPutAll: '; firstIndex: '; print: firstIndex;
		nextPutAll: '; lastIndex: '; print: lastIndex;
		nextPutAll: '; kern: '; print: kern;
		nextPutAll: '; underline: '; print: underline;
		nextPutAll: '; underlineColor: '; print: underlineColor;
		nextPutAll: '; strikethrough: '; print: strikethrough;
		nextPutAll: '; strikethroughColor: '; print: strikethroughColor

]

{ #category : #accessing }
FormSGTextNode >> scale [
	^ scale
]

{ #category : #accessing }
FormSGTextNode >> scale: aNumber [ 
	
	scale := aNumber
]

{ #category : #accessing }
FormSGTextNode >> strikethrough [
	^ strikethrough
]

{ #category : #accessing }
FormSGTextNode >> strikethrough: anObject [
	strikethrough := anObject
]

{ #category : #accessing }
FormSGTextNode >> strikethroughColor [
	^ strikethroughColor
]

{ #category : #accessing }
FormSGTextNode >> strikethroughColor: anObject [
	strikethroughColor := anObject
]

{ #category : #accessing }
FormSGTextNode >> string [
	^ string
]

{ #category : #accessing }
FormSGTextNode >> string: anObject [
	string := anObject
]

{ #category : #accessing }
FormSGTextNode >> underline [
	^ underline
]

{ #category : #accessing }
FormSGTextNode >> underline: anObject [
	underline := anObject
]

{ #category : #accessing }
FormSGTextNode >> underlineColor [
	^ underlineColor
]

{ #category : #accessing }
FormSGTextNode >> underlineColor: anObject [
	underlineColor := anObject
]
