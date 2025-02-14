"
I am a node modifies a specific attribute of a child. I can always be composed in order to further increase my effect.
"
Class {
	#name : #FormSGChildAttributeNode,
	#superclass : #FormSGNode,
	#instVars : [
		'child'
	],
	#category : #'FormSceneGraph-Core-Nodes'
}

{ #category : #testing }
FormSGChildAttributeNode class >> isAbstract [
	^ self == FormSGChildAttributeNode
]

{ #category : #'accessing - bounds' }
FormSGChildAttributeNode >> boundingBox [
	^ child boundingBox
]

{ #category : #accessing }
FormSGChildAttributeNode >> child [
	^ child
]

{ #category : #accessing }
FormSGChildAttributeNode >> child: anObject [
	child := anObject
]

{ #category : #accessing }
FormSGChildAttributeNode >> children [
	^ { child }
]

{ #category : #accessing }
FormSGChildAttributeNode >> childrenDo: aBlock [
	aBlock value: child
]

{ #category : #testing }
FormSGChildAttributeNode >> isChildAttributeNode [
	^ true
]

{ #category : #operation }
FormSGChildAttributeNode >> offsetPositionBy: aPoint [ 

	child offsetPositionBy: aPoint 
]

{ #category : #initialization }
FormSGChildAttributeNode >> resetCaches [

	child resetCaches
]
