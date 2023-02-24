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
		self deny: (window valueOfProperty: #cachedSubSceneGraph) equals: cache.
		
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

{ #category : #tests }
FormSGSubMorphsCacheAndInvalidationTest >> testSystemWindowSurfaceIsCached [
	| window builder cache nodes clipping renderer surface morphBounds aScale |
	builder := FormSGBuilder new.
	aScale := 1.5.	
	[ 
		window := ClyFullBrowserMorph open owner.
		morphBounds := window bounds.

		clipping := { morphBounds scaleBy: aScale}.

		renderer := FormSGNewAthensRenderer new.
		renderer clippingRectangles: clipping.

		surface := FormSGAthensSurface extent: (morphBounds bottomRight * aScale).
		builder := FormSGBuilder new 
			scale: aScale; 
			clippingRectangles: clipping;
			yourself.

		self assert: window shouldCacheSceneGraphSurface.

		self assert: (window valueOfProperty: #invalidSceneGraph).
		self assert: (window valueOfProperty: #cachedSubSceneGraph) equals: nil.
		
		nodes := window buildFullSceneGraphWith: builder.
		surface drawDuring: [ :aCanvas |
			surface clear: Color transparent.
			renderer render: nodes on: aCanvas ].

		(window valueOfProperty: #cachedSubSceneGraph).
		
		self deny: (window valueOfProperty: #invalidSceneGraph).
		cache := window valueOfProperty: #cachedSubSceneGraph.
		self assert: cache isCachingSubSceneNode. 
		self deny: cache cachedSurface equals: nil.
		
		window buildFullSceneGraphWith: builder.
		surface drawDuring: [ :aCanvas |
			surface clear: Color transparent.
			renderer render: nodes on: aCanvas ].

		self deny: (window valueOfProperty: #invalidSceneGraph).
		self assert: (window valueOfProperty: #cachedSubSceneGraph) equals: cache.

		surface asForm inspect.
		cache cachedSurface asForm inspect.

		] ensure: [ window delete ]
]
