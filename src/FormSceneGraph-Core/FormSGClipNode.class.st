"
I clip the content of my child into my bounding rectangle.
"
Class {
	#name : #FormSGClipNode,
	#superclass : #FormSGNode,
	#instVars : [
		'child',
		'rectangle'
	],
	#category : #'FormSceneGraph-Core-Nodes'
}

{ #category : #visiting }
FormSGClipNode >> accept: visitor [
	^ visitor visitClipNode: self
]

{ #category : #'accessing - bounds' }
FormSGClipNode >> boundingBox [
	rectangle isEmpty ifTrue: [ ^ rectangle ].
	^ rectangle intersect: child boundingBox ifNone: [ Rectangle empty]
]

{ #category : #accessing }
FormSGClipNode >> child [
	^ child
]

{ #category : #accessing }
FormSGClipNode >> child: anObject [
	child := anObject
]

{ #category : #accessing }
FormSGClipNode >> children [
	^ { child }
]

{ #category : #accessing }
FormSGClipNode >> childrenDo: aBlock [
	aBlock value: child
]

{ #category : #testing }
FormSGClipNode >> isClipNode [
	^ true
]

{ #category : #operation }
FormSGClipNode >> offsetPositionBy: offset [ 
	
	rectangle := rectangle translateBy: offset.
	child offsetPositionBy: offset
]

{ #category : #printing }
FormSGClipNode >> printOn: aStream [

	super printOn: aStream.
	aStream nextPutAll: ' rectangle: '; print: rectangle
]

{ #category : #accessing }
FormSGClipNode >> rectangle [
	^ rectangle
]

{ #category : #accessing }
FormSGClipNode >> rectangle: anObject [
	rectangle := anObject
]

{ #category : #caches }
FormSGClipNode >> resetCaches [

	child resetCaches
]
