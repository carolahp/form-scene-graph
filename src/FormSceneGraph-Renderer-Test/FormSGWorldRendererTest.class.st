Class {
	#name : #FormSGWorldRendererTest,
	#superclass : #TestCase,
	#instVars : [
		'world',
		'hand',
		'worldTreeBuilder',
		'tree',
		'damagedAreas'
	],
	#category : #'FormSceneGraph-Renderer-Test'
}

{ #category : #util }
FormSGWorldRendererTest >> addDamageArea: aRectangle [ 
	
	damagedAreas := damagedAreas copyWith: aRectangle.
	world invalidRect: aRectangle
]

{ #category : #tests }
FormSGWorldRendererTest >> setUp [

	super setUp.

	world := WorldMorph new.
	world extent: 1000 @ 1200.
	world addHand: (hand := HandMorph new).
	world activeHand: hand.
	world worldState resetDamageRecorder.

	worldTreeBuilder := FormSGNewWorldTreeBuilder new.
	
	damagedAreas := OrderedCollection new.
]

{ #category : #tests }
FormSGWorldRendererTest >> testEmptyWorldReturnsOnlyBackgroundColor [

	self addDamageArea: (50 @ 50 extent: 100 @ 100).
	
	tree := worldTreeBuilder buildTreeForDamagedAreasOf: world.

	self assert: worldTreeBuilder clippingRectangles equals: damagedAreas.

	self assert: tree isBorderNode.
	self assert: tree rectangle equals: world bounds.
	self assert: tree color equals: world borderColor.
	self assert: tree content isRectangleNode.
	self assert: tree content rectangle equals: world innerBounds.
	self assert: tree content color equals: world color
]

{ #category : #tests }
FormSGWorldRendererTest >> testMultipleDamagedMorphAreReturned [

	| aMorph anotherMorph |

	world addMorph: (aMorph := Morph new position: 151@151; extent: 50@50; yourself).
	world addMorph: (anotherMorph := Morph new position: 100@100; extent: 50@50; color: Color red;  yourself).

	world worldState resetDamageRecorder.

	self addDamageArea: (151 @ 151 extent: 50 @ 50).
	self addDamageArea: (100 @ 100 extent: 50 @ 50).
	
	tree := worldTreeBuilder buildTreeForDamagedAreasOf: world.

	self assert: worldTreeBuilder clippingRectangles equals: damagedAreas.

	self assert: tree isContainerNode.

	self assert: (tree children at: 1) isRectangleNode.
	self assert: (tree children at: 1) rectangle equals: aMorph fullBoundsInWorld.
	self assert: (tree children at: 1) color equals: aMorph color.

	self assert: (tree children at: 2) isRectangleNode.
	self assert: (tree children at: 2) rectangle equals: anotherMorph fullBoundsInWorld.
	self assert: (tree children at: 2) color equals: anotherMorph color.

]

{ #category : #tests }
FormSGWorldRendererTest >> testNonDamagedMorphIsNotReturned [

	world addMorph: (Morph new position: 151@151).
	world worldState resetDamageRecorder.

	self addDamageArea: (50 @ 50 extent: 100 @ 100).
	
	tree := worldTreeBuilder buildTreeForDamagedAreasOf: world.

	self assert: worldTreeBuilder clippingRectangles equals: damagedAreas.

	self assert: tree isBorderNode.
	self assert: tree rectangle equals: world bounds.
	self assert: tree color equals: world borderColor.
	self assert: tree content isRectangleNode.
	self assert: tree content rectangle equals: world innerBounds.
	self assert: tree content color equals: world color
]

{ #category : #tests }
FormSGWorldRendererTest >> testOnlyDamagedMorphIsReturned [

	| aMorph |
	world addMorph: (aMorph := Morph new position: 151@151; extent: 50@50; yourself).
	world worldState resetDamageRecorder.

	self addDamageArea: (151 @ 151 extent: 50 @ 50).
	
	tree := worldTreeBuilder buildTreeForDamagedAreasOf: world.

	self assert: worldTreeBuilder clippingRectangles equals: damagedAreas.

	self assert: tree isRectangleNode.
	self assert: tree rectangle equals: aMorph fullBoundsInWorld.
	self assert: tree color equals: aMorph color.

]

{ #category : #tests }
FormSGWorldRendererTest >> testOverlappingMorphsAreReturnedCorrectly [

	| aMorph anotherMorph |

	world addMorph: (aMorph := Morph new position: 151@151; extent: 50@50; yourself).
	world addMorph: (anotherMorph := Morph new position: 120@120; extent: 50@50; color: Color red;  yourself).

	world worldState resetDamageRecorder.

	self addDamageArea: (151 @ 151 extent: 50 @ 50).
	
	tree := worldTreeBuilder buildTreeForDamagedAreasOf: world.

	self assert: worldTreeBuilder clippingRectangles equals: damagedAreas.

	self assert: tree isContainerNode.

	self assert: (tree children at: 1) isRectangleNode.
	self assert: (tree children at: 1) rectangle equals: aMorph fullBoundsInWorld.
	self assert: (tree children at: 1) color equals: aMorph color.

	self assert: (tree children at: 2) isRectangleNode.
	self assert: (tree children at: 2) rectangle equals: anotherMorph fullBoundsInWorld.
	self assert: (tree children at: 2) color equals: anotherMorph color.

]
