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
	
	| builder rootNodes |
	builder := FormSGBuilder new
					scale: self scaleFactor asFloat;
					clippingRectangles: damagedRectangles;
					yourself.
	
	rootNodes := OrderedCollection new.
	rootNodes add: (aWorld buildFullSceneGraphWith: builder).
	builder resetAfterRoot.
	
	aWorldState hands reverseDo: [ :each |
		each allMorphsDo: [ :m | m invalidateSceneGraph ].
		rootNodes add: (each buildFullSceneGraphWith: builder).
		builder resetAfterRoot.
	].

	^ builder containerWith: rootNodes
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
"
	windowRenderer updateAll.

	damageRectangles do: [:aRect | windowRenderer showDamagedRect: aRect].
"	
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
		(worldDamageRectangles collect: [ :r | r scaleBy: scaleFactor ]) ,
		(handsToDraw 
			collect: [:each | each computeDamageRectForNextFrame scaleBy: scaleFactor  ]
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
