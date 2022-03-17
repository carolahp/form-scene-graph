Class {
	#name : #FormSGMorphOclusionAndClippingFilter,
	#superclass : #Object,
	#category : #'FormSceneGraph-Morphic'
}

{ #category : #generation }
FormSGMorphOclusionAndClippingFilter >> generatedTreeForMorphs: morphs visibleRectangles: visibleRectangles [
	| builder alreadyDrawn visibleMorphs |
	builder := FormSGBuilder new.
	
	alreadyDrawn := OrderedCollection new.

	visibleMorphs := OrderedCollection new.
	
	morphs do: [ :aMorph | 
		(alreadyDrawn noneSatisfy: [ :aRectangle | aRectangle containsRect: aMorph bounds ])
			ifTrue: [ 
				alreadyDrawn add: aMorph bounds.
				visibleMorphs add: aMorph ]].
		
	^ visibleMorphs collect: [ :morph | morph buildSceneGraphNodeWith: builder ]
]
