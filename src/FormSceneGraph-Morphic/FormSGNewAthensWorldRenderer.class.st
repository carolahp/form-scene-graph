Class {
	#name : #FormSGNewAthensWorldRenderer,
	#superclass : #FormSGAbstractWorldRenderer,
	#instVars : [
		'renderer',
		'worldSurface',
		'handSurface'
	],
	#category : #'FormSceneGraph-Morphic-WorldRenderer'
}

{ #category : #operations }
FormSGNewAthensWorldRenderer >> buildSceneGraphForHandsofWorld: aWorld [
	
	| builder rootNodes handsToRender damagedAreas bounds previous |
	builder := FormSGBuilder new
					scale: self scaleFactor asFloat;
					yourself.
	
	damagedAreas := OrderedCollection new.
	handsToRender := OrderedCollection new.
	
	aWorld hands do: [ :h | 
		h submorphs isEmpty 
			ifTrue: [ h removeProperty: #previousFullBounds ]
			ifFalse: [ handsToRender add: h ] ].
	
	rootNodes := handsToRender collect: [ :aMorph | |node|
			node := aMorph buildFullSceneGraphWith: builder.
			builder resetAfterRoot.
			
			bounds := handsToRender collect: [:m | m fullBounds].	
			previous := aMorph valueOfProperty: #previousFullBounds ifAbsent: [ 0@0 corner: 0@0 ].
			
			damagedAreas add: previous.
			damagedAreas add: bounds.
			
			aMorph setProperty: #previousFullBounds toValue: bounds.
			
			node ].
	
	^ {builder containerWith: rootNodes reverse. damagedAreas }
]

{ #category : #operations }
FormSGNewAthensWorldRenderer >> buildSceneGraphForWorldState: aWorldState ofWorld: aWorld [
	
	self halt
]

{ #category : #operations }
FormSGNewAthensWorldRenderer >> buildSceneGraphForWorldState: aWorldState ofWorld: aWorld damagedRectangles: damagedRectangles [
	
	| builder rootNodes morphsToRender |
	builder := FormSGBuilder new
					scale: self scaleFactor asFloat;
					yourself.
	
	morphsToRender := (FormSGMorphOclusionAndClippingFilter new
			filterMorphs: aWorld submorphs inVisibleRectangles: damagedRectangles).
	
	rootNodes := morphsToRender collect: [ :aMorph | |node|
			node := aMorph buildFullSceneGraphWith: builder.
			builder resetAfterRoot.
			node ].

	builder resetAfterRoot.
	rootNodes add: (aWorld buildSceneGraphNodeWith: builder).
	
	builder drawnAreas size traceCr.
	
	"The graph renderer draws things from the first to the last, we need to put the closer to the user at the end (Morphic does it in the other direction)"
	^ builder containerWith: rootNodes reverse
]

{ #category : #operations }
FormSGNewAthensWorldRenderer >> displayWorldRectangles: damageRectangles handRectangles: handRectangles [

	| windowRenderer |

	windowRenderer := self osWindowRenderer.

	windowRenderer drawDuring: [ :aCanvas |
		aCanvas pasteSurface: self worldSurface 
				targetX: 0 
				targetY: 0 
				sourceX: 0
				sourceY: 0 
				width: self worldSurface extent x 
				height: self worldSurface extent y.

		aCanvas pasteSurface: self handSurface 
				targetX: 0 
				targetY: 0 
				sourceX: 0
				sourceY: 0 
				width: self handSurface extent x 
				height: self handSurface extent y.
		].

	windowRenderer updateAll.

	windowRenderer present
]

{ #category : #private }
FormSGNewAthensWorldRenderer >> doActivate [ 

	super doActivate.
	World allMorphsDo: [ :m | m invalidateSceneGraph ].
]

{ #category : #operations }
FormSGNewAthensWorldRenderer >> doDisplayWorldState: aWorldState ofWorld: aWorld [

	| newSceneGraph damageRectangles handGraph handGraphRectanglePair handRectangles |
	damageRectangles := self
		                    extractMergedDamageRectangleFromWorldState:
		                    aWorldState
		                    ofWorld: aWorld.
	damageRectangles isEmpty ifTrue: [ ^ self ].

	handGraphRectanglePair := self buildSceneGraphForHandsofWorld: aWorld.
	handGraph := handGraphRectanglePair first.
	handRectangles := handGraphRectanglePair second flattened.

	self handSurface drawDuring: [ :aCanvas | 
		self handSurface clear: Color transparent ].

	handRectangles ifNotEmpty: [ 
		renderer clippingRectangles:
			(handRectangles collect: [ :rect | rect scaleBy: self scaleFactor ]).

		self handSurface drawDuring: [ :aCanvas | 
			renderer render: handGraph on: aCanvas ] ].


	newSceneGraph := self
		                 buildSceneGraphForWorldState: aWorldState
		                 ofWorld: aWorld
		                 damagedRectangles: damageRectangles.

	renderer clippingRectangles: (damageRectangles collect: [ :rect | rect scaleBy: self scaleFactor ]).

	self worldSurface drawDuring: [ :aCanvas | 
		renderer render: newSceneGraph on: aCanvas ].

	self
		displayWorldRectangles:
		(damageRectangles collect: [ :e | e scaleBy: self scaleFactor ])
		handRectangles:
		(handRectangles collect: [ :e | e scaleBy: self scaleFactor ])
]

{ #category : #private }
FormSGNewAthensWorldRenderer >> extractMergedDamageRectangleFromWorldState: aWorldState ofWorld: aWorld [
	| handsToDraw worldDamageRectangles damageRectangles |
	
	worldDamageRectangles := aWorldState damageRecorder invalidRectsFullBounds: self drawingSurfaceBounds.
	
	handsToDraw := aWorldState hands.
	
	damageRectangles := 
		worldDamageRectangles ,
		(handsToDraw 
			collect: [:each | each computeDamageRectForNextFrame  ]
			thenReject: [:each | each isEmpty ]).
	
	aWorldState damageRecorder reset.

	^ damageRectangles
]

{ #category : #accessing }
FormSGNewAthensWorldRenderer >> handSurface [

	(handSurface isNil
		or: [ handSurface extent ~= self osWindowRenderer pixelExtent ])
		ifTrue: [ 
			handSurface := AthensCairoSurface extent:
				                  self osWindowRenderer pixelExtent ].
	^ handSurface
]

{ #category : #initialization }
FormSGNewAthensWorldRenderer >> initialize [

	super initialize.
	renderer := FormSGNewAthensRenderer new
]

{ #category : #initialization }
FormSGNewAthensWorldRenderer >> osWindowRenderer [
	osWindow ifNil: [ ^ nil ].
		^ osWindow renderer ifNil: [
			osWindow newAthensRenderer.
			osWindow renderer	
	].
	
]

{ #category : #accessing }
FormSGNewAthensWorldRenderer >> worldSurface [

	(worldSurface isNil
		or: [ worldSurface extent ~= self osWindowRenderer pixelExtent ])
		ifTrue: [ 
			worldSurface := AthensCairoSurface extent:
				                  self osWindowRenderer pixelExtent ].
	^ worldSurface 
]
