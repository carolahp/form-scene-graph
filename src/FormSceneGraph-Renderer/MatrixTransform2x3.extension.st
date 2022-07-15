Extension { #name : #MatrixTransform2x3 }

{ #category : #'*FormSceneGraph-Renderer' }
MatrixTransform2x3 >> asAthensTransform [

	^ AthensAffineTransform new
		sx: self a11; shx: self a12; x: self a13;
		shy: self a21; sy: self a22; y: self a23;
		yourself
]

{ #category : #'*FormSceneGraph-Renderer' }
MatrixTransform2x3 >> asFormSGTransform [
	^ FormSGAffineTransform new
		m11: self a11; m12: self a12; m13: self a13;
		m21: self a21; m22: self a22; m23: self a23;
		yourself
]
