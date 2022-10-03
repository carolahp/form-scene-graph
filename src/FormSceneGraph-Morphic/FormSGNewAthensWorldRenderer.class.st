Class {
	#name : #FormSGNewAthensWorldRenderer,
	#superclass : #FormSGAbstractWorldRenderer,
	#instVars : [
		'renderer',
		'worldSurface',
		'worldTreeBuilder'
	],
	#classVars : [
		'DebugMode'
	],
	#pools : [
		'SDL2Constants'
	],
	#category : #'FormSceneGraph-Morphic-WorldRenderer'
}

{ #category : #initialization }
FormSGNewAthensWorldRenderer class >> initialize [ 
	DebugMode := false
]

{ #category : #operations }
FormSGNewAthensWorldRenderer >> displayWorldRectangles: damageRectangles handTreeBuilders: handTreeBuilders [

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
		
		handTreeBuilders
			do: [ :aHandTreeBuilder | aHandTreeBuilder pasteOnCanvas: aCanvas ]
	].
	
	windowRenderer updateAll.
	windowRenderer renderer
			clear;
			copy: windowRenderer texture.
	
	DebugMode ifTrue: [
		windowRenderer renderer drawBlendMode: SDL_BLENDMODE_BLEND.
		windowRenderer renderer drawColorR: 255 g: 0 b: 0 a: 128.

		damageRectangles do: [ :aRect |
			windowRenderer renderer fillRect: aRect asSDLRect ]].
	
	windowRenderer renderer present.

]

{ #category : #private }
FormSGNewAthensWorldRenderer >> doActivate [ 

	super doActivate.
	World allMorphsDo: [ :m | m invalidateSceneGraph ].
]

{ #category : #operations }
FormSGNewAthensWorldRenderer >> doDisplayWorldState: aWorldState ofWorld: aWorld [

	worldTreeBuilder scale: self scaleFactor.
	worldTreeBuilder buildTreeForDamagedAreasOf: world.

	renderer clippingRectangles: worldTreeBuilder scaledDamagedAreas.
	self worldSurface drawDuring: [ :aCanvas | 
		renderer render: worldTreeBuilder worldTree on: aCanvas ].
	
	self
		displayWorldRectangles: worldTreeBuilder scaledDamagedAreas, worldTreeBuilder scaledHandObscuredAreas
		handTreeBuilders: worldTreeBuilder handTreeBuilders
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

{ #category : #initialization }
FormSGNewAthensWorldRenderer >> initialize [

	super initialize.

	renderer := FormSGNewAthensRenderer new.
	worldTreeBuilder := FormSGNewWorldTreeBuilder new 
								renderer: renderer; 
								yourself.
	
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
