Class {
	#name : #FormSGNewAthensRenderer,
	#superclass : #Object,
	#instVars : [
		'canvas'
	],
	#category : #'FormSceneGraph-Renderer-Basic'
}

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
FormSGNewAthensRenderer >> visitTextNode: aFormSGTextNode [ 

	
]

{ #category : #visiting }
FormSGNewAthensRenderer >> visitTextureNode: aFormSGTextureNode [ 

	
]
