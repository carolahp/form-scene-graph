Class {
	#name : #FormSGPreparerTest,
	#superclass : #TestCase,
	#instVars : [
		'preparer'
	],
	#category : #'FormSceneGraph-Renderer-Test'
}

{ #category : #tests }
FormSGPreparerTest >> setUp [ 
	super setUp.
	preparer := FormSGMorphOclusionAndClippingFilter new
]

{ #category : #utils }
FormSGPreparerTest >> showMorphs: aCollection [ 

	| all |
	all := Morph new
		color: Color transparent;
		extent: 500@500;
		yourself.
		
	aCollection do: [ :aMorph | all addMorphBack: aMorph ].
	
	all inspect
]

{ #category : #tests }
FormSGPreparerTest >> testHiddenMorphIsNotVisible [
	
	| graphs blueMorph redMorph |
	blueMorph := Morph new color: Color blue; yourself.
	redMorph := Morph new color: Color red; yourself.
	
	graphs := preparer 
						generatedTreeForMorphs: { blueMorph . redMorph } 
						visibleRectangles: { blueMorph bounds }.

	self assert: graphs size equals: 1.
	self assert: (graphs at: 1) isRectangleNode.
	self assert: (graphs at: 1) color equals: Color blue
	
]

{ #category : #tests }
FormSGPreparerTest >> testHiddenSmallerMorphIsNotVisible [
	
	| graphs blueMorph redMorph greenMorph |
	blueMorph := Morph new color: Color blue; yourself.
	redMorph := Morph new color: Color red; yourself.
	greenMorph := Morph new color: Color green; yourself.
	
	redMorph position: 50@40.
	greenMorph bounds: 
				((blueMorph bounds origin translateBy: 10@10) 
					corner: (blueMorph bounds origin translateBy: 10@10)).

	graphs := preparer 
						generatedTreeForMorphs: { blueMorph . redMorph . greenMorph } 
						visibleRectangles: { blueMorph bounds . redMorph bounds }.

	self assert: graphs size equals: 2.
	self assert: (graphs at: 1) isRectangleNode.
	self assert: (graphs at: 1) color equals: Color blue.
	self assert: (graphs at: 2) isRectangleNode.
	self assert: (graphs at: 2) color equals: Color red
	
]

{ #category : #tests }
FormSGPreparerTest >> testMorphOutOfVisibleRectangleIsNotVisible [
	
	| graphs blueMorph redMorph |
	blueMorph := Morph new color: Color blue; yourself.
	redMorph := Morph new color: Color red; yourself.
	
	redMorph position: 50@40.
	
	graphs := preparer 
						generatedTreeForMorphs: { blueMorph . redMorph } 
						visibleRectangles: { blueMorph bounds }.

	self assert: graphs size equals: 1.
	self assert: (graphs at: 1) isRectangleNode.
	self assert: (graphs at: 1) color equals: Color blue
]

{ #category : #tests }
FormSGPreparerTest >> testPartiallyHiddenMorphIsVisible [
	
	| graphs blueMorph redMorph greenMorph |
	blueMorph := Morph new color: Color blue; yourself.
	redMorph := Morph new color: Color red; yourself.
	greenMorph := Morph new color: Color green; yourself.
	
	redMorph position: 50@40.
	greenMorph position: 20@20.
	
"	self showMorphs: { blueMorph. redMorph. greenMorph }.
"
	graphs := preparer 
						generatedTreeForMorphs: { blueMorph . redMorph . greenMorph } 
						visibleRectangles: { blueMorph bounds . redMorph bounds }.

	self assert: graphs size equals: 3.
	self assert: (graphs at: 1) isRectangleNode.
	self assert: (graphs at: 1) color equals: Color blue.
	self assert: (graphs at: 2) isRectangleNode.
	self assert: (graphs at: 2) color equals: Color red.
	self assert: (graphs at: 3) isRectangleNode.
	self assert: (graphs at: 3) color equals: Color green
	
]

{ #category : #tests }
FormSGPreparerTest >> testSingleMorphVisibleIsInGraph [
	
	| graphs |
	graphs := preparer generatedTreeForMorphs: { Morph new } visibleRectangles: {  }.
	self assert: graphs size equals: 1.
	self assert: (graphs at: 1) isRectangleNode
]
