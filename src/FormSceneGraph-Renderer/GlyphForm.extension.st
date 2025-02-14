Extension { #name : 'GlyphForm' }

{ #category : '*FormSceneGraph-Renderer' }
GlyphForm >> asTextureRenderingGlyphForm [
	^ self
]

{ #category : '*FormSceneGraph-Renderer' }
GlyphForm >> inverted [
	| result |
	result := super inverted.
	^ (self class extent: result extent depth: result depth bits: result bits)
		offset: offset;
		advance: advance;
		linearAdvance: linearAdvance;
		yourself
]
