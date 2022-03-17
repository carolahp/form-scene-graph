Class {
	#name : #FormSGNewAthensWorldRenderer,
	#superclass : #FormSGAbstractWorldRenderer,
	#instVars : [
		'renderer'
	],
	#category : #'FormSceneGraph-Morphic-WorldRenderer'
}

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
	
	morphsToRender := FormSGMorphOclusionAndClippingFilter new
		filterMorphs: aWorldState hands, aWorld submorphs inVisibleRectangles: damagedRectangles.

	rootNodes := morphsToRender collect: [ :aMorph | |node|
			aMorph allMorphsDo: [ :m | m invalidateSceneGraph ].
			node := aMorph buildFullSceneGraphWith: builder.
			builder resetAfterRoot.
			node ].

	builder resetAfterRoot.
	rootNodes add: (aWorld buildSceneGraphNodeWith: builder).
	
	"The graph renderer draws things from the first to the last, we need to put the closer to the user at the end (Morphic does it in the other direction)"
	^ builder containerWith: rootNodes reverse
]

{ #category : #operations }
FormSGNewAthensWorldRenderer >> displayNewSceneGraph: nodes withDamageRectangle: damageRectangles [

	| windowRenderer |

	windowRenderer := self osWindowRenderer.
	renderer clippingRectangles: damageRectangles.

	windowRenderer drawDuring: [ :aCanvas |
		aCanvas surface clear: Color white.
		renderer render: nodes on: aCanvas ].

	damageRectangles do: [:aRect | 
		windowRenderer updateRectangle: aRect].

	windowRenderer present
]

{ #category : #private }
FormSGNewAthensWorldRenderer >> doActivate [ 

	super doActivate.
	World allMorphsDo: [ :m | m invalidateSceneGraph ].
]

{ #category : #operations }
FormSGNewAthensWorldRenderer >> doDisplayWorldState: aWorldState ofWorld: aWorld [
	| newSceneGraph damageRectangles |

	damageRectangles := self extractMergedDamageRectangleFromWorldState: aWorldState ofWorld: aWorld.
	damageRectangles isEmpty ifTrue: [ ^ self ].

	newSceneGraph := self buildSceneGraphForWorldState: aWorldState ofWorld: aWorld damagedRectangles: damageRectangles.

	self displayNewSceneGraph: newSceneGraph withDamageRectangle: damageRectangles.

]

{ #category : #private }
FormSGNewAthensWorldRenderer >> extractMergedDamageRectangleFromWorldState: aWorldState ofWorld: aWorld [
	| handsToDraw worldDamageRectangles damageRectangles scaleFactor |
	
	worldDamageRectangles := aWorldState damageRecorder invalidRectsFullBounds: self drawingSurfaceBounds.
	
	handsToDraw := aWorldState hands.
	scaleFactor := self scaleFactor.
	
	damageRectangles := 
		worldDamageRectangles ,
		(handsToDraw 
			collect: [:each | each computeDamageRectForNextFrame  ]
			thenReject: [:each | each isEmpty ]).
	
	aWorldState damageRecorder reset.

	^ damageRectangles
]

{ #category : #initialization }
FormSGNewAthensWorldRenderer >> initialize [

	super initialize.
	renderer := FormSGNewAthensRenderer new.
]

{ #category : #initialization }
FormSGNewAthensWorldRenderer >> osWindowRenderer [
	osWindow ifNil: [ ^ nil ].
		^ osWindow renderer ifNil: [
			osWindow newAthensRenderer.
			osWindow renderer	
	].
	
]
