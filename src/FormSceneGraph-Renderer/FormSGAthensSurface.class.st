Class {
	#name : #FormSGAthensSurface,
	#superclass : #AthensCairoSurface,
	#category : #'FormSceneGraph-Renderer-Basic'
}

{ #category : #private }
FormSGAthensSurface class >> primImage: aFormat width: aWidth height: aHeight [
	^ self ffiCall: #(FormSGAthensSurface cairo_image_surface_create (int aFormat,
                                                         int aWidth,
                                                         int aHeight) )
]

{ #category : #private }
FormSGAthensSurface class >> primImageFromData: data width: width height: height pitch: stride [
	
	"CAIRO_FORMAT_ARGB32 -> 0"
	
	^ self ffiCall: #(FormSGAthensSurface cairo_image_surface_create_for_data (
		void *data,
		0,
		int width,
		int height,
		int stride) )
]

{ #category : #private }
FormSGAthensSurface >> primCreateCanvas [

	^ self ffiCall: #( FormSGAthensCanvas cairo_create (self) )
]
