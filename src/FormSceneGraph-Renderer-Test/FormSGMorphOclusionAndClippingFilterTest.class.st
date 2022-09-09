Class {
	#name : #FormSGMorphOclusionAndClippingFilterTest,
	#superclass : #TestCase,
	#instVars : [
		'preparer'
	],
	#category : #'FormSceneGraph-Renderer-Test'
}

{ #category : #tests }
FormSGMorphOclusionAndClippingFilterTest >> setUp [ 
	super setUp.
	preparer := FormSGMorphOclusionAndClippingFilter new
]

{ #category : #utils }
FormSGMorphOclusionAndClippingFilterTest >> showMorphs: aCollection [ 

	| all |
	all := Morph new
		color: Color transparent;
		extent: 500@500;
		yourself.
		
	aCollection do: [ :aMorph | all addMorphBack: aMorph ].
	
	all inspect
]

{ #category : #tests }
FormSGMorphOclusionAndClippingFilterTest >> testHiddenMorphIsNotVisible [
	
	| morphs blueMorph redMorph |
	blueMorph := Morph new color: Color blue; yourself.
	redMorph := Morph new color: Color red; yourself.
	
	morphs := preparer 
						filterMorphs: { blueMorph . redMorph } 
						inVisibleRectangles: { blueMorph bounds }.

	self assertCollection: morphs hasSameElements: { blueMorph}.

]

{ #category : #tests }
FormSGMorphOclusionAndClippingFilterTest >> testHiddenSmallerMorphIsNotVisible [
	
	| morphs blueMorph redMorph greenMorph |
	blueMorph := Morph new color: Color blue; yourself.
	redMorph := Morph new color: Color red; yourself.
	greenMorph := Morph new color: Color green; yourself.
	
	redMorph position: 50@40.
	greenMorph bounds: 
				((blueMorph bounds origin translateBy: 10@10) 
					corner: (blueMorph bounds origin translateBy: 10@10)).

	morphs := preparer 
						filterMorphs: { blueMorph . redMorph . greenMorph } 
						inVisibleRectangles: { blueMorph bounds . redMorph bounds }.

	self assertCollection: morphs hasSameElements: { blueMorph. redMorph }.
	
]

{ #category : #tests }
FormSGMorphOclusionAndClippingFilterTest >> testHiddenSmallerMorphIsNotVisibleInWorld [
	
	| morphs world blueWindow redWindow greenWindow hand |
	
	world := WorldMorph new extent: 1000@1000.
	hand := HandMorph new.
	world addHand: hand.
	world activeHand: hand.
	
	blueWindow := SystemWindow new setLabel: 'blue'; yourself.
	redWindow := SystemWindow new setLabel: 'red'; yourself.
	greenWindow  := SystemWindow new setLabel: 'green'; yourself.

	greenWindow openInWorld: world.
	blueWindow openInWorld: world.
	redWindow openInWorld: world.
		
	redWindow position: 50@40.
	greenWindow bounds: redWindow bounds.

	morphs := preparer 
						filterMorphs: world submorphs
						inVisibleRectangles: { greenWindow bounds }.

	self assertCollection: morphs hasSameElements: { redWindow }.

]

{ #category : #tests }
FormSGMorphOclusionAndClippingFilterTest >> testMorphOutOfVisibleRectangleIsNotVisible [
	
	| morphs blueMorph redMorph |
	blueMorph := Morph new color: Color blue; yourself.
	redMorph := Morph new color: Color red; yourself.
	
	redMorph position: 50@40.
	
	morphs := preparer 
						filterMorphs: { blueMorph . redMorph } 
						inVisibleRectangles: { blueMorph bounds }.

	self assertCollection: morphs hasSameElements: { blueMorph }
]

{ #category : #tests }
FormSGMorphOclusionAndClippingFilterTest >> testPartiallyHiddenMorphIsVisible [
	
	| morphs blueMorph redMorph greenMorph |
	blueMorph := Morph new color: Color blue; yourself.
	redMorph := Morph new color: Color red; yourself.
	greenMorph := Morph new color: Color green; yourself.
	
	redMorph position: 50@40.
	greenMorph position: 20@20.
	
"	self showMorphs: { blueMorph. redMorph. greenMorph }.
"
	morphs := preparer 
						filterMorphs: { blueMorph . redMorph . greenMorph } 
						inVisibleRectangles: { blueMorph bounds . redMorph bounds }.

	self assertCollection: morphs hasSameElements: { blueMorph. redMorph }.

]

{ #category : #tests }
FormSGMorphOclusionAndClippingFilterTest >> testSingleMorphVisibleIsInGraph [

	| blueMorph morphs |
	morphs := preparer
		          filterMorphs: { (blueMorph := Morph new) }
		          inVisibleRectangles: { blueMorph bounds }.

	self assertCollection: morphs hasSameElements: { blueMorph }
]
