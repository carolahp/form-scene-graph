Class {
	#name : #FormSGMorphOclusionAndClippingFilter,
	#superclass : #Object,
	#category : #'FormSceneGraph-Morphic'
}

{ #category : #generation }
FormSGMorphOclusionAndClippingFilter >> filterMorphs: morphs inVisibleRectangles: visibleRectangles [

	| alreadyDrawn unoclusedMorph visibleMorphs |
	alreadyDrawn := OrderedCollection new.
	visibleMorphs := morphs select: [ :morph | 
		                 visibleRectangles anySatisfy: [ :rect | 
			                 rect intersects: morph bounds ] ].
	unoclusedMorph := OrderedCollection new.

	visibleMorphs do: [ :aMorph | 
		(alreadyDrawn noneSatisfy: [ :aRectangle | 
			 aRectangle containsRect: aMorph bounds ]) ifTrue: [ 
			alreadyDrawn add: aMorph bounds.
			unoclusedMorph add: aMorph ] ].

	^ unoclusedMorph
]
