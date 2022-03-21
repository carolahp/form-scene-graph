Class {
	#name : #FormSGSubMorphsCacheAndInvalidationTest,
	#superclass : #TestCase,
	#category : #'FormSceneGraph-Renderer-Test'
}

{ #category : #tests }
FormSGSubMorphsCacheAndInvalidationTest >> testInvalidateSceneGraphInSystemWindow [
	| window builder cache |
	builder := FormSGBuilder new.
		
	[ 
		window := ClyFullBrowserMorph open owner.
		window buildFullSceneGraphWith: builder.
		self deny: (window valueOfProperty: #invalidSceneGraph).
		cache := window valueOfProperty: #cachedSubSceneGraph.
		self assert: cache isCachingSubSceneNode.
		window invalidateSceneGraph .
		self deny: (window valueOfProperty: #invalidSceneGraph) equals: cache.
		
	] ensure: [ window delete ]
]

{ #category : #tests }
FormSGSubMorphsCacheAndInvalidationTest >> testSystemWindowIsCached [
	| window builder cache |
	builder := FormSGBuilder new.
		
	[ 
		window := ClyFullBrowserMorph open owner.
		self assert: window shouldCacheSceneGraphSurface.

		self assert: (window valueOfProperty: #invalidSceneGraph).
		self assert: (window valueOfProperty: #cachedSubSceneGraph) equals: nil.
	
		window buildFullSceneGraphWith: builder.
		self deny: (window valueOfProperty: #invalidSceneGraph).
		cache := window valueOfProperty: #cachedSubSceneGraph.
		self assert: cache isCachingSubSceneNode. 

		window buildFullSceneGraphWith: builder.
		self deny: (window valueOfProperty: #invalidSceneGraph).
		self assert: (window valueOfProperty: #cachedSubSceneGraph) equals: cache.
	] ensure: [ window delete ]
]
