Class {
	#name : #FormSGNewAthensWorldRenderer,
	#superclass : #FormSGAbstractWorldRenderer,
	#instVars : [
		'renderer',
		'worldSurface',
		'handSurface'
	],
	#pools : [
		'SDL2Constants'
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
			builder clippingRectangles: damagedRectangles.
			node := aMorph buildFullSceneGraphWith: builder.
			builder resetAfterRoot.
			node ].

	builder resetAfterRoot.
	rootNodes add: (aWorld buildSceneGraphNodeWith: builder).
	
	"The graph renderer draws things from the first to the last, we need to put the closer to the user at the end (Morphic does it in the other direction)"
	^ builder containerWith: rootNodes reverse
]

{ #category : #operations }
FormSGNewAthensWorldRenderer >> displayWorldRectangles: damageRectangles handRectangles: handRectangles [

	| windowRenderer |

	windowRenderer := self osWindowRenderer.

	windowRenderer drawDuring: [ :aCanvas |
		damageRectangles do: [ :aRect |
			aCanvas pasteSurface: self worldSurface 
					targetX: aRect origin x 
					targetY: aRect origin y 
					sourceX: aRect origin x
					sourceY: aRect origin y 
					width: aRect extent x 
					height: aRect extent y.			
		].
		
"		aCanvas pasteSurface: self handSurface 
				targetX: 0 
				targetY: 0 
				sourceX: 0
				sourceY: 0 
				width: self handSurface extent x 
				height: self handSurface extent y.
"		].
	
	windowRenderer updateAll.
	windowRenderer renderer
			clear;
			copy: windowRenderer texture.
	
	windowRenderer renderer drawBlendMode: SDL_BLENDMODE_BLEND.
	windowRenderer renderer drawColorR: 255 g: 0 b: 0 a: 192.

	damageRectangles do: [ :aRect |
		windowRenderer renderer fillRect: aRect asSDLRect ].

	windowRenderer renderer drawColorR: 0 g: 0 b: 255 a: 192.
		
	handRectangles do: [ :aRect |
		windowRenderer renderer fillRect: aRect asSDLRect ].	
	
	windowRenderer renderer present.

]

{ #category : #private }
FormSGNewAthensWorldRenderer >> doActivate [ 

	super doActivate.
	World allMorphsDo: [ :m | m invalidateSceneGraph ].
]

{ #category : #operations }
FormSGNewAthensWorldRenderer >> doDisplayWorldState: aWorldState ofWorld: aWorld [

	| worldTreeBuilder tree |
	worldTreeBuilder := FormSGNewWorldTreeBuilder new scale: self scaleFactor; yourself.
	tree := worldTreeBuilder buildTreeForDamagedAreasOf: world.

	renderer clippingRectangles: worldTreeBuilder scaledDamagedAreas.

	self worldSurface drawDuring: [ :aCanvas | 
		renderer render: tree on: aCanvas ].
	
	self
		displayWorldRectangles: worldTreeBuilder scaledDamagedAreas, worldTreeBuilder scaledHandObscuredAreas
		handRectangles: #()
]

{ #category : #private }
FormSGNewAthensWorldRenderer >> extractMergedDamageRectangleFromWorldState: aWorldState ofWorld: aWorld [
	| handsToDraw worldDamageRectangles damageRectangles |
	
	worldDamageRectangles := aWorldState damageRecorder invalidRectsFullBounds: self drawingSurfaceBounds.
	
	handsToDraw := aWorldState hands.
	
	damageRectangles := 
		worldDamageRectangles ",
		(handsToDraw 
			collect: [:each | each computeDamageRectForNextFrame  ]
			thenReject: [:each | each isEmpty ])".
	
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
