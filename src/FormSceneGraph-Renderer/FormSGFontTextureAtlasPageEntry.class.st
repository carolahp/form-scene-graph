"
I represent a single glyph entry in a font texture atlas based cache.
"
Class {
	#name : 'FormSGFontTextureAtlasPageEntry',
	#superclass : 'Object',
	#instVars : [
		'page',
		'pixelRectangle',
		'rectangle',
		'glyphForm',
		'hasSubpixelAntialiasing'
	],
	#category : 'FormSceneGraph-Renderer-Font',
	#package : 'FormSceneGraph-Renderer',
	#tag : 'Font'
}

{ #category : 'accessing' }
FormSGFontTextureAtlasPageEntry >> glyphForm [
	^ glyphForm
]

{ #category : 'accessing' }
FormSGFontTextureAtlasPageEntry >> glyphForm: anObject [
	glyphForm := anObject
]

{ #category : 'accessing' }
FormSGFontTextureAtlasPageEntry >> hasSubpixelAntialiasing [
	^ hasSubpixelAntialiasing
]

{ #category : 'accessing' }
FormSGFontTextureAtlasPageEntry >> hasSubpixelAntialiasing: anObject [
	hasSubpixelAntialiasing := anObject
]

{ #category : 'testing' }
FormSGFontTextureAtlasPageEntry >> hasValidGlyphForm [
	^ glyphForm isNotNil and: [ glyphForm width > 0 and: [glyphForm height > 0]]
]

{ #category : 'accessing' }
FormSGFontTextureAtlasPageEntry >> page [
	^ page
]

{ #category : 'accessing' }
FormSGFontTextureAtlasPageEntry >> page: anObject [
	page := anObject
]

{ #category : 'accessing' }
FormSGFontTextureAtlasPageEntry >> pixelRectangle [
	^ pixelRectangle
]

{ #category : 'accessing' }
FormSGFontTextureAtlasPageEntry >> pixelRectangle: anObject [
	pixelRectangle := anObject
]

{ #category : 'accessing' }
FormSGFontTextureAtlasPageEntry >> rectangle [
	^ rectangle
]

{ #category : 'accessing' }
FormSGFontTextureAtlasPageEntry >> rectangle: anObject [
	rectangle := anObject
]
