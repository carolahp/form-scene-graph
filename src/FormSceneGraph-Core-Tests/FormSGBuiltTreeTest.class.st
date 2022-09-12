Class {
	#name : #FormSGBuiltTreeTest,
	#superclass : #TestCase,
	#instVars : [
		'builder'
	],
	#category : #'FormSceneGraph-Core-Tests'
}

{ #category : #tests }
FormSGBuiltTreeTest >> buildGraphFor: morph [

	builder := FormSGBuilder new
						scale: 1;
						yourself.

	^ morph buildFullSceneGraphWith: builder
]

{ #category : #tests }
FormSGBuiltTreeTest >> grabMorphFromSpec: aPresenter [

	| window morph |
	window := aPresenter open.
	morph := aPresenter adapter widget.
	window delete.
	
	morph position: 0@0.
	
	^ morph

]

{ #category : #tests }
FormSGBuiltTreeTest >> testColorMorphWithBorderReturnsBorder [

	| morph graph |
	morph := Morph new.
	morph borderColor: Color black.
	morph borderWidth: 5.
	morph color: Color red.
	
	graph := self buildGraphFor: morph.
	
	self assert: graph isBorderNode.
	self assert: graph content isRectangleNode.
	self assert: graph content color equals: Color red.

]

{ #category : #tests }
FormSGBuiltTreeTest >> testFastTable [

	| list graph |
	list := FTTableMorph new
		extent: 300@300;
		dataSource: (FTExampleDataSource elements: (Smalltalk allClassesAndTraits 
			sorted: [ :a :b | a name < b name]));
		yourself.

	graph := self buildGraphFor: list.
	
	self assert: graph isCachingSubSceneNode.
	self assert: graph rectangle equals: list bounds.

]

{ #category : #tests }
FormSGBuiltTreeTest >> testFastTableMoved [

	| list graph |
	list := FTTableMorph new
		extent: 300@300;
		position: 100@100;
		dataSource: (FTExampleDataSource elements: (Smalltalk allClassesAndTraits 
			sorted: [ :a :b | a name < b name]));
		yourself.

	graph := self buildGraphFor: list.

	self assert: graph isCachingSubSceneNode.
	self assert: graph rectangle equals: list bounds.

]

{ #category : #tests }
FormSGBuiltTreeTest >> testFastTableRow [

	| aTable row graph |
	aTable := FTTableMorph new.
	row := (FTTableRowMorph table: aTable)
		       bounds: (1.0 @ 280.0 corner: 287.0 @ 300.0);
		       addMorph: (FTCellMorph new
				        bounds: (1.0 @ 280.0 corner: 287.0 @ 300.0);
				        addMorph: 'AIGraphReducer' asStringMorph;
				        addMorph: (Smalltalk ui theme iconNamed: #class) asMorph;
				        yourself) yourself.

	graph := self buildGraphFor: row.

	self assert: graph isClipNode.
	self assert: graph rectangle equals: row bounds.
	self assert: (graph child children at: 1) string equals: 'AIGraphReducer'.
	self assert: (graph child children at: 2) form equals: (Smalltalk ui theme iconNamed: #class)
]

{ #category : #tests }
FormSGBuiltTreeTest >> testMultipleFastTable [

	| graph panel |
	
	panel := PanelMorph new.
	panel layoutPolicy: ProportionalLayout new.
	panel extent: 700@300.
		
	panel addMorph: (FTTableMorph new
		position: 0@0;
		extent: 300@300;
		dataSource: (FTExampleDataSource elements: (Smalltalk allClassesAndTraits 
			sorted: [ :a :b | a name < b name]));
		yourself).

	panel addMorph: (FTTableMorph new
		position: 300@0;
		extent: 300@300;
		dataSource: (FTExampleDataSource elements: (Smalltalk allTraits 
			sorted: [ :a :b | a name < b name]));
		yourself).

	graph := self buildGraphFor: panel.
	
	self assert: graph isClipNode.
	self assert: (graph child children at: 1) isCachingSubSceneNode.
	self assert: (graph child children at: 2) isCachingSubSceneNode.	
	"The morphs are in reverse order in the three"
	self assert: (graph child children at: 1) boundingBox equals: panel submorphs second bounds.
	self assert: (graph child children at: 2) boundingBox equals: panel submorphs first bounds

]

{ #category : #tests }
FormSGBuiltTreeTest >> testRubricTextArea [

	| textMorph graph |
	textMorph := 
			SpRubScrolledTextMorph new
				beForSmalltalkCode;
				position: 10@10;
				extent: 700@300;
				setText: (Object >> #printString) sourceCode;
				yourself	.

	graph := self buildGraphFor: textMorph.
	
	self assert: (graph withAllChildren anySatisfy: [ :e | e isTextNode and: [ e string = (Object >> #printString) sourceCode ] ])
]

{ #category : #tests }
FormSGBuiltTreeTest >> testSimpleMorphReturnsColorRectangle [

	| morph graph |
	morph := Morph new.
	morph position: 0@0.
	
	graph := self buildGraphFor: morph.
	
	self assert: graph isRectangleNode.
	self assert: graph color equals: morph color.
	self assert: graph rectangle equals: morph bounds.
]

{ #category : #tests }
FormSGBuiltTreeTest >> testSimpleMorphReturnsColorRectangleNotAtOrigin [

	| morph graph |
	morph := Morph new.
	morph position: 50@50.
	
	graph := self buildGraphFor: morph.
	
	self assert: graph isRectangleNode.
	self assert: graph color equals: morph color.
	self assert: graph rectangle equals: morph bounds.
	self assert: graph rectangle origin equals: 50@50
]

{ #category : #tests }
FormSGBuiltTreeTest >> testToolbarButtons [

	| toolbar morph graph |
	toolbar := SpToolbarPresenter new
		addItem: (SpToolbarButtonPresenter new
				label: 'Do it';
				icon: (Smalltalk ui theme iconNamed: #smallOk);
				yourself
			).
	
	morph := self grabMorphFromSpec: toolbar.			

	graph := self buildGraphFor: morph.
	
	self assert: graph isClipNode.
	self assert: graph child isContainerNode.
	self assert: (graph child children at: 1) isTextNode.
	self assert: (graph child children at: 1) string equals: 'Do it'.
	self assert: (graph child children at: 1) rectangle equals: ((12@135) corner: (32@147)).	

]

{ #category : #tests }
FormSGBuiltTreeTest >> testToolbarButtonsInMillerList [

	| presenter morph graph |
	presenter := 
		SpMillerColumnPresenter new
			presenterBlock:[ :aValue | 
				SpToolbarPresenter new
					addItem: (SpToolbarButtonPresenter new
							label: aValue;
							icon: (Smalltalk ui theme iconNamed: #smallOk);
							yourself
						)];
			setRootModel: 'Do it';
			yourself.
	
	morph := self grabMorphFromSpec: presenter.			

	graph := self buildGraphFor: morph.
	
	self assert: graph isClipNode.
	self assert: graph child isContainerNode.
	self assert: (graph child children at: 1) isTextNode.
	self assert: (graph child children at: 1) string equals: 'Do it'.
	self assert: (graph child children at: 1) rectangle equals: ((12@135) corner: (32@147)).	

]

{ #category : #tests }
FormSGBuiltTreeTest >> testTransformMorphWithOutTransformDoesNotAffectTree [

	| morph graph |
	
	morph := TransformMorph new.
	morph beTransparent.
	morph addMorph: Morph new.
	
	graph := self buildGraphFor: morph.

	self assert: graph isClipNode.
	self assert: graph rectangle equals: (0@0 extent: 50@40).
	self assert: graph child isRectangleNode.
	self assert: graph child rectangle equals: (0@0 extent: 50@40)
]

{ #category : #tests }
FormSGBuiltTreeTest >> testTransformMorphWithTranslationAffectsChilds [

	| morph graph |
	
	morph := TransformMorph new.
	morph transform setOffset: 20@20.
	morph beTransparent.
	morph addMorph: Morph new.	
	
	graph := self buildGraphFor: morph.

	self assert: graph isClipNode.
	self assert: graph rectangle equals: (0@0 corner: 50@40).
	self assert: graph child isRectangleNode.
	self assert: graph child rectangle equals: (-20@(-20) corner: 30@20)
]

{ #category : #tests }
FormSGBuiltTreeTest >> testTransparentMorphWithBorderReturnsBorder [

	| morph graph |
	morph := Morph new.
	morph borderColor: Color black.
	morph borderWidth: 5.
	morph color: Color transparent.

	graph := self buildGraphFor: morph.
	
	self assert: graph isBorderNode.
	self assert: graph content isNullNode.

]
