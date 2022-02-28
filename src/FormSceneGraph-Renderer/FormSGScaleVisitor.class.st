Class {
	#name : #FormSGScaleVisitor,
	#superclass : #Object,
	#instVars : [
		'scaleFactor'
	],
	#category : #'FormSceneGraph-Renderer'
}

{ #category : #accessing }
FormSGScaleVisitor >> scaleFactor: aNumber [ 
	
	scaleFactor := aNumber
]

{ #category : #visiting }
FormSGScaleVisitor >> visitColorRectangleNode: aFormSGColorRectangleNode [ 
	
	^ aFormSGColorRectangleNode copy
		rectangle: (aFormSGColorRectangleNode rectangle scaleBy: scaleFactor);
		yourself 
	
]
