Class {
	#name : #FormSGSubMorphsOclusionAndClippingFilterTest,
	#superclass : #TestCase,
	#instVars : [
		'preparer'
	],
	#category : #'FormSceneGraph-Renderer-Test'
}

{ #category : #tests }
FormSGSubMorphsOclusionAndClippingFilterTest >> showMorphs: aCollection [ 

	| all |
	all := Morph new
		color: Color transparent;
		extent: 500@500;
		yourself.
		
	aCollection do: [ :aMorph | all addMorphBack: aMorph ].
	
	all inspect
]

{ #category : #tests }
FormSGSubMorphsOclusionAndClippingFilterTest >> testASubmorphIsNonOcludedByAnotherTranparentWindow [
	
	| blueMorph greenMorph redWindow yellowWindow morphs builder graphs yellowSubGraph |
	redWindow := Morph new color: Color transparent; 
		borderColor: Color black;
		borderWidth: 1;
		extent: 200@200; yourself.
	
	yellowWindow := Morph new color: Color yellow; extent: 200@200; position: 100@100.
	
	blueMorph := Morph new color: Color blue; extent: 10@10; yourself.

	greenMorph := Morph new color: Color green; extent: 10@10; yourself.

	yellowWindow addMorph: blueMorph. 
	yellowWindow addMorph: greenMorph. 
	
	blueMorph position: 10@10 + yellowWindow position.
	greenMorph position: 110@110 + yellowWindow position.

	morphs := {redWindow. yellowWindow}.
		
	builder := FormSGBuilder new.
	graphs := morphs collect: [ :aMorph | aMorph buildFullSceneGraphWith: builder].
	yellowSubGraph := graphs at: 2.
		
	self assert: yellowSubGraph isContainerNode.
	self assert: yellowSubGraph children size equals: 3.
	self assert: (yellowSubGraph children at: 1) color equals: Color yellow.
	self assert: (yellowSubGraph children at: 2) color equals: Color blue.
	self assert: (yellowSubGraph children at: 3) color equals: Color green.

]

{ #category : #tests }
FormSGSubMorphsOclusionAndClippingFilterTest >> testASubmorphOcludedByAnotherWindowIsNotVisible [
	
	| blueMorph greenMorph redWindow yellowWindow morphs builder graphs yellowSubGraph |
	redWindow := Morph new color: Color red; extent: 200@200; yourself.
	yellowWindow := Morph new color: Color yellow; extent: 200@200; position: 100@100.
	
	blueMorph := Morph new color: Color blue; extent: 10@10; yourself.

	greenMorph := Morph new color: Color green; extent: 10@10; yourself.

	yellowWindow addMorph: blueMorph. 
	yellowWindow addMorph: greenMorph. 
	
	blueMorph position: 10@10 + yellowWindow position.
	greenMorph position: 110@110 + yellowWindow position.

	morphs := {redWindow. yellowWindow}.
	
	builder := FormSGBuilder new.
	graphs := morphs collect: [ :aMorph | aMorph buildFullSceneGraphWith: builder].
	yellowSubGraph := graphs at: 2.
		
	self assert: yellowSubGraph isContainerNode.
	self assert: (yellowSubGraph children at: 1) color equals: Color yellow.
	self assert: (yellowSubGraph children at: 2) color equals: Color green.
	self assert: yellowSubGraph children size equals: 2.

]

{ #category : #tests }
FormSGSubMorphsOclusionAndClippingFilterTest >> testHiddenMorphIsNotVisible [
	
	| blueMorph redMorph greenMorph graph |
	redMorph := Morph new color: Color red; extent: 200@200; yourself.
	blueMorph := Morph new color: Color blue;
		position: 10@10;
		extent: 100@100; yourself.

	greenMorph := Morph new color: Color green;
		position: 10@10;
		extent: 100@100; yourself.

	redMorph addMorph: blueMorph.
	redMorph addMorphBack: greenMorph.
	
"	self showMorphs: {redMorph}.
"	
	graph := redMorph buildFullSceneGraphWith: (FormSGBuilder new).
		
	self assert: graph isContainerNode.
	self assert: (graph children at: 1) color equals: Color red.
	self assert: (graph children at: 2) color equals: Color blue.
	self assert: graph children size equals: 2.

]

{ #category : #tests }
FormSGSubMorphsOclusionAndClippingFilterTest >> testVisibleMorphIsVisible [
	
	| blueMorph redMorph greenMorph graph |
	redMorph := Morph new color: Color red; extent: 200@200; yourself.
	blueMorph := Morph new color: Color blue;
		position: 10@10;
		extent: 100@100; yourself.

	greenMorph := Morph new color: Color green;
		position: 15@15;
		extent: 50@50; yourself.

	redMorph addMorph: blueMorph.
	redMorph addMorph: greenMorph.
	
"	self showMorphs: {redMorph}.
"	
	graph := redMorph buildFullSceneGraphWith: (FormSGBuilder new).
		
	self assert: graph isContainerNode.
	self assert: (graph children at: 1) color equals: Color red.
	self assert: (graph children at: 2) color equals: Color blue.
	self assert: (graph children at: 3) color equals: Color green.
	self assert: graph children size equals: 3.

]
