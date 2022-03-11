"
I encapsulate a subscene that should always be drawn for performance reasons into a separate ofscreen buffer. This caching requirement is only for performance reasons. My content can always be drawn by directly traversing my child node.

I also hold a modification count, and handles into renderer specific texture/surfaces/render target for actually caching my drawn pixels. 
"
Class {
	#name : #FormSGCachingSubSceneNode,
	#superclass : #FormSGNode,
	#instVars : [
		'child',
		'cachedSurface'
	],
	#category : #'FormSceneGraph-Core-Nodes'
}

{ #category : #visiting }
FormSGCachingSubSceneNode >> accept: visitor [

	^ visitor visitCachedSubScene: self
]

{ #category : #'accessing - bounds' }
FormSGCachingSubSceneNode >> boundingBox [
	
	^ child boundingBox 
]

{ #category : #accessing }
FormSGCachingSubSceneNode >> cachedSurface [
	^ cachedSurface
]

{ #category : #accessing }
FormSGCachingSubSceneNode >> cachedSurface: anAthensCairoSurface [ 
	cachedSurface := anAthensCairoSurface
]

{ #category : #accessing }
FormSGCachingSubSceneNode >> child [

	^ child
]

{ #category : #accessing }
FormSGCachingSubSceneNode >> child: aChild [

	child := aChild
]

{ #category : #accessing }
FormSGCachingSubSceneNode >> children [
	^ { child }
]

{ #category : #accessing }
FormSGCachingSubSceneNode >> extent: anExtent [

	
]

{ #category : #initialization }
FormSGCachingSubSceneNode >> initialize [

	super initialize.

	child := FormSGNullNode uniqueInstance
]

{ #category : #testing }
FormSGCachingSubSceneNode >> isCachingSubSceneNode [
	^ true
]

{ #category : #caching }
FormSGCachingSubSceneNode >> isValid [
	
	^ cachedSurface isNotNil and: [ cachedSurface isValidSession ]
]

{ #category : #accessing }
FormSGCachingSubSceneNode >> rectangle [
	
	^ child boundingBox
]
