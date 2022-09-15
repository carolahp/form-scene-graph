Class {
	#name : #FormSGWorldRendererTest,
	#superclass : #ParametrizedTestCase,
	#instVars : [
		'world',
		'hand',
		'worldTreeBuilder',
		'tree',
		'damagedAreas',
		'scale'
	],
	#category : #'FormSceneGraph-Renderer-Test'
}

{ #category : #tests }
FormSGWorldRendererTest class >> testParameters [

	^ super testParameters 
		forSelector: #scale addOptions: #(1 1.5 2)
]

{ #category : #util }
FormSGWorldRendererTest >> addDamageArea: aRectangle [ 
	
	damagedAreas := damagedAreas copyWith: aRectangle.
	world invalidRect: aRectangle
]

{ #category : #accessing }
FormSGWorldRendererTest >> scale: aScale [

	scale := aScale
]

{ #category : #utils }
FormSGWorldRendererTest >> scaleRectangle: aRectangle [ 
	
	^ (aRectangle scaleBy: scale) roundTo: 1
]

{ #category : #util }
FormSGWorldRendererTest >> sendRightClickTo: aMorph [
		
	"Right Button is yellowButton"
	| noButtons |
	
	noButtons := 0.
	
	{ #mouseDown->MouseEvent yellowButton. #mouseUp->noButtons } do: [ :type |
		world hands first handleEvent: (MouseButtonEvent new 
			setType: type key
			position: (aMorph pointInWorld: aMorph center) 
			which: (noButtons bitXor: MouseEvent yellowButton)
			buttons: type value
			hand: world hands first
			stamp: Time millisecondClockValue) ].

]

{ #category : #tests }
FormSGWorldRendererTest >> setUp [

	super setUp.

	world := WorldMorphForTest new.
	world extent: 1000 @ 1200.
	world addHand: (hand := HandMorph new).
	world activeHand: hand.
	world worldState resetDamageRecorder.

	worldTreeBuilder := FormSGNewWorldTreeBuilder new scale: scale; yourself.
	
	damagedAreas := OrderedCollection new.
]

{ #category : #'tests - hands' }
FormSGWorldRendererTest >> testEmptyHandMorphDoesNotObscureAreas [

	world activeHand position: 100@100.
	world worldState resetDamageRecorder.

	worldTreeBuilder extractDamagedAreasOf: world.
	
	"If the hand is empty, and there is no damage in the world. We don't have damaged areas in the hand or in the world, and nothing is obscured"
	
	self assert: worldTreeBuilder damagedAreas isEmpty.
	self assert: worldTreeBuilder handDamagedAreas isEmpty.
	self assert: worldTreeBuilder handObscuredAreas isEmpty.

]

{ #category : #tests }
FormSGWorldRendererTest >> testEmptyWorldReturnsOnlyBackgroundColor [

	self addDamageArea: (50 @ 50 extent: 100 @ 100).
	
	tree := worldTreeBuilder buildTreeForDamagedAreasOf: world.

	self assert: worldTreeBuilder damagedAreas equals: damagedAreas.

	self assert: tree isBorderNode.
	self assert: tree rectangle equals: (self scaleRectangle: world bounds).
	self assert: tree color equals: world borderColor.
	self assert: tree content isRectangleNode.
	self assert: tree content rectangle equals: (self scaleRectangle: world innerBounds).
	self assert: tree content color equals: world color
]

{ #category : #'tests - hands' }
FormSGWorldRendererTest >> testHandMorphWithMorphDoesObscureAreas [

	world activeHand position: 100@100.
	world activeHand attachMorph: Morph new.

	world worldState resetDamageRecorder.
	world activeHand damagedRectangles. "Reset damage recorder"

	worldTreeBuilder extractDamagedAreasOf: world.
	
	self assert: worldTreeBuilder damagedAreas isEmpty.
	self assert: worldTreeBuilder handDamagedAreas isEmpty.
		
	"Default size is 50@40, with the shadow is 6@8, and the position is 100@100, but it is centered"
	
	self 
		assertCollection: worldTreeBuilder scaledHandObscuredAreas 
		hasSameElements: {(self scaleRectangle: (75@80 extent: 56@48))}.


]

{ #category : #'tests - hands' }
FormSGWorldRendererTest >> testHandMorphWithNewMorphHasDamagedAreas [

	world activeHand position: 100@100.
	world activeHand attachMorph: Morph new.

		worldTreeBuilder extractDamagedAreasOf: world.
	
	self assert: worldTreeBuilder damagedAreas isEmpty.
	self 
		assertCollection: worldTreeBuilder scaledHandDamagedAreas 
		hasSameElements: {self scaleRectangle: (Rectangle center: 100@100 extent:50@40)}
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

	self assert: worldTreeBuilder damagedAreas equals: damagedAreas.

	self assert: tree isContainerNode.

	self assert: (tree children at: 1) isRectangleNode.
	self 
		assert: (tree children at: 1) rectangle 
		equals: (self scaleRectangle: aMorph fullBoundsInWorld).

	self assert: (tree children at: 1) color equals: aMorph color.

	self assert: (tree children at: 2) isRectangleNode.
	self 
		assert: (tree children at: 2) rectangle 
		equals: (self scaleRectangle: anotherMorph fullBoundsInWorld).
	self assert: (tree children at: 2) color equals: anotherMorph color.

]

{ #category : #tests }
FormSGWorldRendererTest >> testNonDamagedMorphIsNotReturned [

	world addMorph: (Morph new position: 151@151).
	world worldState resetDamageRecorder.

	self addDamageArea: (50 @ 50 extent: 100 @ 100).
	
	tree := worldTreeBuilder buildTreeForDamagedAreasOf: world.

	self assert: worldTreeBuilder damagedAreas equals: damagedAreas.

	self assert: tree isBorderNode.
	self assert: tree rectangle equals: (self scaleRectangle: world bounds).
	self assert: tree color equals: world borderColor.
	self assert: tree content isRectangleNode.
	self assert: tree content rectangle equals: (self scaleRectangle: world innerBounds).
	self assert: tree content color equals: world color
]

{ #category : #tests }
FormSGWorldRendererTest >> testOnlyDamagedMorphIsReturned [

	| aMorph |
	world addMorph: (aMorph := Morph new position: 151@151; extent: 50@50; yourself).
	world worldState resetDamageRecorder.

	self addDamageArea: (151 @ 151 extent: 50 @ 50).
	
	tree := worldTreeBuilder buildTreeForDamagedAreasOf: world.

	self assert: worldTreeBuilder damagedAreas equals: damagedAreas.

	self assert: tree isRectangleNode.
	self assert: tree rectangle equals: (self scaleRectangle: aMorph fullBoundsInWorld).
	self assert: tree color equals: aMorph color.

]

{ #category : #tests }
FormSGWorldRendererTest >> testOpeningPlaygroundContextMenuGeneratesCorrectDamagedAreas [

	| aPlaygroundWindow aPlaygroundMorph rubEditingAreaMorph effectiveDamagedAreas form |

self skip.
	aPlaygroundWindow := StPlayground new asWindow.

	aPlaygroundWindow buildWithSpecLayout: aPlaygroundWindow presenter layout.
	aPlaygroundWindow application registerWindow: aPlaygroundWindow.
	aPlaygroundWindow withAdapterDo: [ :anAdapter | 
			anAdapter widget openInWorld: world.
			anAdapter widget position: 100@100.
			anAdapter widget extent: 300@300.
			anAdapter presenter presenter takeKeyboardFocus.
			anAdapter windowIsOpened.
			
			aPlaygroundWindow allPresenters do: [ :each | each announceDisplayed ].
			aPlaygroundWindow updateTitle ].

	world worldState resetDamageRecorder.
		
	aPlaygroundMorph := aPlaygroundWindow adapter widget.
	rubEditingAreaMorph := aPlaygroundMorph findDeeplyA: RubEditingArea.

	world activeHand position: (aPlaygroundMorph pointInWorld: aPlaygroundMorph center).

	(rubEditingAreaMorph getMenu: false)
		ifNotNil: [ :menu|
			menu privateOwner: rubEditingAreaMorph.
			menu setInvokingView: rubEditingAreaMorph editor.
			menu popUpAt: world activeHand position 
				forHand: world primaryHand 
				in: world allowKeyboard: true.
			rubEditingAreaMorph changed].
	
	world stopOnNextInvalidation.

1halt.

	tree := worldTreeBuilder buildTreeForDamagedAreasOf: world.
	effectiveDamagedAreas := worldTreeBuilder damagedAreas .

	form := self worldFormWithDamagedAreas: effectiveDamagedAreas.
	self error.	


]

{ #category : #tests }
FormSGWorldRendererTest >> testOverlappingMorphsAreReturnedCorrectly [

	| aMorph anotherMorph |

	world addMorph: (aMorph := Morph new position: 151@151; extent: 50@50; yourself).
	world addMorph: (anotherMorph := Morph new position: 120@120; extent: 50@50; color: Color red;  yourself).

	world worldState resetDamageRecorder.

	self addDamageArea: (151 @ 151 extent: 50 @ 50).
	
	tree := worldTreeBuilder buildTreeForDamagedAreasOf: world.

	self assert: worldTreeBuilder damagedAreas equals: damagedAreas.

	self assert: tree isContainerNode.

	self assert: (tree children at: 1) isRectangleNode.
	self 
		assert: (tree children at: 1) rectangle 
		equals: (self scaleRectangle:aMorph fullBoundsInWorld).
	
	self assert: (tree children at: 1) color equals: aMorph color.

	self assert: (tree children at: 2) isRectangleNode.
	self 
		assert: (tree children at: 2) rectangle 
		equals: (self scaleRectangle: anotherMorph fullBoundsInWorld).
	self assert: (tree children at: 2) color equals: anotherMorph color.

]

{ #category : #tests }
FormSGWorldRendererTest >> worldFormWithDamagedAreas: effectiveDamagedAreas [

	| originalForm resultForm canvas |
	originalForm := world asForm.
	resultForm := Form extent: originalForm extent depth: originalForm depth.

	canvas := resultForm getCanvas.
	canvas fillColor: Color transparent. 

	effectiveDamagedAreas do: [ :e | 
		canvas
			image: originalForm 
			at: e origin 
			sourceRect: e 
			rule: Form over  ].
		
	^ resultForm
]
